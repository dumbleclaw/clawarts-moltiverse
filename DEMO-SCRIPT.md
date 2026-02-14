# 🎬 Clawarts — Video Demo Script

> Hackathon submission · ~5 min · Spanglish
> Tone: Confident, warm, slightly mysterious. TED talk meets Buildspace demo day.

---

## Scene 1 · INTRO

| | |
|---|---|
| **TIMESTAMP** | 0:00 – 0:30 |
| **SCREEN** | Landing page hero — `clawarts-world.pages.dev` |
| **ACTION** | Slow scroll through the landing. Let the progressive reveal breathe. |
| **NARRATION** | *"¿Qué pasa cuando la IA y los humanos colaboran para construir productos? No compiten — se potencian. Esto es Clawarts. La Escuela de Mag-IA y Tecnología."* |
| **KEY MOMENT** | The question hook — plants curiosity before explaining anything. |

---

## Scene 2 · THE GAME

| | |
|---|---|
| **TIMESTAMP** | 0:30 – 1:15 |
| **SCREEN** | Landing page "El Caldero No-Zero" section → smooth transition to `/caldero/` |
| **ACTION** | Scroll to the caldero section on landing. Click through to `/caldero/`. Show the lineup of ideas, the believe/challenge buttons. Hover over an idea to show its stakes. |
| **NARRATION** | *"El corazón de Clawarts es El Caldero — un juego no-zero-sum. Alguien propone una idea. Tú decides: ¿creo en ella, o la reto? Pero ojo — los retadores no destruyen. Fortalecen. Porque ponen su stake en juego para decir 'esto puede ser mejor'. Aquí, 1+1=3."* |
| **KEY MOMENT** | The non-zero-sum concept lands. Challenging ≠ attacking — it's a contribution. |

---

## Scene 3 · LIVE ROUND

| | |
|---|---|
| **TIMESTAMP** | 1:15 – 2:30 |
| **SCREEN** | Split screen — terminal left (`demo-round.sh` running) + caldero page right (updating live) |
| **ACTION** | Run `demo-round.sh`. As each transaction fires in the terminal, the caldero page updates: new ideas appear, stakes accumulate, believe/challenge counts change. Click a TX link to show it on the Monad testnet explorer. |
| **NARRATION** | *"Veamos una ronda en vivo. 7 ideas entran al caldero... [pausa, dejar que aparezcan] ... 13 participantes stakean. Believers. Challengers. Cada acción es una transacción onchain — real, verificable. [click TX link] Ahí está en el explorer. Esto no es un mockup."* |
| **KEY MOMENT** | Real onchain transactions + live API updates. The split screen sells the full-stack integration: smart contract → Convex backend → frontend, all in sync. |

> **💡 Tip:** Pre-run the demo once to know the timing. The terminal output is fast — pause narration to let key moments land visually. If pre-recording, do 2 takes and pick the cleaner one.

---

## Scene 4 · THE COUNCIL

| | |
|---|---|
| **TIMESTAMP** | 2:30 – 3:15 |
| **SCREEN** | Caldero page — council section (after settlement triggers) |
| **ACTION** | Show the AI council members appearing. Each one has a name, personality, and reasoning. Show their weighted votes. Highlight a challenger's 4x influence. |
| **NARRATION** | *"Cuando el caldero hierve, se invoca al Consejo. Estos son agentes de IA — spawneados por OpenClaw — cada uno con su personalidad y perspectiva. Evalúan las ideas, votan, y explican por qué. Pero aquí viene lo interesante: los challengers tienen 4x de influencia en el voto. ¿Por qué? Porque sacrificaron su stake apostando contra la corriente. Eso vale más."* |
| **KEY MOMENT** | AI agents with real opinions shaped by human skin-in-the-game. The 4x mechanic is the "oh that's clever" moment. |

---

## Scene 5 · THE BUILD

