---
description: Research-only workflow — technology evaluation and feasibility analysis
---

# Research Only Workflow

> Use this workflow for: technology evaluation, feasibility analysis, architecture assessment, exploratory analysis — NO code changes.

## When to Use

```
User request matches?
│
├── "Qual a melhor opção para...?"           → YES
├── "Compare X vs Y"                         → YES
├── "É viável fazer...?"                     → YES
├── "Como funciona...?"                      → YES
├── "Avalie a arquitetura de..."             → YES
├── "Quero implementar X" (sem código)       → YES (research phase only)
└── "Corrija o bug em..." / "Adicione..."    → NO → use quick-fix or full-pipeline
```

## Pipeline Steps

### 1. Request Reception (Orchestrator)
Identify this as a research request — no code changes expected.
- Classify complexity (usually STANDARD)
- If user also wants implementation → upgrade to full pipeline

### 2. Self-Evaluation
- Expected active: **Researcher** + Documentation + Project Manager
- Builder and Validator: **SKIP**
- UI/UX Specialist: only if evaluating UI frameworks/design systems
- Platform Guardian: only if evaluating platform compatibility

### 3. Deep Research (Researcher)
Full research execution:
- Technology evaluation with comparison matrix
- Architecture analysis and feasibility
- Risk analysis with probability/impact
- Memory consultation for past research
- **Output:** Comprehensive research report

### 4. Documentation (Documentation)
Document the research findings:
- Create technology evaluation document
- Record ADRs (Architecture Decision Records) if decisions made
- **Output:** Research documentation

### 5. Memory Update
- Store findings in knowledge-graph (patterns, relationships)
- Store decision rationale in learning-store (if a choice was made)
- Update MEMORY-INDEX.md

### 6. Result Delivery (Orchestrator)
Present findings to user in pt-BR with:
- Clear recommendation with reasoning
- Comparison table (if evaluating alternatives)
- Risk assessment summary
- Next steps if the user decides to proceed

---

## Example

**User:** "Compare Riverpod vs Bloc para state management no nosso projeto Flutter"

**Research Output:**
```
## Avaliação: Riverpod vs Bloc

| Critério          | Riverpod       | Bloc          |
|-------------------|----------------|---------------|
| Learning curve    | Moderada       | Íngreme       |
| Boilerplate       | Baixo          | Alto          |
| Testing           | Excelente      | Excelente     |
| DevTools          | Bom            | Excelente     |
| Community         | Crescendo      | Estabelecida  |
| Multi-platform    | ✅ Full        | ✅ Full       |

Recomendação: Riverpod — menor boilerplate, code generation com @riverpod,
e alinhado com a tendência do ecossistema Flutter.

Salvo em: .agents/memory/learning-store/<research-topic>.md
```
