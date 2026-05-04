# Adaptive Complexity Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-006
> **Type:** Pipeline Regulation
> **Priority:** MANDATORY — executes before triage
> **Status:** Active

---

## Purpose

Control framework intensity proportional to task risk and complexity.
**Without this protocol, every request would trigger full-depth analysis from all agents — creating massive overhead with zero added value for simple tasks.**

---

## Complexity Levels

### Level 1: LITE
```
TRIGGER WHEN:
→ Bug fix simples, typo, config change
→ Rename, reformatação, ajuste de estilo
→ Pergunta simples sobre o código
→ Estimativa: < 30 min de trabalho

PIPELINE:
→ Agents ativos: 2-3 (Orchestrator + Builder + Validator)
→ Deep reasoning: OFF
→ Memory query: última entry apenas
→ Triage: simplificada (Orchestrator decide)
→ Delivery: auto-commit (patch)

EXAMPLE:
User: "Fix the typo in the login button text"
→ LITE pipeline: Builder corrige, Validator confirma, Delivery commita
→ Tempo total do pipeline: mínimo
```

### Level 2: STANDARD
```
TRIGGER WHEN:
→ Feature nova pequena/média
→ CRUD para 1-3 entidades
→ Integração com API externa simples
→ Bug complexo com investigação
→ Estimativa: 1-8 horas de trabalho

PIPELINE:
→ Agents ativos: 5-6 (Orchestrator + Researcher + Planner + Builder + Validator + Documentation)
→ Deep reasoning: ON para Builder e Validator
→ Memory query: full search
→ Triage: standard (todos votam)
→ Delivery: commit + changelog

EXAMPLE:
User: "Add user preferences with dark mode and notification settings"
→ STANDARD pipeline: full analysis, implementation, validation, docs
```

### Level 3: DEEP
```
TRIGGER WHEN:
→ Mudança arquitetural
→ Feature que afeta múltiplos módulos
→ Integração complexa (pagamento, auth, real-time)
→ Migração de schema
→ Performance optimization
→ Estimativa: 1-5 dias de trabalho

PIPELINE:
→ Agents ativos: 7-8 (todos)
→ Deep reasoning: ON para todos
→ Memory query: full search + cross-project
→ Triage: completa com justificativas
→ Delivery: commit + changelog + version bump minor
→ Adversarial review: Validator red-team ativado

EXAMPLE:
User: "Migrate from REST to GraphQL for the order module"
→ DEEP pipeline: research, risk analysis, phased plan, implementation, security audit, docs
```

### Level 4: CRITICAL
```
TRIGGER WHEN:
→ Sistema em produção com dados reais
→ Dados financeiros ou de saúde
→ Compliance/regulatório (PCI-DSS, HIPAA, LGPD)
→ Mudança que pode causar downtime
→ Rollback seria difícil ou impossível
→ Estimativa: 1-2 semanas de trabalho

PIPELINE:
→ Agents ativos: 8 (todos, sem exceção)
→ Deep reasoning: ON para todos, modo máximo
→ Memory query: full + cross-project + incident archetypes
→ Triage: completa + obrigatório justificar exclusões
→ Delivery: commit + changelog + version bump + tag + release notes
→ Adversarial review: Builder red-team + Validator security audit + Validator edge case probing
→ Industry profile: ativado se aplicável

EXAMPLE:
User: "Implement Stripe payment integration with subscription management"
→ CRITICAL pipeline: max depth, security audit, financial compliance check, extensive testing
```

## Classification Heuristics

```
KEYWORDS → COMPLEXITY LEVEL:

LITE keywords:
fix, typo, rename, style, format, comment, config, env, update dependency

STANDARD keywords:
add, create, implement, feature, integrate, refactor, optimize

DEEP keywords:
migrate, architecture, redesign, scale, performance, auth, real-time, multi-tenant

CRITICAL keywords:
payment, financial, health, compliance, production deploy, database migration,
security, encryption, PCI, HIPAA, LGPD, rollback, disaster
```

## Override Rules

```
ESCALATION:
→ If ANY agent in triage marks CRITICAL → escalate to DEEP minimum
→ If industry profile is active (fintech, healthcare) → STANDARD minimum
→ If production environment → STANDARD minimum
→ User can manually set level: "use DEEP pipeline for this"

DE-ESCALATION:
→ User can override down: "this is just a quick fix, use LITE"
→ PM can recommend: "previous similar task was LITE successfully"
```
