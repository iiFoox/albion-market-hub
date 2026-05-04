# 05 — Session Resume

> Use when: You are starting a new chat and want to continue an existing project.

---

## Prompt

```text
Resume HEPHAESTUS for this project.

Read:
1. .agents/AGENTS.md
2. .agents/config/framework.yaml
3. relevant memory entries in .agents/memory/context-db/
4. the latest session handoff, if present

Then summarize:
1. current project state;
2. last known task;
3. pending work;
4. relevant agents;
5. safest next action.

Do not make code changes until the current state is clear.
```

## Tip

Paste the previous session handoff after this prompt when available.
