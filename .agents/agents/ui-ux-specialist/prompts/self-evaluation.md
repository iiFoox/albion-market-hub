# Self-Evaluation Prompt — UI/UX Specialist (v4.0.0)

> **Version:** 4.0.0
> **Use:** Universal Triage — determine participation need

## Self-Evaluation Process

When the Orchestrator triggers triage, evaluate the request against your domain:

```
STEP 1: Does this request involve any user-facing UI?
  → YES: At least RELEVANT
  → NO: Likely NOT_NEEDED

STEP 2: Does this request create new screens or modify existing ones?
  → YES: At least RELEVANT, possibly CRITICAL
  → NO: Check step 3

STEP 3: Does this request touch themes, colors, fonts, spacing, or layout?
  → YES: RELEVANT
  → NO: Check step 4

STEP 4: Does this request involve components that users interact with?
  → YES: RELEVANT (check accessibility)
  → NO: NOT_NEEDED

STEP 5: Does this request impact accessibility, responsive behavior, or animations?
  → YES: CRITICAL
  → NO: Use determination from above
```

## Response Format

```yaml
agent: ui-ux-specialist
relevance: CRITICAL | RELEVANT | OPTIONAL | NOT_NEEDED
confidence: HIGH | MEDIUM | LOW
reason: "[1 sentence explaining why]"
risk_if_skipped: "[1 sentence: what could go wrong]"
recommended_mode: "deep | standard | lite | skip"
```

## Examples

### "Criar tela de login com email e senha"
```yaml
agent: ui-ux-specialist
relevance: CRITICAL
confidence: HIGH
reason: "New screen with form inputs, buttons, and validation states requires full design review."
risk_if_skipped: "Hard-coded colors, missing accessibility labels, no responsive handling, missing error states."
recommended_mode: "standard"
```

### "Adicionar endpoint de busca de produtos na API"
```yaml
agent: ui-ux-specialist
relevance: NOT_NEEDED
confidence: HIGH
reason: "Backend API endpoint with no UI component."
risk_if_skipped: "None — no visual elements involved."
recommended_mode: "skip"
```

### "Reorganizar arquitetura de pastas do projeto"
```yaml
agent: ui-ux-specialist
relevance: NOT_NEEDED
confidence: HIGH
reason: "Structural refactor with no visual impact."
risk_if_skipped: "None."
recommended_mode: "skip"
```

### "Ajustar cor do botão de confirmação"
```yaml
agent: ui-ux-specialist
relevance: RELEVANT
confidence: HIGH
reason: "Color change needs design token verification and contrast check."
risk_if_skipped: "Color might not meet contrast requirements or break theme consistency."
recommended_mode: "lite"
```

### "Implementar dark mode no app"
```yaml
agent: ui-ux-specialist
relevance: CRITICAL
confidence: HIGH
reason: "Dark mode requires full design token review, contrast verification for all surfaces, and component-by-component audit."
risk_if_skipped: "Broken contrast ratios, inconsistent dark surfaces, unusable components in dark mode."
recommended_mode: "deep"
```
