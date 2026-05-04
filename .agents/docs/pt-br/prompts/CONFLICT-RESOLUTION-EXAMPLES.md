# Conflict Resolution Examples

> **Propósito:** Como agentes resolvem desacordos entre si  
> **Mostra:** Conflitos reais com evidence e resolução documentada

---

## Como Funciona a Resolução de Conflitos

Quando agentes discordam:
```
1. Conflito detectado → Orchestrator notificado
2. Ambas partes apresentam EVIDENCE (não opinião)
3. Orchestrator avalia severity
4. Se técnico → usa evidence + memória para decidir
5. Se estratégico → escala para o usuário
6. Decisão registrada em memory para referência futura
```

---

## CONFLITO 1: Builder vs. UI/UX Specialist — Estrutura de Widget

### O conflito:
```
🔨 Builder: "Criei ProductCard com 200 linhas em um widget.
   É eficiente e tudo está no mesmo lugar."

🎨 UI/UX Specialist: "Widget de 200 linhas viola component architecture.
   Precisa ser decomposto em 3-4 sub-widgets."
```

### Evidence de cada lado:

**Builder:**
```
EVIDENCE:
1. Widget de 200 linhas tem MENOS overhead de rebuild per-frame
2. Dart compiler inline otimiza melhor com menos abstrações
3. Componentes menores = mais boilerplate de constructor/params
4. Para este caso específico, a reusabilidade não foi requisitada
```

**UI/UX Specialist:**
```
EVIDENCE:
1. Widget > 100 linhas viola composability principle (Flutter best practice)
2. Sub-seções (image, info, price, actions) mudam independentemente
3. Atualmente: mudar o botão "Comprar" causa rebuild de TODA a imagem
4. Widget tests ficam mais claros com componentes menores
5. Futuro: se precisar de ProductCardHorizontal, terá que duplicar tudo
6. Flutter docs recommend: "Split widget into smaller widgets" para perf
```

### Resolução pelo Orchestrator:
```
CHAIN-OF-THOUGHT:

1. Avaliar gravidade: MEDIUM — não é blocking, mas afeta qualidade
2. Avaliar evidências:
   - Builder tem ponto sobre overhead minimal — verdade
   - UI/UX tem ponto sobre rebuild scope — mais relevante para perf real
   - UI/UX tem ponto sobre testability e manutenção — forte
   - Flutter official guidance alinha com UI/UX position

3. Checar memória:
   → Encontrado: learning-store entry "Componentes > 150 linhas causaram 
     bugs repetidos no módulo de chat (3 ocorrências)"

4. DECISÃO: UI/UX Specialist wins
   → Decompor em: ProductCardImage, ProductCardInfo, ProductCardActions
   → Manter ProductCard como compositor

JUSTIFICATIVA: 
Evidence de história do projeto (3 bugs em componentes grandes) +
Flutter official guidance + melhor testability superam o overhead
marginal de abstrações.
```

```yaml
conflict_resolution:
  id: CR-2026-001
  type: technical
  agents: [builder, ui-ux-specialist]
  winner: ui-ux-specialist
  decision: "Decompose ProductCard into 3 sub-widgets"
  evidence_strength: "STRONG — historical evidence + official guidance"
  memory_entry: "ProductCard decomposition: always decompose widgets > 100 lines into sub-widgets. Evidence: 3 bugs in chat module from large widgets."
  escalated_to_user: false
```

---

## CONFLITO 2: Platform Guardian vs. Builder — Package Choice

### O conflito:
```
🔨 Builder: "Quero usar sqflite para o banco de dados local. 
   É o mais popular e tem melhor documentação."

🛡️ Platform Guardian: "sqflite não funciona em Web. 
   Projeto target Web. BLOQUEIO."
```

### Evidence:

**Builder:**
```
EVIDENCE:
1. sqflite: 3000+ likes no pub.dev
2. Melhor documentação
3. Mais exemplos e tutoriais
4. Team já conhece
5. Performance excelente em mobile
```

**Platform Guardian:**
```
EVIDENCE:
1. sqflite platform support: Android ✅, iOS ✅, Windows ❌, Web ❌
2. Projeto target: Android + Windows + Web
3. known-issues.md entry: "sqflite — use drift for cross-platform"
4. drift supports: Android ✅, iOS ✅, Windows ✅ (FFI), Web ✅ (sql.js)
5. drift API similar a sqflite, migração é straightforward
6. Se usar sqflite → app CRASHA em Web na primeira query SQL
```

### Resolução:
```
CHAIN-OF-THOUGHT:

1. Gravidade: CRITICAL — app literalmente crasha em 2 das 3 plataformas target
2. Evidence do Platform Guardian é objetiva e verificável
3. Builder tem pontos sobre popularidade, mas popularidade ≠ compatibilidade
4. Known-issues.md já documenta isso — decisão já foi tomada antes
5. DECISÃO: Platform Guardian wins — usar drift

JUSTIFICATIVA:
Crash em plataformas target é bloqueante. Popularidade do package não
compensa incompatibilidade. drift é a alternativa documentada no 
known-issues.md.
```

