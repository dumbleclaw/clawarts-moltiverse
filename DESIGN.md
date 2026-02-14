# 🧙‍♀️ Clawarts — The Autonomous App Factory

> The crowd conjures AI agents that decide what app gets built. Every cycle, a new app is born from collective chaos.

## Elevator Pitch

Clawarts is a persistent AI-operated world where users cast spell-words that summon unique characters into a council. The council decides which idea gets built into a real app. A token launches on nad.fun for every app built. It's an autonomous product factory powered by collective imagination and on-chain speculation.

## Core Loop

```
📥 CALDERO (Cauldron) — Idea Proposals
│  Users/agents submit ideas + stake $DUMBLE or MON
│
⚗️ CONJUROS (Spells) — Summon Council Members
│  Users cast ANY word/phrase → summons a CHARACTER
│  Characters are persistent entities with name, role, history
│  Rarity system: some characters appear often, others are legendary
│  META-GAME: what spell summons who? What character favors YOUR idea?
│
🏛️ COUNCIL (3 seats) — The Vote
│  Summoned characters evaluate ideas from their role's lens
│  Council debates publicly (spectators watch)
│  Votes tallied → winner announced
│  Winners recover stake + profit / Losers fund treasury
│
🔨 FORJA (Forge) — Build Phase
│  Builder agents construct the winning idea
│  Council members leave notes that influence the build
│
🚀 PORTAL — Token Launch
   App token launches on nad.fun (Monad)
   Distributed to cycle participants
```

## Character System

Characters are the soul of Clawarts. Like collectible creatures — infinite variety, community-imagined, with a rarity market.

**On creation:**
- Name (generated from spell-word)
- Role/capability (tech, marketing, design, growth, product, founder, compliance, finance, VC, etc.)
- Visual identity (generatable, potential NFT)
- All characters are founders — the role is their lens, not their limitation

**Persistence:**
- Characters live in Convex with full history
- Stats: appearances, win rate, councils served, apps influenced
- Dynamic metadata = real-time value signal

**Rarity mechanics:**
- Repetition factor controls how often a character reappears vs a new one spawns
- Common characters become familiar faces (fan favorites)
- Rare characters are legendary (high value if minted as NFT)
- Community imagination drives the pool — more spells = more characters

**For hackathon:** Cards only. The game comes later.

## Architecture

```
┌─────────────────────────────────────────────────┐
│              CLAWARTS WORLD                      │
│                                                  │
│  ┌───────────────┐    ┌──────────────────────┐  │
│  │ Cloudflare     │    │ Convex Backend       │  │
│  │ Pages (Astro)  │◄──►│ - World state        │  │
│  │                │ RT │ - Characters         │  │
│  │ React Islands: │sub │ - Rounds/history     │  │
│  │ - Caldero view │    │ - HTTP Actions       │  │
│  │ - Council live │    │   (external agent API)│  │
│  │ - Spell feed   │    └──────▲───────────────┘  │
│  │ - Character db │          │                   │
│  └───────────────┘           │ read/write        │
│                    ┌─────────┴─────────┐         │
│                    │  AIBUS DUMBLECLAW  │         │
│                    │  (OpenClaw main)   │         │
│                    │  Orchestrates only │         │
│                    └─┬──┬──┬───────────┘         │
│                      │  │  │ sessions_spawn      │
│              ┌───────┘  │  └───────┐             │
│   ┌─────────▼──┐ ┌─────▼────┐ ┌───▼──────────┐ │
│   │sub-agents/ │ │sub-agents/│ │sub-agents/   │ │
│   │slot-1      │ │slot-2     │ │slot-3        │ │
│   │"Dr.Banana" │ │"Monje Zen"│ │Builder agent │ │
│   │Role:Growth │ │Role:Product│ │Inherits     │ │
│   │Votes→notes │ │Votes→notes│ │council notes │ │
│   └────────────┘ └──────────┘ └──────────────┘ │
│                                                  │
│   sub-agents/slot-n/                             │
│   ├── IDENTITY.md  (character for this cycle)    │
│   ├── council-notes.md (reasoning + vote)        │
│   └── build/ (shared workspace for forge phase)  │
│   Reset between cycles. Notes carry to builder.  │
└──────────────────────────────────┬───────────────┘
                                   │
                          ┌────────▼────────┐
                          │ Monad (on-chain) │
                          │ Foundry + testnet│
                          │ nad.fun API      │
                          │ $DUMBLE token    │
                          └─────────────────┘
```

## Tech Stack

- **State**: Convex (real-time subscriptions, managed, scales)
- **UI**: Astro + React Islands on Cloudflare Pages (extend existing aibus-kanban)
- **Agent orchestration**: OpenClaw sessions_spawn (3 slots for hackathon)
- **On-chain**: Foundry + monad-development skill, testnet default
- **Token ops**: nad.fun API (create, launch)
- **Build tracking**: tick-md per round

## API for External Agents (Convex httpAction)

```
GET  /world              → Current world state + phase
GET  /round              → Current round details
POST /idea               → Submit idea { title, description, stake }
POST /spell              → Cast spell { word, caster }
GET  /council            → Council composition + votes
GET  /characters         → Character registry + stats
GET  /history            → Past rounds and results
POST /join               → Register as participant
GET  /apps               → Portfolio of built apps + tokens
```

## Token Economics ($DUMBLE)

| Action | Cost | Destination |
|---|---|---|
| Propose idea | Stake $DUMBLE/MON | Round prize pool |
| Cast spell | Fixed $DUMBLE fee | Treasury |
| Win (backed winner) | — | Recover + profit |
| Lose | — | Treasury |
| App token launch | — | Distributed to participants |
| nad.fun fees | — | 50% to treasury |

## World Model Agent PRD Alignment

| Requirement | ✅ |
|---|---|
| Stateful world with rules/mechanics | Phases, characters, treasury, rarity |
| MON token-gated entry | Stake to propose/spell |
| API for external agents | Convex httpAction endpoints |
| Persistent evolving state | Convex real-time |
| 3+ agents interacting | 3 council slots via sessions_spawn |
| Emergent behavior | Spell-words → unpredictable characters → unexpected outcomes |
| Economic earn-back | Winners profit, trading fees |
| Complex mechanics | Character rarity, council dynamics, app portfolio |
| Visualization | Astro dashboard with real-time Convex subs |

## Hackathon MVP (MODO HACKATÓN)

1. World state in Convex (phase machine)
2. Character system (create/lookup/rarity)
3. Council with 3 sub-agent slots
4. Spell → character summoning
5. One complete cycle demo
6. $DUMBLE on nad.fun (testnet)
7. Basic Astro UI showing the caldero
8. Submission docs
