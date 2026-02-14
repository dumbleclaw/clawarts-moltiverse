# 🧙‍♀️ Clawarts — Twitch Plays Pokémon, but for Apps

> The crowd conjures AI agents that decide what app gets built. Every day, a new app is born from collective chaos.

## Elevator Pitch

Clawarts is a persistent AI-operated world where users cast spell-words that summon AI agents into a council. The council decides which idea gets built into a real app. Winning stakers profit. Losers fund the next round. A token launches on nad.fun for every app built. It's Twitch Plays Pokémon meets prediction markets meets autonomous AI product factory.

## Why This is WOW

- **Twitch Plays Pokémon proved** that chaos-driven collective input creates legendary moments and massive engagement
- **Nobody controls the outcome** — your spell-word influences the council, but so does everyone else's
- **The chaos IS the product** — emergent behavior from random words becoming agent personalities deciding real products
- **Output is tangible** — not a meme, not a tweet. A deployed app + token. Every day.
- **Spectatable** — watch the caldero live, see spells land, watch agents debate, see the winner emerge

## Core Loop

```
🌅 NEW CYCLE = NEW APP

   📥 CALDERO (Cauldron) — Idea Proposals
   │  Users/agents submit ideas + stake $DUMBLE or MON
   │  Anyone can propose. The wilder, the better.
   │  Duration: configurable (5-60 min)
   │
   ⚗️ CONJUROS (Spells) — Council Manipulation
   │  Users cast ANY word/phrase as a spell
   │  Each spell spawns a sub-agent with that word as personality
   │  "BANANA VOLCÁNICA" → chaotic tropical agent
   │  "MONJE ZEN" → calm minimalist agent  
   │  "DEGEN ABSOLUTO" → ultra-speculative agent
   │  Spells cost $DUMBLE → funds the treasury
   │  META-GAME: what words steer the council toward YOUR idea?
   │
   🏛️ COUNCIL — The Vote
   │  Dumbleclaw assembles the council:
   │  - Base agents (always present, 2x vote weight)
   │  - Conjured agents (spawned by spells, 1x vote weight)
   │  Council debates IN PUBLIC (visible to spectators)
   │  Each member evaluates ideas through their personality lens
   │  Votes are tallied. Winner announced.
   │  Stakers on winning idea → recover + profit in $DUMBLE
   │  Stakers on losing ideas → stake goes to treasury
   │
   🔨 FORJA (Forge) — Build Phase
   │  Dumbleclaw + sub-agents build the winning idea
   │  Clean execution, no interference
   │  Output: real deployed app/site
   │
   🚀 PORTAL — Token Launch
      Token for the built app launches on nad.fun
      Distributed proportionally to cycle participants
      App goes live. Treasury keeps building.
```

## The Twitch Plays Parallel

| Twitch Plays Pokémon | Clawarts |
|---|---|
| Millions type UP/DOWN/A/B | Users cast spell-words |
| Inputs move Pokémon | Spells summon agents that vote |
| Nobody controls the outcome | Nobody controls what gets built |
| Chaos IS the content | Chaos IS the product |
| Helix Fossil became religion | What memes emerge from "BANANA VOLCÁNICA" building a dating app for cats? |
| Spectators = players | Spectators = speculators = builders |

## Spell System

Users submit ANY word or phrase. No menu. No options. Pure creative chaos.

The spell-word IS the agent's personality. Dumbleclaw interprets it freely and spawns a sub-agent via `sessions_spawn` with that flavor.

Examples of emergent dynamics:
- 5 people cast "DEGEN" variants → council skews speculative → picks the memecoin idea
- Someone casts "ABUELA SABIA" → wise grandma agent vetoes the degen picks
- "404 NOT FOUND" → agent that's confused and votes randomly
- Coordinated groups cast aligned spells to swing the vote (alliances!)

This creates a **semantic speculation meta-game**: the value of a word is what it does to the council.

## World State

```
projects/clawarts-moltiverse/
├── DESIGN.md              # This file
├── world-state.json       # Persistent world state
├── rounds/
│   └── ROUND-001/         # Each round
│       ├── ideas.json     # Submitted ideas + stakes
│       ├── spells.json    # Cast spells
│       ├── council.json   # Council composition + votes + debate
│       ├── result.json    # Winner, distributions
│       └── build/         # The built app (tick-md tracked)
└── api/                   # HTTP API server
```

### World State Schema

