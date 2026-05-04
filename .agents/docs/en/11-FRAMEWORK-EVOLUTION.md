# 11 — Framework Evolution

> **How HEPHAESTUS learns, grows, and gets smarter over time.**

---

## The Memory System

HEPHAESTUS has 4 memory stores:

| Store | Purpose | Example |
|-------|---------|---------|
| **Learning Store** | What worked / what failed | "file_picker web can't access local paths" |
| **Knowledge Graph** | Patterns and relationships | "Riverpod + GoRouter = recommended for Flutter" |
| **Evolution Log** | Growth milestones | "Framework upgraded to v5.2.0" |
| **Context DB** | Current project state | Session checkpoint, project state |

## Quick Learning Format

When something is validated or fails, save a Quick Learning (4 fields):

```markdown
## What — file_picker package cannot access local file system on web platform
## Context — Tried to use file_picker to browse local Workshop folder
## Evidence — Browser security sandbox blocks local path access
## Reuse Rule — For web file access, always use browser upload dialog instead
```

## Weekly Evolution Review

Run this weekly to assess how the framework is learning:

```
HEPHAESTUS — weekly evolution review.
Read .agents/memory/MEMORY-INDEX.md and all learning-store entries.
Generate an evolution report with scores.
```

The review checks:
- How many learnings were captured
- Quality and specificity of entries
- Checkpoint freshness
- Gaps in knowledge

## Framework Health Dashboard

Quick diagnostic to check if everything is working:

```
HEPHAESTUS — health check.
Verify: framework version, agents, protocols, memory entries, last checkpoint.
Generate a health dashboard.
```

## How Evolution Works in Practice

```
Session 1: "Use file_picker for local access" → FAILS
           → Learning saved: "web can't access local files"

Session 5: Similar task arrives
           → Memory consulted → Past failure found
           → AI avoids file_picker, uses browser upload directly
           → Time saved, error avoided

Session 10: Pattern recognized
            → Knowledge graph entry: "Web platform file access patterns"
            → Future sessions start with this knowledge
```

**This is why the Session Closing Protocol is mandatory** — without it, none of this learning happens.

## The Memory Index

`MEMORY-INDEX.md` is a quick-reference table of ALL entries:

```markdown
| File | Type | Summary |
|------|------|---------|
| pilot-file-picker-web.md | failure | file_picker web limitations |
| pilot-dark-mode-toggle.md | success | Dark mode implementation validated |
| seed-flutter-ui.md | seed | UI/UX patterns for Flutter |
```

Always update this index when adding new entries.
