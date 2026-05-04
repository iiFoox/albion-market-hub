# Weekly Evolution Review

> **Purpose:** Periodic analysis of framework learning and project health.  
> **Frequency:** Weekly (or after every 5+ sessions)  
> **Trigger:** User runs this prompt manually

---

## Review Prompt (COPY THIS)

```
Framework HEPHAESTUS — REVISÃO SEMANAL DE EVOLUÇÃO.

Leia nesta ordem:
1. .agents/AGENTS.md
2. .agents/profiles/ (active profile)
3. .agents/memory/MEMORY-INDEX.md
4. .agents/memory/learning-store/ (all entries)
5. .agents/memory/evolution-log/ (all entries)
6. .agents/memory/context-db/ (session checkpoint)

Gere um RELATÓRIO DE EVOLUÇÃO com:

## 1. Resumo da Semana
- Quantas sessões ocorreram
- O que foi feito (lista de tarefas completadas)
- O que ficou pendente

## 2. Learnings Capturados
- Quantos novos learnings foram escritos
- Lista com resumo de cada um
- Classificação: success | failure | insight

## 3. Knowledge Graph
- Novos patterns ou decisões arquiteturais
- Conexões identificadas entre entries

## 4. Saúde da Memória
- Total de entries por store
- Entries com confidence < 0.5 (candidatos a revisão)
- Entries sem uso há 30+ dias (candidatos a pruning)
- Contradições detectadas

## 5. Evolução do Framework
- Milestones atingidos
- Protocolos utilizados vs ignorados
- Agentes mais/menos ativados

## 6. Recomendações
- O que melhorar na próxima semana
- Entries que precisam de atualização
- Gaps de conhecimento detectados

## 7. Score de Evolução
Dê uma nota de 1-10 para:
- Frequência de escrita na memória
- Qualidade dos learnings
- Cobertura do checkpoint
- Evolução real do projeto

Salve o relatório em:
.agents/memory/evolution-log/weekly-review-<YYYY-MM-DD>.md
```

---

## What a Good Review Looks Like

```markdown
# Weekly Evolution Review — 2026-04-21 to 2026-04-27

## 1. Resumo
- 4 sessões realizadas
- Completado: Workshop import, uninstall flow, settings mirror
- Pendente: Service restart validation

## 2. Learnings (3 novos)
| ID | Type | Summary |
|----|------|---------|
| ql-2026-04-22-001 | success | Workshop folder upload works cross-browser |
| ql-2026-04-23-001 | failure | file_picker web can't access local paths |
| ql-2026-04-25-001 | insight | Dependency chain must be resolved before uninstall |

## 3. Knowledge Graph
- New: "Workshop import requires content root, not individual mod folders"
- Connection: links to seed-flutter-platform (web limitations)

## 4. Saúde da Memória
- Learning Store: 9 entries (3 new this week)
- Knowledge Graph: 4 entries (1 new)
- Evolution Log: 3 entries (1 new)
- Context DB: 3 entries (all updated)
- No contradictions detected
- 1 entry with confidence < 0.5 (needs review)

## 5. Evolução
- Session Closing Protocol followed: 3/4 sessions ✅
- Most active agents: Builder, Validator, UI/UX Specialist
- Least active: Project Manager, Documentation

## 6. Recomendações
- Update seed-flutter-platform with web file access limitations
- Documentation agent should run on next feature completion
- Consider pruning bootstrap entries (low value)

## 7. Score: 7.5/10
- Memory writes: 8/10 (3 of 4 sessions wrote learnings)
- Learning quality: 7/10 (good but could be more specific)
- Checkpoint coverage: 8/10 (updated consistently)
- Project evolution: 7/10 (steady progress, no breakthroughs)
```

---

## Quick Review (5-minute version)

```
HEPHAESTUS — revisão rápida.
Leia .agents/memory/MEMORY-INDEX.md e o checkpoint.
Me diga: quantos learnings novos, o que evoluiu, e o que precisa de atenção.
```
