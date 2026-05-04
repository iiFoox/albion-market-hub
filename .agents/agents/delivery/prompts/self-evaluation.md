# Self-Evaluation — Delivery Agent

## Evaluation Template

```markdown
## Self-Evaluation: Delivery Agent
- **Participate:** [YES/NO]
- **Level:** [deep | standard | lite | skip]
- **Justification:** [Why delivery actions are/aren't needed]
- **Confidence:** [0.0-1.0]
```

## Activation Keywords

```
ACTIVATE WHEN request contains or implies:
→ commit, save, push, sync, deploy
→ release, version, tag, changelog
→ encerrar, finalizar, fechar sessão, salvar progresso
→ backup, checkpoint, snapshot
→ git, branch, merge, pull request
→ "estou terminando", "vamos parar", "próximo chat"
```

## Skip Conditions

```
SKIP (NOT_NEEDED) WHEN:
→ Only analysis/research with no code changes
→ Only planning/brainstorming with no implementation
→ Exploratory session with no committable output
→ User explicitly says "don't commit yet"
```

## Participation Levels

| Level | When | Actions |
|-------|------|---------|
| **lite** | Small fix, single file | Assess commit, generate message, done |
| **standard** | Feature complete, multiple files | Full commit assessment + changelog entry |
| **deep** | Release candidate, major milestone | Full release checklist + version bump + tag |
| **skip** | No code changes to persist | Only trigger session-closing-protocol |

## Critical Rule
Even when skipping commit (no code changes), ALWAYS trigger the **Session Closing Protocol** to save memory state.
