# Self-Evaluation Examples — Few-Shot

> **Propósito:** Exemplos detalhados de como cada agente decide se participa ou não  
> **Chain-of-Thought:** Cada exemplo mostra o raciocínio passo a passo

---

## Como Funciona a Self-Evaluation

Quando uma request chega, TODOS os 10 agentes fazem uma avaliação rápida (~100 palavras):

```yaml
agent: [nome]
relevance: CRITICAL | RELEVANT | OPTIONAL | NOT_NEEDED
confidence: HIGH | MEDIUM | LOW
reason: "[justificativa]"
risk_if_skipped: "[o que pode dar errado]"
recommended_mode: "deep | standard | lite | skip"
```

---

## REQUEST 1: "Criar tela de detalhes do produto"

### Orchestrator — YES (always active)
```yaml
agent: orchestrator
relevance: CRITICAL
confidence: HIGH
reason: "Nova tela requer pipeline STANDARD com coordenação de múltiplos agentes."
risk_if_skipped: "Pipeline não montado."
recommended_mode: "standard"
```
```
CHAIN-OF-THOUGHT:
1. Pedido envolve criar algo NOVO → não é LITE
2. É uma tela → envolve UI → UI/UX Specialist deve participar
3. Projeto tem multi-platform ativo → Platform Guardian tbm
4. Não envolve dados sensíveis → não é CRITICAL
5. → STANDARD pipeline com UI/UX + Platform Guardian
```

### Researcher — YES (RELEVANT)
```yaml
agent: researcher
relevance: RELEVANT
confidence: HIGH
reason: "Preciso mapear: modelo Product existe? API de detalhes existe? Navegação atual?"
risk_if_skipped: "Builder pode criar modelo duplicado ou API call redundante."
recommended_mode: "standard"
```
```
CHAIN-OF-THOUGHT:
1. Tela de detalhes precisa de dados → Product model existe? Preciso verificar
2. A tela precisa receber o ID do produto → como a navegação funciona? GoRouter?
3. Preciso saber se já existe um ProductRepository ou se precisa criar
4. Tem imagem de produto? Preciso saber o formato da URL
5. → Relevante: mapear contexto antes de construir evita retrabalho
```

### Planner — YES (RELEVANT)
```yaml
agent: planner
relevance: RELEVANT
confidence: HIGH
reason: "Nova tela precisa de plano de execução: model verificação, API binding, UI scaffold, navigation."
risk_if_skipped: "Builder pode pular passos ou criar sem estructura."
recommended_mode: "standard"
```

### Builder — YES (CRITICAL)
```yaml
agent: builder
relevance: CRITICAL
confidence: HIGH
reason: "Requere criação de código: Screen, ViewModel, Widgets, e atualização de Router."
risk_if_skipped: "Nada é implementado."
recommended_mode: "standard"
```

### UI/UX Specialist — YES (CRITICAL)
```yaml
agent: ui-ux-specialist
relevance: CRITICAL
confidence: HIGH
reason: "Nova tela requer: design tokens, layout responsivo, todos os estados, acessibilidade."
risk_if_skipped: "Hard-coded colors, layout quebrado em tablet, faltam loading/error states."
recommended_mode: "standard"
```
```
CHAIN-OF-THOUGHT:
1. É uma NOVA TELA → sempre CRITICAL para mim
2. Tela de detalhes tem imagem, texto, preço → preciso verificar tipografia e contraste
3. Pode ter scroll → preciso verificar performance de imagem grande
4. Detalhes de produto pode ter "comprar" → botão com estados
5. Responsivo: no desktop pode ter layout lado a lado, mobile é vertical
6. → CRITICAL: preciso guiar PRÉ-build e revisar PÓS-build
```

### Platform Guardian — YES (RELEVANT)
```yaml
agent: platform-guardian
relevance: RELEVANT
confidence: HIGH
reason: "Tela com imagem e possível share pode ter comportamento diferente por plataforma."
risk_if_skipped: "Imagem pode não carregar em web (CORS), share pode não funcionar em Windows."
recommended_mode: "lite"
```

### Validator — YES (RELEVANT)
```yaml
agent: validator
relevance: RELEVANT
confidence: HIGH
reason: "Nova tela precisa de widget tests e validação de navegação."
risk_if_skipped: "Sem cobertura de teste, regressões futuras."
recommended_mode: "standard"
```

### Documentation — YES (always active)
```yaml
agent: documentation
relevance: RELEVANT
confidence: HIGH
reason: "Nova tela precisa de changelog entry e possível atualização de API docs."
recommended_mode: "lite"
```

### Project Manager — YES (always active)
```yaml
agent: project-manager
relevance: RELEVANT
confidence: HIGH
reason: "Pipeline completo requer telemetria e tracking de progresso."
recommended_mode: "lite"
```

### Delivery — YES (RELEVANT)
```yaml
agent: delivery
relevance: RELEVANT
confidence: HIGH
reason: "Implementação completa merece commit: feat(products): add product detail screen"
recommended_mode: "lite"
```

**Pipeline montado:** Researcher → Planner → Builder → UI/UX Specialist → Platform Guardian → Validator → Documentation → PM → Delivery

