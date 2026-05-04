# Cross-Session Memory Handoff Protocol

> **Purpose:** Transfer minimal essential context between chat sessions efficiently.  
> **Trigger:** End of every session (part of Session Closing Protocol)  
> **Goal:** Next chat starts fast without reloading everything.

---

## The Problem

Each new chat starts with zero memory. Without a handoff, the AI must re-read large files to understand context. This wastes tokens and time.

## The Solution

A **Session Brief** — a compact handoff document (~30-50 lines) that contains ONLY what the next session needs to start immediately.

---

## Session Brief Format

Create/update this file at the end of every session:
```
.agents/memory/context-db/<project>-session-brief.md
```

### Template

```markdown
---
project: "[name]"
session_date: "YYYY-MM-DD"
session_number: N
next_session_priority: "high" | "normal" | "low"
---

# Session Brief — [Project Name]

## Read First
- .agents/profiles/<project>/<project>-profile.md
- .agents/memory/context-db/<project>-session-checkpoint.md

## What Was Done This Session
- [1-line summary of each completed task]

## What Is In Progress
- [Active task with exact state]
- [Files currently being modified]
- [Branch if relevant]

## Blockers / Issues Found
- [Any blocker with details]
- [Any bug discovered but not yet fixed]

## Next Session Should
1. [Most important task — be specific]
2. [Second priority]
3. [Third priority]

## Key Context (don't re-research this)
- [Critical fact the next session needs to know]
- [Decision made this session that affects future work]
- [File paths or endpoints that matter]

## DO NOT
- [Things the next session should NOT reopen]
- [Closed fronts that should stay closed]
```

---

## How To Use In Next Session

### Activation Prompt (paste in new chat)

```
Leia nesta ordem:
1. .agents/AGENTS.md
2. .agents/profiles/<project>/<project>-profile.md
3. .agents/memory/context-db/<project>-session-brief.md

Continue de onde paramos. A primeira tarefa está no brief.
```

### Why Brief > Full Checkpoint

| | Session Brief | Full Checkpoint |
|---|---|---|
| **Size** | ~30-50 lines | ~80-150 lines |
| **Tokens** | ~200 | ~600 |
| **Focus** | What to do NEXT | Full project state |
| **When** | Every session handoff | Periodically or at milestones |

The brief is a **hot handoff** — fast, focused. The checkpoint is a **cold backup** — complete but heavier. Use both: brief for continuity, checkpoint for recovery.

---

## Decision Tree

```
Session ending?
│
├── Was work done?
│   ├── YES → Write Session Brief (always)
│   │         Update Checkpoint (if milestone or significant progress)
│   └── NO  → Update Brief with "no changes, continue from last brief"
│
└── Will someone else continue?
    ├── YES → Write detailed Brief with extra context
    └── NO  → Standard Brief is enough
```
