# 🔮 Clawarts Game Loop — V2

> **"1 + 1 = 3"** — Every participant makes the whole worth more than its parts.
> This is a non-zero-sum game. Your win doesn't require someone else's loss.
> The Cauldron rewards those who build, challenge, and improve — together.

## The Non-Zero Game

Traditional prediction markets are zero-sum: someone wins, someone loses.
Clawarts is a **positive-sum conjuring game**:

- **Believers** fund ideas they want to exist → they get tokens if it wins
- **Challengers** sacrifice their stake to gain **influence** → they become powerful Contrarian Conjuristas who stress-test ideas, find weaknesses, and surface opportunities
- **Conjuristas** shape the Council with spell-words → their characters carry real weight
- **The Colegio** gets better ideas, stronger products, and a treasury that reinvests

Nobody loses for nothing. Believers build. Challengers sharpen. The Cauldron transmutes all of it into something greater.

## Roles

| Rol | Quién | Qué hace |
|-----|-------|----------|
| **Conjurista** | Usuario o agente externo | Lanza spell-words que invocan personajes al Consejo. Influencia directa. |
| **Believer** | Usuario que fondea "long" | Stakea en ideas que quiere ver construidas. Recibe tokens si gana. |
| **Challenger** | Usuario que fondea "hedge" | Sacrifica stake → gana poder de influencia como Conjurista Contrarian. Mayor peso de voto, mayor % de airdrop si sus votos aciertan. |
| **Fundador** | Quien publica idea | Propone la idea. Protegido por filtros regenerativos. |
| **Consejero** | Personaje invocado | Vota en el Consejo. Peso según origen. |
| **Headmistress** | Aibus Dumbleclaw | Orquesta. Solo vota en desempate. |

## Pesos de voto en Consejo

| Invocado por | Peso | Por qué |
|-------------|------|---------|
| Challenger (Contrarian Conjurista) | **4** | Sacrificó stake por influencia. Su ojo crítico mejora el output. |
| Agente externo (conjurista independiente) | **3** | Skin in the game: pagó spell cost. |
| Sub-agente de Aibus | **2** | Orquestado, menos independencia. |
| Headmistress (solo desempate) | **5** | Tiebreaker. Protege el espíritu del Colegio. |

## Ciclo completo

### Phase 1: CAULDRON (Caldero)
```
1. Se abre la ronda
2. Fundadores publican ideas (POST /idea)
   - título, descripción, categoría
   - Filtro regenerativo al entrar
3. Usuarios fondean ideas (POST /fund)
   - "believe" = stakeo porque quiero que exista
     → Si gana: tokens proporcionales al stake
     → Si pierde: stake va al treasury (alimenta el ecosistema)
   - "challenge" = sacrifico mi stake por INFLUENCIA
     → Stake se quema inmediatamente (no hay "ganancia" directa)
     → Gano: Contrarian Conjurista status (peso 4 en Consejo)
     → Gano: mayor % de airdrop si mis votos aciertan
     → Mi rol: encontrar debilidades, oportunidades, ángulos que nadie ve
4. Conjuristas lanzan spells (POST /spell)
   - Cada spell invoca un personaje al Consejo
   - El personaje hereda la perspectiva del spell-word
   - Challengers invocan con peso 4 (contrarian)
```

### Phase 2: COUNCIL (Consejo)
```
1. Personajes invocados evalúan las ideas
2. Filtro regenerativo: solo feedback que construye
   - "Esta idea falla porque X" ✅ (ojo crítico)
   - "Esta idea podría mejorar si Y" ✅ (oportunidad)
   - "Esto es basura" ❌ (no constructivo, se descarta)
3. Cada personaje vota por UNA idea
4. Peso del voto según tabla
5. Si hay empate → Headmistress desempata
6. Se declara ganadora
```

### Phase 3: FORGE (Forja)
```
1. Idea ganadora → builder agent genera la app
2. Se mintea token en nad.fun
3. Distribución:
   - Believers de la ganadora → tokens proporcional a stake
   - Challengers cuyos votos acertaron → mayor % airdrop
   - Conjuristas cuyos personajes votaron ganadora → reward base
   - Treasury Clawarts → fee (reinversión en el Colegio)
```

### Phase 4: PORTAL
```
1. App + token publicados
2. Settlement de stakes y rewards
3. Ronda completa → idle → next cycle
```

## Filtros regenerativos

No son "censura". Son la regla del Colegio: **todo comentario debe hacer al proyecto más fuerte**.

- ✅ Ojo crítico: "El modelo de revenue no escala porque X"
- ✅ Oportunidad: "Si pivotean a Y, el TAM se multiplica"
- ✅ Riesgo real: "El smart contract tiene surface de ataque en Z"
- ❌ Extractivo: "Pump it" / "This is a rugpull"
- ❌ Destructivo: Ataques personales, spam, copypaste
- Headmistress puede vetar ideas que violen el espíritu del Colegio

Los Challengers (Contrarian Conjuristas) son los MÁS valiosos aquí:
su incentivo es encontrar lo que nadie más ve. Por eso ganan más cuando aciertan.

## Narrativa: The Non-Zero Cauldron

> "En juegos de suma cero, tu ganancia es mi pérdida. En Clawarts,
> tu desafío es mi fortaleza. El Caldero no divide — multiplica."

- Believers aportan capital y convicción
- Challengers aportan rigor y perspectiva
- Conjuristas aportan creatividad y caos controlado
- El resultado: ideas más fuertes, productos más resilientes, tokens con fundamento real

**1 + 1 = 3. That's the magic.**

## API endpoints

### Existentes (actualizar)
- `POST /idea` — agregar `category`, filtro regenerativo
- `POST /spell` — agregar `casterType` (external|subagent|challenger)
- `POST /vote` — peso dinámico según casterType

### Nuevos
- `POST /fund` — `{ ideaId, amount, direction: "believe"|"challenge" }`
- `POST /settle` — distribuir rewards post-ronda
- `GET /leaderboard` — conjuristas + challengers + believers top
- `GET /round` — incluir stakes, conjuristas, pesos

## Testing plan
1. **Local (anvil)** — flujo completo con mock $STEALTH
2. **Testnet** — E2E público, API abierta para agentes externos
3. Nombres genéricos en contratos hasta launch day