---

## REQUEST 2: "Adicionar endpoint GET /products/:id na API"

### Orchestrator — YES (always)
```yaml
relevance: CRITICAL
reason: "Pipeline coordination required."
recommended_mode: "standard"
```

### Researcher — YES (RELEVANT)
```yaml
relevance: RELEVANT
reason: "Need to check existing API structure, response format, error handling patterns."
recommended_mode: "standard"
```

### Builder — YES (CRITICAL)
```yaml
relevance: CRITICAL
reason: "Code implementation required: route, controller, validation."
recommended_mode: "standard"
```

### UI/UX Specialist — 🔴 NO (NOT_NEEDED)
```yaml
agent: ui-ux-specialist
relevance: NOT_NEEDED
confidence: HIGH
reason: "Backend API endpoint — zero visual components."
risk_if_skipped: "None."
recommended_mode: "skip"
```
```
CHAIN-OF-THOUGHT:
1. "Endpoint" + "API" → backend work
2. Nenhuma tela, widget, ou componente visual envolvido
3. Sem impacto em design tokens, responsividade, ou acessibilidade
4. → NOT_NEEDED com alta confiança
```

### Platform Guardian — 🔴 NO (NOT_NEEDED)
```yaml
agent: platform-guardian
relevance: NOT_NEEDED
confidence: HIGH
reason: "Backend API, no client-side platform implications."
risk_if_skipped: "None."
recommended_mode: "skip"
```

### Validator — YES (RELEVANT)
```yaml
relevance: RELEVANT
reason: "API endpoint needs integration tests and security validation."
recommended_mode: "standard"
```

**Pipeline montado:** Researcher → Planner → Builder → Validator → Documentation → PM → Delivery

---

## REQUEST 3: "Reformatar o código com dart format"

### Orchestrator — YES (always)
```yaml
relevance: RELEVANT
recommended_mode: "lite"
```

### Builder — YES (CRITICAL)
```yaml
relevance: CRITICAL
reason: "Need to execute dart format on the project."
recommended_mode: "lite"
```

### TODOS OS OUTROS — 🔴 NO (NOT_NEEDED)
```yaml
agent: [researcher, planner, ui-ux-specialist, platform-guardian, validator]
relevance: NOT_NEEDED
confidence: HIGH
reason: "Code formatting is a style operation — no logic, UI, or platform change."
risk_if_skipped: "None."
recommended_mode: "skip"
```
```
CHAIN-OF-THOUGHT (de cada agente):
1. "Reformatar" = style change only
2. Nenhuma lógica muda, nenhum visual muda, nenhuma plataforma afetada
3. Zero risco de pular
4. → NOT_NEEDED com alta confiança
```

**Pipeline:** Builder → Delivery (auto-commit: `style: format codebase with dart format`)

---

## REQUEST 4: "Implementar dark mode"

### UI/UX Specialist — YES (CRITICAL)
```yaml
agent: ui-ux-specialist
relevance: CRITICAL
confidence: HIGH
reason: "Dark mode is a fundamental design system change. Need full color scheme audit, contrast verification, surface system review, and per-component check."
risk_if_skipped: "Broken contrasts, unreadable text, inconsistent dark surfaces, components that look bad in dark."
recommended_mode: "deep"
```
```
CHAIN-OF-THOUGHT:
1. Dark mode = major design system operation
2. EVERY component needs dark variant verification
3. ColorScheme.dark must be complete and careful
4. Images/icons with fixed colors need dark variants
5. Contrast ratios change completely — must re-verify all
6. This is the MOST critical task I can be involved in
7. → CRITICAL, mode DEEP — need comprehensive review
```

### Platform Guardian — YES (RELEVANT)
```yaml
relevance: RELEVANT
reason: "Dark mode interacts with platform-level theming (Android system dark mode, Windows dark mode, web prefers-color-scheme)."
risk_if_skipped: "App doesn't follow system dark mode setting on some platforms."
recommended_mode: "standard"
```

---

## REQUEST 5: "Atualizar o README do projeto"

### Builder — YES (RELEVANT)
```yaml
relevance: RELEVANT
reason: "Need to modify README.md file."
recommended_mode: "lite"
```

### Documentation — YES (CRITICAL)
```yaml
relevance: CRITICAL
reason: "README update is my primary responsibility."
recommended_mode: "lite"
```

### TODOS OS OUTROS — 🔴 NO (NOT_NEEDED)
```yaml
agent: [researcher, planner, ui-ux-specialist, platform-guardian, validator]
relevance: NOT_NEEDED
confidence: HIGH
reason: "Documentation-only change, no code, UI, or platform impact."
recommended_mode: "skip"
```

**Pipeline:** Builder (edita) → Documentation (revisa) → Delivery (auto-commit: `docs: update README`)

---

## Resumo dos Padrões

| Quando é CRITICAL | Quando é NOT_NEEDED |
|---|---|
| O agente É o especialista do tema pedido | O pedido não tem NADA a ver com a expertise |
| Pular causa risco real e mensurável | Pular não muda nada |
| Necessita de deep analysis do agente | Output do agente seria vazio |
