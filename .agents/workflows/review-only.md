---
description: Review-only workflow — code review and architecture audit
---

# Review Only Workflow

> Use this workflow for: code review, architecture audits, security assessments, quality checks — NO code changes.

## When to Use

```
User request matches?
│
├── "Revise este código"                     → YES
├── "Faça um audit de segurança"             → YES
├── "Avalie a qualidade do módulo X"         → YES
├── "O que está errado nessa arquitetura?"   → YES
├── "Review do PR / merge request"           → YES
├── "Corrija os problemas que encontrar"     → NO → use quick-fix or full-pipeline
└── "Implemente a melhoria"                  → NO → use full-pipeline
```

## Pipeline Steps

### 1. Request Reception (Orchestrator)
Identify as a review request — analysis only, no modifications.
- If user wants fixes applied → upgrade to full pipeline

### 2. Self-Evaluation
- Expected active: **Researcher** + **Validator** + Documentation + Project Manager
- Builder: **SKIP** (no implementation)
- Planner: **SKIP** (no planning)
- UI/UX Specialist: only if reviewing UI code
- Platform Guardian: only if reviewing cross-platform code

### 3. Context Analysis (Researcher)
Understand the codebase under review:
- Map architecture and design patterns used
- Identify dependencies and risk areas
- Check memory for known issues in this area
- **Output:** Context map focused on review targets

### 4. Quality Review (Validator)
Comprehensive review:
- **Code quality:** naming, structure, complexity, readability
- **Security:** vulnerabilities, input validation, auth patterns
- **Performance:** bottlenecks, N+1 queries, memory leaks
- **Architecture:** SOLID compliance, coupling, cohesion
- **Best practices:** error handling, logging, testing
- **Technical debt:** shortcuts, TODOs, workarounds
- **Output:** Detailed review report

### 5. Documentation (Documentation)
Document review findings:
- Create review report with categorized findings
- Severity classification: 🔴 Critical | 🟡 Warning | 🔵 Info

### 6. Memory Update
- Store findings in learning-store (patterns found, anti-patterns detected)
- Update knowledge-graph if new architecture patterns identified

### 7. Result Delivery (Orchestrator)
Present findings to user in pt-BR with prioritized recommendations.

---

## Example

**User:** "Revise a segurança do módulo de autenticação"

**Review Output:**
```
## Security Review — Módulo de Autenticação

### Findings

🔴 CRITICAL (2)
1. JWT secret hardcoded em config.ts:12 — mover para env variable
2. Sem rate limiting no endpoint /auth/login — vulnerável a brute force

🟡 WARNING (3)
1. Refresh token TTL = 30 dias — considerar reduzir para 7 dias
2. Password hash usa bcrypt rounds=8 — aumentar para 12
3. Sem logging de tentativas de login falhadas

🔵 INFO (1)
1. Considerar adicionar 2FA como feature futura

### Recomendação
Corrigir os 2 itens CRITICAL antes do deploy.
Os 3 WARNINGs podem entrar no próximo sprint.

Salvo em: .agents/memory/learning-store/<review-topic>.md
```
