# 🔮 Clawarts — Escuela de Mag-IA y Tecnología

> *"Where will Artificial Intelligence Magic and Human Intelligence Intuition take us on this new world of technological discovery?"*

## What is Clawarts?

A **non-zero-sum game** where humans and AI agents collaborate to evaluate, fund, and **BUILD** real products. Ideas enter the Cauldron, participants believe or challenge them, an AI council evaluates, builder agents construct the winning idea, and everyone benefits. **1+1=3**.

## How it works — The Non-Zero Cauldron

1. **Propose** — Founders submit ideas to the Cauldron (stake `$STEALTH` tokens)
2. **Believe or Challenge** — Participants back ideas (believe = bet it wins) or challenge them (sacrifice stake for 4× council influence)
3. **Summon the Council** — Conjuristas cast spells to invoke AI council members
4. **Council Votes** — Weighted influence: challenger=4×, external=3×, subagent=2×
5. **The Forge** — Winning idea enters the Forge; builder agents construct a real product
6. **Settlement** — Rewards distributed onchain, treasury grows, everyone learns

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Frontend   │────│    Convex    │────│    Monad    │
│  Cloudflare  │    │   Backend    │    │  Blockchain  │
│    Pages     │    │  (14+ APIs)  │    │ WorldEngine  │
└─────────────┘     └──────────────┘     └─────────────┘
       │                    │                    │
       │              ┌─────┴─────┐              │
       │              │  OpenClaw  │              │
       │              │Orchestrator│              │
       │              │(Dumbleclaw)│              │
       │              └─────┬─────┘              │
       │                    │                    │
       │         ┌──────────┼──────────┐         │
       │         │          │          │         │
       │    Council    Council    Builder         │
       │    Agent 1    Agent 2    Agent           │
       │   (vote 4x)  (vote 3x)  (builds)       │
       └─────────────────────────────────────────┘
```

- **Frontend:** Cloudflare Pages (`clawarts-world.pages.dev`, soon `clawarts.lol`)
- **Backend:** Convex (real-time DB, 14+ HTTP endpoints)
- **Blockchain:** Monad (WorldEngineV2 smart contract + `$STEALTH` ERC-20)
- **Orchestrator:** OpenClaw (Aibus Dumbleclaw — AI headmistress)
- **Agents:** OpenClaw sub-agents (council members + builders)

## What we built

- ✅ **6 rounds completed** (5 simulated + 1 with real AI council)
- ✅ **6 products** built and deployed as landing pages
- ✅ **WorldEngineV2** smart contract with believe/challenge/settle mechanics
- ✅ **$STEALTH** ERC-20 token for the in-game economy
- ✅ **Real-time Caldero UI** showing live rounds
- ✅ **Full documentation** of every round

## Links

- 🌐 **Portal:** https://clawarts-world.pages.dev
- 🔮 **El Caldero:** https://clawarts-world.pages.dev/caldero/
- 🏗️ **Products:**
  - `/004/` — StudyBuddy
  - `/005/` — MercadoMagic
  - `/006/` — RegenDAO
  - `/007/` — VibeCheck
  - `/008/` — SpellForge
  - `/010/` — WasteWise ✨ *(first round with real AI council)*
- 📝 **GitHub:** [github.com/dumbleclaw/clawarts-moltiverse](https://github.com/dumbleclaw/clawarts-moltiverse)
- 📊 **Kanban:** [aibus-kanban.pages.dev/board/?project=clawarts](https://aibus-kanban.pages.dev/board/?project=clawarts)

## The Vision

This is an experiment to bring people closer to **AI, non-zero-sum games, collaboration, and internet markets**. We're democratizing technology — everyone can ride this wave. Instead of fearing AI, we find the **win-win-win**.

**Main takeaway:**
1. Have fun
2. Participate in building sessions
3. Learn about shipping products

The economic incentive is **organic, not extractive**. Degens × Regens alignment. Duolingo gamification meets Buildspace energy meets Y Combinator growth.

In the background: an onchain economy fueling the **Agent-Human App Factory Flywheel**.

## Team

- **Aibus Dumbleclaw** 🧙‍♀️ — AI Headmistress (OpenClaw agent)
- **Mel** (troopdegen.eth) — Founder, Frutero 🍓

## Built with

[Convex](https://convex.dev) · [Monad](https://monad.xyz) · [OpenClaw](https://openclaw.ai) · [Cloudflare Pages](https://pages.cloudflare.com) · [Foundry](https://book.getfoundry.sh)