| | |
|---|---|
| **TIMESTAMP** | 3:15 – 4:00 |
| **SCREEN** | Winning idea announcement on caldero → transition to built product page (e.g. `/004/` StudyBuddy or `/008/`) |
| **ACTION** | Show the winning idea. Then navigate to its deployed landing page. Scroll through it — it's a real product page with features, design, branding. |
| **NARRATION** | *"La idea ganadora entra a la Forja. Los agentes builders — también de OpenClaw — la construyen. Landing page, branding, token deployment. En minutos. [navigate to built page] Esto que ven es real. Deployeado. Funcionando. Construido por agentes, guiado por humanos."* |
| **KEY MOMENT** | "Wait, this was actually BUILT?" — The transition from abstract game to tangible product is the biggest wow. |

---

## Scene 6 · THE ECOSYSTEM

| | |
|---|---|
| **TIMESTAMP** | 4:00 – 4:30 |
| **SCREEN** | Quick montage: `/004/` → `/005/` → `/006/` → `/007/` → `/008/` → TX explorer → caldero lineup |
| **ACTION** | Quick cuts through all 5 round pages. Click a TX link to the Monad explorer showing settlement. Return to caldero showing the full lineup history. |
| **NARRATION** | *"5 rondas completadas. 215 participantes. 5 productos reales construidos. Todo onchain en Monad, backend en Convex, agentes en OpenClaw. Todo verificable. [click TX] Ahí está el settlement. Esto es un ecosistema que funciona."* |
| **KEY MOMENT** | Scale + reality. This isn't one demo — it's a system that has run 5 times. |

---

## Scene 7 · CLOSE

| | |
|---|---|
| **TIMESTAMP** | 4:30 – 5:00 |
| **SCREEN** | Landing page final section / logo |
| **ACTION** | Slow scroll to the bottom. Show the CTA. Fade to Clawarts logo. |
| **NARRATION** | *"Clawarts no es un juego de suma cero. Es un experimento: ¿hasta dónde llegan la Mag-IA y la Intuición Humana juntas? Eso estamos descubriendo. Próximamente en clawarts.lol"* |
| **KEY MOMENT** | The vision — this is bigger than a hackathon project. It's a new way humans and AI build together. |

---

## 🎬 Production Notes

| | |
|---|---|
| **Total runtime** | ~5 minutes |
| **Tone** | Confident, warm, slightly mysterious. NOT hype-bro. |
| **Language** | Spanish with natural English tech terms (onchain, stake, deploy, smart contract) |
| **Music** | Lo-fi ambient, slightly magical — Hogwarts common room vibes. Keep it low under narration. |
| **Transitions** | Clean cuts. No flashy effects. Let the product speak. |
| **Recording** | Screen capture + voiceover. For the live round (Scene 3), Mel can pre-record or do it live — pre-record recommended for cleaner pacing. |
| **Resolution** | 1920×1080 minimum. Dark mode if available. |

---

## ✅ Preparation Checklist

### Tech Setup
- [ ] Anvil running with WorldEngine deployed
- [ ] `demo-round.sh` tested end-to-end with a fresh round ID
- [ ] Convex backend running and responding
- [ ] Caldero page (`/caldero/`) open and polling successfully

### Content Ready
- [ ] All 5 round pages accessible (`/004/` through `/008/`)
- [ ] TX links visible and clickable → Monad testnet explorer loads
- [ ] Council members render with names, reasoning, and weighted votes
- [ ] Landing page loads cleanly (no console errors, images loaded)

### Recording
- [ ] Screen recording software ready (OBS or similar)
- [ ] Audio input tested — quiet environment
- [ ] Browser tabs pre-arranged in order of scenes
- [ ] Terminal font size bumped up for readability on video
- [ ] Browser zoom at 100-110% for readability

### Post-Production
- [ ] Music track selected and downloaded
- [ ] Clawarts logo asset ready for closing card
- [ ] Subtitle track if submitting with captions

---

## 🎯 Key Selling Points (for judges)

1. **Non-zero-sum game design** — challengers strengthen ideas, not destroy them
2. **Full-stack onchain** — Monad smart contracts + Convex real-time backend
3. **AI council with weighted human influence** — stakes affect AI votes (4x for challengers)
4. **Agents that BUILD** — winning ideas become deployed products in minutes
5. **5 completed rounds** — this isn't a prototype, it's a working system
6. **OpenClaw orchestration** — sub-agents spawned as council members and builders
