# 02 — Token Economy

> **Why this matters:** AI assistants have limited context windows. Loading too many files wastes tokens and makes the AI slower/dumber. HEPHAESTUS solves this with Smart Loading.

---

## The Problem

```
Without Smart Loading:
- Load ALL 10 agent definitions       = ~15,000 tokens
- Load ALL 13 protocols               = ~12,000 tokens  
- Load ALL memory entries             = ~5,000 tokens
- TOTAL: ~32,000 tokens WASTED before you even ask a question
```

## The Solution: Smart Loading Protocol

HEPHAESTUS loads ONLY what's needed based on the task complexity:

| Level | Files Loaded | When |
|-------|-------------|------|
| **LITE** | ~8 files (~3,000 tokens) | Bug fix, typo, config change |
| **STANDARD** | ~20 files (~8,000 tokens) | New feature, CRUD, refactoring |
| **DEEP** | ~35 files (~15,000 tokens) | Architecture, migration, security |
| **CRITICAL** | All files (~25,000 tokens) | Production, payment, compliance |

## How It Works

1. **Triage** — All 10 agents do a quick scan (~100 words each) to decide if they're needed
2. **Self-evaluation** — Each agent responds: `CRITICAL / RELEVANT / OPTIONAL / NOT_NEEDED`
3. **Pipeline assembly** — Only activated agents load their full prompts
4. **Auto-escalation** — If complexity increases mid-task, more agents activate automatically

## What v5.0.0 Optimized

| File | Before | After | Savings |
|------|--------|-------|---------|
| `framework.yaml` | 241 lines | 94 lines | -61% |
| `agent-registry.yaml` | 607 lines | 153 lines | -75% |
| `MEMORY.md` | 383 lines | 122 lines | -68% |
| **Per-session savings** | — | — | **~5,800 tokens** |

## Tips for Users

1. **Don't manually load files** — Let the framework's Smart Loading handle it
2. **Start LITE** — The framework auto-escalates if needed
3. **Use Session Briefs** — The 30-line brief is much cheaper than reloading everything
4. **Trust the triage** — If an agent says NOT_NEEDED, it really isn't needed
