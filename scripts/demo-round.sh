#!/bin/bash
# demo-round.sh — Simulates a full Clawarts round with narrated activity
# Usage: ./demo-round.sh [ROUND_ID] [THEME]
# Example: ./demo-round.sh ROUND-009 "AI Tutor for Kids"
set -euo pipefail

export PATH=$HOME/.foundry/bin:$PATH
CONTRACT=0x5FbDB2315678afecb367f032d93F642f64180aa3
RPC=http://localhost:8545
ORCHESTRATOR_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
CONVEX_API=https://grandiose-cat-618.convex.site/api/clawarts

ROUND_ID="${1:-ROUND-009}"
THEME="${2:-AI Tutor for Kids}"
ROUND_BYTES=$(cast --format-bytes32-string "$ROUND_ID")

# Colors
C_RESET="\033[0m"
C_GOLD="\033[1;33m"
C_GREEN="\033[1;32m"
C_RED="\033[1;31m"
C_CYAN="\033[1;36m"
C_MAGENTA="\033[1;35m"
C_WHITE="\033[1;37m"
C_DIM="\033[2m"

# Tracking
BELIEVE_TOTAL=0
CHALLENGE_TOTAL=0
POOL_TOTAL=0
BELIEVE_COUNT=0
CHALLENGE_COUNT=0
SPELL_COUNT=0

# Ideas (name, short title, stake)
IDEAS=(
  "Luna Reyes|AI Tutor for Kids|8"
  "Alex García|DeFi para Abuelitos|5"
  "Camila Torres|NFT Music Royalties|6"
  "Tomás Ruiz|DAO Governance Bot|3"
  "Nico Vargas|ZK Identity Wallet|7"
  "Farah Khan|Climate Credit Exchange|4"
  "Yuki Sato|Onchain Skill Trees|2"
)

# Believers (address, name, idea_index, amount_eth)
BELIEVERS=(
  "0xA1b2C3d4E5f6789012345678901234567890aBcD|Luna Reyes|0|3"
  "0xB2c3D4e5F67890123456789012345678901BcDeF|Alex García|1|2.5"
  "0xC3d4E5f678901234567890123456789012CdEf01|Camila Torres|0|1.5"
  "0xD4e5F6789012345678901234567890123dEF0123|Tomás Ruiz|2|4"
  "0xE5f67890123456789012345678901234eF012345|Nico Vargas|0|5"
  "0xF6789012345678901234567890123456f0123456|Farah Khan|4|2"
  "0x78901234567890123456789012345678a1234567|Yuki Sato|0|1"
  "0x89012345678901234567890123456789b2345678|Rena Chen|2|0.5"
)

# Challengers (address, name, idea_index, amount_eth)
CHALLENGERS=(
  "0x9012345678901234567890123456789Ac3456789|Zara Contreras|0|3"
  "0x012345678901234567890123456789aBd4567890|Mateo Escéptico|1|2"
  "0x12345678901234567890123456789AbcE5678901|Jin Wei|0|1.5"
  "0x2345678901234567890123456789aBcdF6789012|Lila Dubois|4|1"
  "0x345678901234567890123456789aBcde07890123|Ravi Patel|2|0.5"
)

# Spells
SPELL_WORDS=("innovación" "disruption" "comunidad" "velocidad" "resiliencia" "transparencia" "descentralización" "empatía" "audacia" "sinergia" "metamorfosis" "alquimia")
SPELL_CASTERS=("Luna Reyes|external" "Zara Contreras|challenger" "Alex García|external" "Nico Vargas|external" "Mateo Escéptico|challenger" "Camila Torres|external" "Ravi Patel|challenger" "Farah Khan|external" "Jin Wei|challenger" "Yuki Sato|external" "Rena Chen|external" "Lila Dubois|challenger")

add_believe() { BELIEVE_TOTAL=$(echo "$BELIEVE_TOTAL + $1" | bc); POOL_TOTAL=$(echo "$POOL_TOTAL + $1" | bc); BELIEVE_COUNT=$((BELIEVE_COUNT+1)); }
add_challenge() { CHALLENGE_TOTAL=$(echo "$CHALLENGE_TOTAL + $1" | bc); POOL_TOTAL=$(echo "$POOL_TOTAL + $1" | bc); CHALLENGE_COUNT=$((CHALLENGE_COUNT+1)); }

print_pool() {
  echo -e "${C_DIM}   📊 Pool: ${POOL_TOTAL} ETH | Believers: ${BELIEVE_TOTAL} (${BELIEVE_COUNT}) | Challengers: ${CHALLENGE_TOTAL} (${CHALLENGE_COUNT})${C_RESET}"
}

progress_bar() {
  local label="$1" current="$2" total="$3"
  local pct=$((current * 100 / total))
  local filled=$((pct / 5))
  local empty=$((20 - filled))
  printf "  ${C_DIM}[${C_GREEN}"
  for ((i=0; i<filled; i++)); do printf "█"; done
  printf "${C_DIM}"
  for ((i=0; i<empty; i++)); do printf "░"; done
  printf "] %s %d/%d${C_RESET}\n" "$label" "$current" "$total"
}

