# 03 — Session Continuity

> **When to use:** EVERY time you open a new chat to continue working on a project.  
> **Why:** Each new chat starts with zero memory. This prompt restores context.

---

## The Standard Resumption Prompt

```
HEPHAESTUS multi-agent system — continuation chat.

Read in order:
1. .agents/AGENTS.md
2. .agents/profiles/<project>/<project>-profile.md
3. .agents/memory/context-db/<project>-session-brief.md

Continue from where we left off. The first task is in the brief.
```

## The Full Resumption Prompt (after a long break)

```
HEPHAESTUS multi-agent system — continuation after LONG PERIOD.

Read in order:
1. .agents/config/framework.yaml
2. .agents/AGENTS.md
3. .agents/profiles/<project>/<project>-profile.md
4. .agents/memory/context-db/<project>-session-checkpoint.md
5. .agents/memory/MEMORY-INDEX.md

Run full resumption:
- Check git log and git status
- Report: what's done, what's pending, current branch
- Ask what I want to work on today
```

## The Emergency Prompt (production bug)

```
HEPHAESTUS — EMERGENCY RESUMPTION.
Read checkpoint quickly.

PRODUCTION BUG:
[describe the bug]
[paste logs/errors]
[describe impact]

Use CRITICAL pipeline. Diagnosis and hotfix are top priority.
```

## Session Brief vs Checkpoint

| | Session Brief | Full Checkpoint |
|---|---|---|
| **Size** | ~30 lines (~200 tokens) | ~100 lines (~600 tokens) |
| **Use when** | Normal next-day continuation | After 1+ week break |
| **Contains** | What to do next, key context | Full project state |

## How to Ensure Good Continuity

1. **Always end sessions properly** — The Session Closing Protocol saves your brief
2. **Don't skip the brief** — It's only 30 lines but contains everything
3. **Trust the memory** — If learnings were saved, the AI will find them
4. **Give verbal context if needed** — "Last session we worked on X" helps
