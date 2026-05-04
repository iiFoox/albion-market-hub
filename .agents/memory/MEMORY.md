# MEMORY.md — HEPHAESTUS Memory System

> **Type:** Shared Infrastructure  
> **Accessed By:** All agents  
> **Purpose:** Evolutionary learning backbone — the framework remembers, learns, and evolves.

---

## 1. Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                      MEMORY SYSTEM                            │
├───────────────┬──────────────┬─────────────┬─────────────────┤
│  KNOWLEDGE    │   LEARNING   │  EVOLUTION  │    CONTEXT      │
│    GRAPH      │    STORE     │     LOG     │      DB         │
├───────────────┼──────────────┼─────────────┼─────────────────┤
│ • Patterns    │ • Validated  │ • Milestones│ • Project state │
│ • Relations   │   learnings  │ • Growth    │ • Checkpoints   │
│ • Arch.       │ • Failures   │   tracking  │ • Active        │
│   decisions   │ • Anti-      │ • Agent     │   decisions     │
│ • Tech compat │   patterns   │   maturity  │ • Next steps    │
└───────────────┴──────────────┴─────────────┴─────────────────┘
```

**Quick Reference:** See `MEMORY-INDEX.md` for a searchable index of all entries.

---

## 2. Components

### 2.1 Knowledge Graph (`knowledge-graph/`)
Stores learned patterns, architectural decisions, and technology relationships.

**Entry format:**
```markdown
---
id: "kg-YYYY-MMDD-NNN"
type: "pattern" | "relationship" | "architecture"
created: "ISO-8601"
confidence: 0.0-1.0
tags: ["tag1", "tag2"]
---
## Title | ## Description | ## Evidence | ## Applicability | ## Limitations
```

### 2.2 Learning Store (`learning-store/`)
Records outcomes of decisions — what worked, what failed, what to reuse.

**Quick Learning format (preferred — use this for most entries):**
```markdown
---
id: "ql-YYYY-MM-DD-NNN"
type: "success" | "failure" | "insight"
created: "ISO-8601"
confidence: 0.0-1.0
tags: ["tag1", "tag2"]
---
## What — [one sentence]
## Context — [one sentence]
## Evidence — [one sentence]
## Reuse Rule — [one sentence]
```

**Full Learning format (for complex, high-impact learnings only):**
```markdown
---
id: "ls-YYYY-MMDD-NNN"
type: "success" | "failure" | "trade-off" | "best-practice" | "anti-pattern"
created: "ISO-8601"
outcome: "positive" | "negative" | "mixed"
impact_score: 0.0-1.0
confidence: 0.0-1.0
tags: ["tag1", "tag2"]
---
## Summary | ## Context | ## Decision Made | ## Outcome
## Root Cause Analysis | ## Lessons Learned | ## Recommendations
```

### 2.3 Evolution Log (`evolution-log/`)
Tracks framework growth milestones and capability improvements.

**Entry format:**
```markdown
---
id: "ev-YYYY-MMDD-NNN"
type: "milestone" | "improvement" | "regression"
created: "ISO-8601"
framework_version: "X.Y.Z"
---
## Title | ## What Changed | ## Before State | ## After State | ## Evidence
```

### 2.4 Context DB (`context-db/`)
Maintains current project state and session checkpoints.

**Entry format:**
```markdown
---
id: "ctx-project-NNN"
type: "project-state" | "session-checkpoint"
created: "ISO-8601"
updated: "ISO-8601"
project: "project-name"
---
## Current State | ## Key Facts | ## Dependencies | ## Constraints
```

---

## 3. How Agents Use Memory

For operational consultation rules, see `.agents/protocols/memory-consultation-protocol.md` and `.agents/config/memory-policy.yaml`.

### Before Acting
- Check `MEMORY-INDEX.md` for relevant past entries
- Read applicable learnings and patterns
- Identify known risks or anti-patterns

### After Acting
- Write Quick Learnings for validated outcomes
- Update knowledge graph if architecture changed
- Flag contradictions with existing entries

### At Session End (MANDATORY — see `session-closing-protocol.md`)
1. Update session checkpoint in `context-db/`
2. Write any new learnings to `learning-store/`
3. Record architecture decisions in `knowledge-graph/` (if applicable)
4. Log milestones in `evolution-log/` (if applicable)

---

## 4. Memory Hygiene Rules

1. **Use Quick Learning format** — 4 fields, not 12. Lower friction = more entries.
2. **Update MEMORY-INDEX.md** — Add a row when creating new entries.
3. **No duplicate knowledge** — Check index before creating new entries.
4. **Stale entries** — Review entries with `valid_until` dates periodically.
5. **Contradiction detection** — When a new entry contradicts an existing one, flag both.
6. **Project-specific entries** — Stay in the project repo, NOT in the framework master.

---

## 5. Bootstrap Entries

When deploying the framework to a new project, these entries are created:
1. **Framework Genesis** (`evolution-log/bootstrap-genesis.md`)
2. **Project State** (`context-db/bootstrap-project-state.md`)
3. **Architecture Baseline** (`knowledge-graph/bootstrap-architecture.md`)
4. **Initial Consolidation** (`learning-store/bootstrap-consolidation.md`)
5. **Seed Memories** (`learning-store/seed-*.md`, `knowledge-graph/seed-*.md`)