get_idea_bytes() {
  local idx=$1
  IFS='|' read -r name title stake <<< "${IDEAS[$idx]}"
  echo $(cast --format-bytes32-string "$title")
}

# ═══════════════════════════════════════════════════════════════
# PHASE 0: Banner
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}╔══════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_MAGENTA}║  🔮 CLAWARTS — DEMO ROUND SIMULATOR          ║${C_RESET}"
echo -e "${C_MAGENTA}║  Ronda: ${ROUND_ID}  Tema: ${THEME}${C_RESET}"
echo -e "${C_MAGENTA}╚══════════════════════════════════════════════╝${C_RESET}"
echo ""
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 1: Start Round
# ═══════════════════════════════════════════════════════════════
echo -e "${C_MAGENTA}━━━ FASE 1: Apertura de Ronda ━━━${C_RESET}"
echo -e "${C_GOLD}🔮 Aibus Dumbleclaw abre la Ronda ${ROUND_ID}...${C_RESET}"
cast send $CONTRACT "startRound(bytes32)" $ROUND_BYTES \
  --private-key $ORCHESTRATOR_KEY --rpc-url $RPC --quiet 2>&1 | tail -1
echo -e "${C_GREEN}✅ Ronda ${ROUND_ID} abierta onchain${C_RESET}"
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 2: Ideas (Convex API)
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}━━━ FASE 2: Propuestas de Ideas (${#IDEAS[@]}) ━━━${C_RESET}"
IDEA_NUM=0
for idea_entry in "${IDEAS[@]}"; do
  IDEA_NUM=$((IDEA_NUM+1))
  IFS='|' read -r name title stake <<< "$idea_entry"
  echo -e "${C_GOLD}💡 ${name} propone: \"${title}\" (${stake} \$STEALTH)${C_RESET}"

  # POST to Convex API (best-effort, don't fail script)
  curl -s -X POST "${CONVEX_API}/idea" \
    -H "Content-Type: application/json" \
    -d "{\"roundId\":\"${ROUND_ID}\",\"title\":\"${title}\",\"founder\":\"${name}\",\"stake\":${stake}}" \
    > /dev/null 2>&1 || true

  progress_bar "Ideas" $IDEA_NUM ${#IDEAS[@]}
  sleep 0.5
done
echo -e "${C_GREEN}✅ ${#IDEAS[@]} ideas registradas${C_RESET}"
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 3: Stakes via Impersonation
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}━━━ FASE 3: Believes & Challenges (13 stakes) ━━━${C_RESET}"

do_stake() {
  local addr="$1" name="$2" idea_idx="$3" amount="$4" is_challenge="$5"
  local idea_bytes=$(get_idea_bytes $idea_idx)
  IFS='|' read -r _iname title _istake <<< "${IDEAS[$idea_idx]}"

  # Fund the account (anvil expects hex wei)
  cast rpc anvil_setBalance "$addr" "0x56bc75e2d63100000" --rpc-url $RPC > /dev/null 2>&1

  # Impersonate
  cast rpc anvil_impersonateAccount "$addr" --rpc-url $RPC > /dev/null 2>&1

  if [ "$is_challenge" = "true" ]; then
    echo -e "${C_RED}⚔️  ${name} desafía \"${title}\" con ${amount} ETH${C_RESET}"
    cast send $CONTRACT "challenge(bytes32,bytes32)" $ROUND_BYTES $idea_bytes \
      --from "$addr" --value "${amount}ether" --rpc-url $RPC --unlocked --quiet 2>&1 | tail -1
    add_challenge "$amount"

    # Register in Convex
    curl -s -X POST "${CONVEX_API}/fund" \
      -H "Content-Type: application/json" \
      -d "{\"roundId\":\"${ROUND_ID}\",\"ideaTitle\":\"${title}\",\"funder\":\"${name}\",\"amount\":${amount},\"type\":\"challenge\",\"wallet\":\"${addr}\"}" \
      > /dev/null 2>&1 || true
  else
    echo -e "${C_GREEN}🙌 ${name} cree en \"${title}\" con ${amount} ETH${C_RESET}"
    cast send $CONTRACT "believe(bytes32,bytes32)" $ROUND_BYTES $idea_bytes \
      --from "$addr" --value "${amount}ether" --rpc-url $RPC --unlocked --quiet 2>&1 | tail -1
    add_believe "$amount"

    curl -s -X POST "${CONVEX_API}/fund" \
      -H "Content-Type: application/json" \
      -d "{\"roundId\":\"${ROUND_ID}\",\"ideaTitle\":\"${title}\",\"funder\":\"${name}\",\"amount\":${amount},\"type\":\"believe\",\"wallet\":\"${addr}\"}" \
      > /dev/null 2>&1 || true
  fi

  # Stop impersonating
  cast rpc anvil_stopImpersonatingAccount "$addr" --rpc-url $RPC > /dev/null 2>&1

  print_pool
  sleep 0.7
}

STAKE_NUM=0
TOTAL_STAKES=$(( ${#BELIEVERS[@]} + ${#CHALLENGERS[@]} ))

for entry in "${BELIEVERS[@]}"; do
  STAKE_NUM=$((STAKE_NUM+1))
  IFS='|' read -r addr name idx amt <<< "$entry"
  do_stake "$addr" "$name" "$idx" "$amt" "false"
  progress_bar "Stakes" $STAKE_NUM $TOTAL_STAKES
done

for entry in "${CHALLENGERS[@]}"; do
  STAKE_NUM=$((STAKE_NUM+1))
  IFS='|' read -r addr name idx amt <<< "$entry"
  do_stake "$addr" "$name" "$idx" "$amt" "true"
  progress_bar "Stakes" $STAKE_NUM $TOTAL_STAKES
done

echo -e "${C_GREEN}✅ ${TOTAL_STAKES} stakes registrados onchain${C_RESET}"
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 4: Spells (Convex API)
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}━━━ FASE 4: Conjuros Mágicos (${#SPELL_CASTERS[@]} spells) ━━━${C_RESET}"

SPELL_NUM=0
for caster_entry in "${SPELL_CASTERS[@]}"; do
  SPELL_NUM=$((SPELL_NUM+1))
  IFS='|' read -r caster_name caster_type <<< "$caster_entry"
  word_idx=$(( (SPELL_NUM - 1) % ${#SPELL_WORDS[@]} ))
  word="${SPELL_WORDS[$word_idx]}"

  if [ "$caster_type" = "challenger" ]; then
    weight="4x"
    echo -e "${C_RED}🪄 ${caster_name} conjura '${word}' (${caster_type}, peso ${weight})${C_RESET}"
  else
    weight="1x"
    echo -e "${C_CYAN}🪄 ${caster_name} conjura '${word}' (${caster_type}, peso ${weight})${C_RESET}"
  fi

  curl -s -X POST "${CONVEX_API}/spell" \
    -H "Content-Type: application/json" \
    -d "{\"roundId\":\"${ROUND_ID}\",\"caster\":\"${caster_name}\",\"word\":\"${word}\",\"casterType\":\"${caster_type}\",\"weight\":\"${weight}\"}" \
    > /dev/null 2>&1 || true

  SPELL_COUNT=$((SPELL_COUNT+1))
  progress_bar "Spells" $SPELL_NUM ${#SPELL_CASTERS[@]}
  sleep 0.5
done

echo -e "${C_GREEN}✅ ${SPELL_COUNT} conjuros lanzados${C_RESET}"
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 5: Settlement
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}━━━ FASE 5: Resolución ━━━${C_RESET}"

# Winner is idea 0 (AI Tutor for Kids — most believe ETH)
IFS='|' read -r winner_founder winner_title _ws <<< "${IDEAS[0]}"
WINNER_BYTES=$(cast --format-bytes32-string "$winner_title")

echo -e "${C_WHITE}⏳ El Consejo delibera...${C_RESET}"
sleep 2
echo -e "${C_GOLD}⚖️  El Consejo ha decidido. Settling onchain...${C_RESET}"

cast send $CONTRACT "settle(bytes32,bytes32)" $ROUND_BYTES $WINNER_BYTES \
  --private-key $ORCHESTRATOR_KEY --rpc-url $RPC --quiet 2>&1 | tail -1

TREASURY=$(echo "$POOL_TOTAL * 0.10" | bc)
PARTICIPANTS=$((BELIEVE_COUNT + CHALLENGE_COUNT + SPELL_COUNT))

echo -e "${C_GREEN}🏆 ¡\"${winner_title}\" gana la ronda! Treasury: +${TREASURY} ETH${C_RESET}"
sleep 1

# ═══════════════════════════════════════════════════════════════
# PHASE 6: Summary
# ═══════════════════════════════════════════════════════════════
echo ""
echo -e "${C_MAGENTA}╔══════════════════════════════════════════════╗${C_RESET}"
echo -e "${C_MAGENTA}║  🏆 RONDA ${ROUND_ID} — COMPLETADA              ║${C_RESET}"
echo -e "${C_MAGENTA}╠══════════════════════════════════════════════╣${C_RESET}"
echo -e "${C_MAGENTA}║  Ganador:      ${winner_title}${C_RESET}"
echo -e "${C_MAGENTA}║  Pool:         ${POOL_TOTAL} ETH${C_RESET}"
echo -e "${C_MAGENTA}║  Believers:    ${BELIEVE_COUNT} (${BELIEVE_TOTAL} ETH)${C_RESET}"
echo -e "${C_MAGENTA}║  Challengers:  ${CHALLENGE_COUNT} (${CHALLENGE_TOTAL} ETH)${C_RESET}"
echo -e "${C_MAGENTA}║  Spells:       ${SPELL_COUNT}${C_RESET}"
echo -e "${C_MAGENTA}║  Treasury:     ${TREASURY} ETH${C_RESET}"
echo -e "${C_MAGENTA}║  Participantes: ${PARTICIPANTS}${C_RESET}"
echo -e "${C_MAGENTA}╚══════════════════════════════════════════════╝${C_RESET}"
echo ""
echo -e "${C_DIM}Done. Run check-round.sh ${ROUND_ID} to verify onchain state.${C_RESET}"
