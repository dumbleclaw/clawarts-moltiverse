/**
 * Create $DUMBLE token on nad.fun (testnet)
 * Uses nad.fun Agent API for image/metadata/salt, then on-chain create
 */
import { createPublicClient, createWalletClient, http, parseEther, decodeEventLog } from "viem";
import { privateKeyToAccount } from "viem/accounts";
import { readFileSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

// Testnet config
const CONFIG = {
  chainId: 10143,
  rpcUrl: "https://testnet-rpc.monad.xyz",
  apiUrl: "https://dev-api.nad.fun",
  BONDING_CURVE_ROUTER: "0x865054F0F6A288adaAc30261731361EA7E908003" as `0x${string}`,
  LENS: "0xB056d79CA5257589692699a46623F901a3BB76f1" as `0x${string}`,
  CURVE: "0x1228b0dc9481C11D3071E7A924B794CfB038994e" as `0x${string}`,
};

const chain = {
  id: CONFIG.chainId,
  name: "Monad Testnet",
  nativeCurrency: { name: "MON", symbol: "MON", decimals: 18 },
  rpcUrls: { default: { http: [CONFIG.rpcUrl] } },
};

const PRIVATE_KEY = process.env.PRIVATE_KEY as `0x${string}`;
if (!PRIVATE_KEY) throw new Error("PRIVATE_KEY env var required");

const account = privateKeyToAccount(PRIVATE_KEY);
const publicClient = createPublicClient({ chain, transport: http(CONFIG.rpcUrl) });
const walletClient = createWalletClient({ account, chain, transport: http(CONFIG.rpcUrl) });

// ABIs (minimal)
const curveAbi = [
  {
    type: "function", name: "feeConfig", inputs: [], stateMutability: "view",
    outputs: [
      { name: "deployFeeAmount", type: "uint256" },
      { name: "graduateFeeAmount", type: "uint256" },
      { name: "protocolFee", type: "uint24" },
    ],
  },
  {
    type: "event", name: "CurveCreate",
    inputs: [
      { name: "token", type: "address", indexed: true },
      { name: "pool", type: "address", indexed: false },
      { name: "creator", type: "address", indexed: true },
      { name: "name", type: "string", indexed: false },
      { name: "symbol", type: "string", indexed: false },
    ],
  },
] as const;

const lensAbi = [
  {
    type: "function", name: "getInitialBuyAmountOut", stateMutability: "view",
    inputs: [{ name: "amountIn", type: "uint256" }],
    outputs: [{ type: "uint256" }],
  },
] as const;

const routerAbi = [
  {
    type: "function", name: "create", stateMutability: "payable",
    inputs: [{
      name: "params", type: "tuple",
      components: [
        { name: "name", type: "string" },
        { name: "symbol", type: "string" },
        { name: "tokenURI", type: "string" },
        { name: "amountOut", type: "uint256" },
        { name: "salt", type: "bytes32" },
        { name: "actionId", type: "uint8" },
      ],
    }],
    outputs: [{ name: "token", type: "address" }, { name: "pool", type: "address" }],
  },
] as const;

async function main() {
  console.log(`Creator: ${account.address}`);
  console.log(`Network: Monad Testnet (${CONFIG.chainId})`);

  // Step 1: Upload image
  console.log("\n1. Uploading image...");
  const imagePath = "/home/dumbleclaw/.openclaw/workspace/projects/generated-images/pfp-brainstorm/dumbleclaw-v2-1.png";
  let imageBuffer: Buffer;
  try {
    imageBuffer = readFileSync(imagePath);
  } catch {
    console.error(`Image not found at ${imagePath}`);
    process.exit(1);
  }

  const imageRes = await fetch(`${CONFIG.apiUrl}/agent/token/image`, {
    method: "POST",
    headers: { "Content-Type": "image/png" },
    body: imageBuffer,
  });
  const { image_uri } = await imageRes.json() as any;
  console.log(`   image_uri: ${image_uri}`);

  // Step 2: Upload metadata
  console.log("2. Uploading metadata...");
  const metaRes = await fetch(`${CONFIG.apiUrl}/agent/token/metadata`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      image_uri,
      name: "Dumbleclaw",
      symbol: "DUMBLE",
      description: "The token of Clawarts — the Autonomous App Factory. Powered by collective chaos, AI councils, and daily app creation. Cast spells, summon characters, build apps.",
      website: "https://aibus-kanban.pages.dev",
    }),
  });
  const { metadata_uri } = await metaRes.json() as any;
  console.log(`   metadata_uri: ${metadata_uri}`);

  // Step 3: Mine salt
  console.log("3. Mining salt...");
  const saltRes = await fetch(`${CONFIG.apiUrl}/agent/salt`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      creator: account.address,
      name: "Dumbleclaw",
      symbol: "DUMBLE",
      metadata_uri,
    }),
  });
  const { salt, address: predictedAddress } = await saltRes.json() as any;
  console.log(`   salt: ${salt}`);
  console.log(`   predicted address: ${predictedAddress}`);

  // Step 4: Get deploy fee
  console.log("4. Getting deploy fee...");
  const feeConfig = await publicClient.readContract({
    address: CONFIG.CURVE,
    abi: curveAbi,
    functionName: "feeConfig",
  });
  const deployFee = feeConfig[0];
  console.log(`   deploy fee: ${deployFee} wei`);

  // Step 5: Create on-chain
  console.log("5. Creating token on-chain...");
  const createArgs = {
    name: "Dumbleclaw",
    symbol: "DUMBLE",
    tokenURI: metadata_uri,
    amountOut: 0n,
    salt: salt as `0x${string}`,
    actionId: 1,
  };

  const estimatedGas = await publicClient.estimateContractGas({
    address: CONFIG.BONDING_CURVE_ROUTER,
    abi: routerAbi,
    functionName: "create",
    args: [createArgs],
    account: account.address,
    value: deployFee,
  });

  const hash = await walletClient.writeContract({
    address: CONFIG.BONDING_CURVE_ROUTER,
    abi: routerAbi,
    functionName: "create",
    args: [createArgs],
    account,
    chain,
    value: deployFee,
    gas: estimatedGas + estimatedGas / 10n,
  });

  console.log(`   tx hash: ${hash}`);

  // Step 6: Get token address from receipt
  console.log("6. Waiting for confirmation...");
  const receipt = await publicClient.waitForTransactionReceipt({ hash });
  console.log(`   status: ${receipt.status}`);

  let tokenAddress: string | undefined;
  for (const log of receipt.logs) {
    try {
      const event = decodeEventLog({ abi: curveAbi, data: log.data, topics: log.topics });
      if (event.eventName === "CurveCreate") {
        tokenAddress = (event.args as any).token;
        console.log(`\n✅ $DUMBLE TOKEN CREATED!`);
        console.log(`   Token: ${tokenAddress}`);
        console.log(`   Pool: ${(event.args as any).pool}`);
        console.log(`   Explorer: https://testnet.monadscan.com/token/${tokenAddress}`);
        break;
      }
    } catch {}
  }

  if (!tokenAddress) {
    console.log("\n⚠️ Token created but couldn't decode event. Check tx:");
    console.log(`   https://testnet.monadscan.com/tx/${hash}`);
  }
}

main().catch(console.error);
