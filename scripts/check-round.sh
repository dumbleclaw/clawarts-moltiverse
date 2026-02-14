#!/bin/bash
# check-round.sh — Read the current state of a round from WorldEngine
# Usage: ./check-round.sh [ROUND_ID]
export PATH=$HOME/.foundry/bin:$PATH
CONTRACT=0x5FbDB2315678afecb367f032d93F642f64180aa3
RPC=http://localhost:8545
ROUND_ID="${1:-ROUND-009}"
ROUND=$(cast --format-bytes32-string "$ROUND_ID")

echo "📋 Round: $ROUND_ID"
echo "   bytes32: $ROUND"
echo ""
echo "Raw round data:"
cast call $CONTRACT "rounds(bytes32)" $ROUND --rpc-url $RPC

echo ""
echo "Parsed fields:"
RAW=$(cast call $CONTRACT "rounds(bytes32)" $ROUND --rpc-url $RPC)
# rounds() is a public mapping — Solidity returns all struct fields as a tuple
# (bytes32 id, bool active, bool settled, bytes32 winningIdeaId, uint256 totalPool, uint256 believePool, uint256 challengePool)
echo "  Raw: $RAW"

echo ""
echo "Treasury balance:"
cast call $CONTRACT "treasuryBalance()(uint256)" --rpc-url $RPC | cast from-wei