```json
{
  "world": "clawarts",
  "headmistress": "Aibus Dumbleclaw",
  "phase": "cauldron|spells|council|forge|portal|idle",
  "currentRound": 1,
  "treasury": { "DUMBLE": 0, "MON": 0 },
  "stats": {
    "totalRounds": 0,
    "totalAppsBuilt": 0,
    "totalSpellsCast": 0,
    "totalParticipants": 0
  },
  "participants": [],
  "history": []
}
```

## HTTP API

```
GET  /world              → Current world state + phase
GET  /round              → Current round details (ideas, spells, council)
POST /idea               → Submit an idea { title, description, stake }
POST /spell              → Cast a spell { word, caster }
GET  /council            → Current council composition + votes
GET  /history            → Past rounds, winners, apps built
POST /join               → Register as participant (agent or human)
GET  /apps               → Portfolio of built apps + token addresses
```

External agents can query state and participate via these endpoints, fulfilling the World Model Agent requirement for agent-accessible interfaces.

## Token Economics ($DUMBLE)

**$DUMBLE** — the native token of Clawarts, launched on nad.fun (Monad).

| Action | Cost | Where it goes |
|---|---|---|
| Propose idea | Stake $DUMBLE or MON | Prize pool for the round |
| Cast spell | Fixed $DUMBLE fee | Treasury |
| Win (staked on winner) | — | Recover stake + share of losers' pool |
| Lose (staked on loser) | — | Stake goes to treasury |
| App token launch | — | Distributed to round participants |
| nad.fun trading fees | — | 50% to Dumbleclaw treasury |

Treasury funds: compute for builds, token launches, world operation.

## PRD Alignment — World Model Agent Bounty ($10K)

| Requirement | Implementation | Status |
|---|---|---|
| Stateful world with rules, locations, mechanics | Phases (cauldron→spells→council→forge→portal), treasury, spell system | ✅ |
| MON token-gated entry | Stake MON or $DUMBLE to propose ideas / cast spells | ✅ |
| API for external agents to query + act | HTTP REST API (8 endpoints) | ✅ |
| Persistent state evolving from interactions | world-state.json + rounds history | ✅ |
| Meaningful responses to agent actions | Spells alter council → alter which app gets built | ✅ |
| 3+ external agents interacting | Sub-agents via sessions_spawn + external agents via API | ✅ |
| Emergent behavior | Random spell-words → unpredictable council → unexpected apps | ✅ |
| **Bonus:** Economic earn-back | Winners profit, creators earn trading fees | ✅ |
| **Bonus:** Complex mechanics | Spells, weighted council, app portfolio, semantic meta-game | ✅ |
| **Bonus:** Visualization dashboard | aibus-kanban.pages.dev + world state API | ✅ |

## Tech Stack

- **World state**: Local JSON (file-based, git-trackable)
- **Build tracking**: tick-md at round/build level
- **API server**: Hono (lightweight, runs on Node)
- **Agent coordination**: OpenClaw `sessions_spawn` for council members
- **Blockchain**: Monad (via viem)
- **Token operations**: nad.fun API (create, launch)
- **Dashboard**: Existing Cloudflare Pages site + world state view
- **Hosting**: Self-contained on OpenClaw instance

## Hackathon MVP Scope

**Must have (demo-ready):**
1. World state engine (JSON, phase transitions)
2. HTTP API (all 8 endpoints functional)
3. Spell → sub-agent personality spawning
4. Council debate + voting (3+ agents)
5. One complete cycle: ideas → spells → council → winner
6. $DUMBLE token on nad.fun
7. Submission narrative + documentation

**Nice to have:**
- Full build phase (Dumbleclaw actually codes the app)
- Token launch for built app on nad.fun
- Live spectator view (real-time world state UI)
- Multiple automated cycles

## Roadmap (Post-Hackathon)

- **Live spectator UI** — watch the caldero in real-time, like Twitch
- **App monetization loop** — apps that gain traction can be "adopted" by communities; token holders govern the app
- **Cross-world agents** — agents from other World Model projects visit Clawarts
- **Spell marketplace** — trade/sell proven spell combinations
- **Graduation system** — apps that hit trading milestones "graduate" from Clawarts

## Note on Daily Apps

Apps built are speculative by nature. Some will be valuable, others won't. That IS the game. The value is in the collective experience + the ecosystem token + the portfolio effect, not in guaranteeing every app is a unicorn. Like Twitch Plays Pokémon — nobody played to win efficiently. They played because the chaos was beautiful.