```yaml
conflict_resolution:
  id: CR-2026-002
  type: technical
  agents: [builder, platform-guardian]
  winner: platform-guardian
  decision: "Use drift instead of sqflite for cross-platform SQL"
  evidence_strength: "CRITICAL — objective platform incompatibility"
  escalated_to_user: false
```

---

## CONFLITO 3: Planner vs. Builder — Escopo da Feature

### O conflito:
```
📐 Planner: "Feature de favorite deve incluir: lista, toggle, 
   sincronização offline, notificação quando produto favorito 
   entra em promoção."

🔨 Builder: "Isso são 3 features separadas, não 1. 
   O escopo deveria ser apenas lista + toggle. 
   Sync e notificação são features futuras."
```

### Evidence:

**Planner:**
```
EVIDENCE:
1. Requirement original do usuário: "sistema completo de favoritos"
2. "Completo" implica full functionality
3. Sync offline garante que favoritos não se perdem
4. Notificação de promoção é o valor real da feature
```

**Builder:**
```
EVIDENCE:
1. Requirement ambíguo — "completo" pode significar qualquer coisa
2. Implementar tudo junto = 3-5 dias
3. Implementar lista + toggle = 4 horas
4. Podemos entregar valor incremental
5. Sync offline e notificação podem ser fases 2 e 3
6. YAGNI principle: não implementar o que não foi explicitamente pedido
```

### Resolução:
```
CHAIN-OF-THOUGHT:

1. Gravidade: MEDIUM — escopo, não crash
2. Evidence: ambas têm pontos válidos
3. Ambiguidade na requirement → precisa clarificação do usuário
4. DECISÃO: ESCALAR para o usuário

ESCALAÇÃO:
"A feature 'favoritos' pode ser implementada em fases:
  Fase 1 (4h): Lista de favoritos + toggle favorite
  Fase 2 (1d): Sincronização offline
  Fase 3 (2d): Notificação de promoção

Deseja implementar tudo agora ou em fases?"
```

```yaml
conflict_resolution:
  id: CR-2026-003
  type: strategic
  agents: [planner, builder]
  winner: escalated_to_user
  decision: "User decides scope — presented phased approach"
  reason: "Ambiguous requirement requires user clarification"
  escalated_to_user: true
```

---

## CONFLITO 4: UI/UX Specialist vs. Platform Guardian — Animation

### O conflito:
```
🎨 UI/UX: "Botão precisa de animação hover com scale transform + 
   box shadow elevation para dar feedback visual no desktop."

🛡️ Platform Guardian: "Scale transform no Web com HTML renderer 
   causa visual glitches. Box shadow animado é pesado no Web."
```

### Evidence:

**UI/UX Specialist:**
```
1. Hover feedback é OBRIGATÓRIO em desktop — UX principle
2. Scale + shadow é o padrão Material 3
3. Sem isso o app parece "morto" no desktop
```

**Platform Guardian:**
```
1. HTML renderer: transforms glitch em Edge/Firefox (known issue)
2. CanvasKit/Wasm: funciona bem
3. Box shadow animation: 30% mais lento que opacity animation no HTML renderer
4. SOLUÇÃO: usar opacity + color change em vez de scale + shadow
```

### Resolução:
```
CHAIN-OF-THOUGHT:

1. Ambos têm razão em seus domínios
2. UI/UX está certo: hover IS necessary
3. Platform Guardian está certo: essa implementação específica falha no Web
4. COMPROMISSO: manter hover, mudar implementação

DECISÃO: COMPROMISSO
- Hover: SIM (UI/UX wins no princípio)
- Implementação: Opacity + color change (Platform Guardian wins no método)
- CanvasKit/Wasm: pode usar scale + shadow (melhor visual)
- HTML renderer: fallback para opacity + color
- Usar MediaQuery ou renderer detection para decidir
```

```yaml
conflict_resolution:
  id: CR-2026-004
  type: technical
  agents: [ui-ux-specialist, platform-guardian]
  winner: compromise
  decision: "Hover yes (UI/UX principle) + platform-adaptive implementation (PG method)"
  memory_entry: "Web hover animations: use opacity/color over scale/shadow on HTML renderer. CanvasKit/Wasm can use full animations."
```

---

## Regras de Resolução

| Prioridade | Quem ganha | Exemplo |
|---|---|---|
| 1. Segurança | Validator SEMPRE ganha | "Tem SQL injection" → fix obrigatório |
| 2. Crash/Breakage | Platform Guardian ganha | "Crasha no Web" → mudar abordagem |
| 3. Evidence histórica | Quem tem evidence do projeto | "Já deu errado antes" → evitar |
| 4. Official guidance | Quem alinha com docs oficiais | "Flutter docs dizem X" → seguir |
| 5. Ambiguidade | ESCALAR para o usuário | "Escopo não claro" → perguntar |
| 6. Preferência técnica | COMPROMISSO | "Hover sim, método diferente" |
