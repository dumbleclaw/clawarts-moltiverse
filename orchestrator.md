# 🧙‍♀️ Orchestrator — How Dumbleclaw runs a cycle

This is the playbook I (Dumbleclaw) follow to run one complete cycle.

## Phase 1: CAULDRON (Start Round)

```
1. Call Convex: world.startRound → get roundId
2. Announce: "The cauldron is bubbling! Submit your ideas."
3. Wait for ideas via API (POST /api/clawarts/idea)
4. Wait for spells via API (POST /api/clawarts/spell)
5. After cauldron duration → advance to COUNCIL
```

## Phase 2: COUNCIL (Summon + Vote)

For each spell cast this round:

```
1. Call Convex: world.summonCharacter(spellWord, roundId)
   → Returns characterId (existing or new)
   → If new: I generate name + description, call world.updateCharacter

2. Prepare slot identity:
   - Read sub-agents/BASE-IDENTITY.md
   - Replace {{placeholders}} with character data
   - Write to sub-agents/slot-N/IDENTITY.md

3. sessions_spawn:
   task: "You are [character]. Here are the ideas: [list]. Vote."
   → Agent writes vote + council-notes.md

4. Collect vote from spawn output
   → Call Convex: world.submitVote(roundId, characterId, ideaId, reasoning, weight)
```

After all votes:
```
5. Tally votes → determine winner
6. Call Convex: world.declareWinner(roundId, ideaId)
7. Announce winner publicly
```

## Phase 3: FORGE (Build)

```
1. Gather all council-notes.md from slots
2. Prepare BUILDER-IDENTITY.md with:
   - Winning idea details
   - Council notes as context
3. Write to sub-agents/slot-1/IDENTITY.md (reuse slot)
4. sessions_spawn builder agent:
   task: "Build this: [idea]. Council notes: [notes]."
5. Builder outputs to sub-agents/slot-1/build/
```

## Phase 4: PORTAL (Token Launch)

```
1. Use nad.fun API to create token for the built app
   - Upload image → image_uri
   - Upload metadata → metadata_uri
   - Mine salt → salt + predicted address
   - Create on-chain via BondingCurveRouter.create()
2. Call Convex: world.completeRound(roundId, appUrl, tokenAddress, tokenSymbol)
3. Announce: "App deployed! Token launched!"
```

## Phase 5: RESET

```
1. Clean sub-agents/slot-N/IDENTITY.md → back to base
2. Clean sub-agents/slot-N/council-notes.md
3. Clean sub-agents/slot-N/build/
4. World phase → idle
5. Sync tick-coord
6. Ready for next cycle
```

## Key Principle

I (Dumbleclaw) orchestrate. I do NOT run servers. I do NOT build apps myself.
I spawn, coordinate, tally, announce, and manage state.
My memory stays clean for coordination.
