# Memory Index — Quick Reference

> **Auto-maintained:** Update this index whenever adding/removing memory entries.  
> **Purpose:** Fast lookup of all stored knowledge without reading every file.

---

## Learning Store (`.agents/memory/learning-store/`)

| File | Type | Summary |
|------|------|---------|
| `bootstrap-consolidation.md` | bootstrap | Framework initial consolidation record |
| `seed-architecture-patterns.md` | seed | State management, error handling, performance patterns |
| `seed-flutter-platform.md` | seed | Platform-specific gotchas (Android, iOS, Windows, Web) |
| `seed-flutter-ui.md` | seed | UI/UX patterns, anti-patterns, responsive design |
| `pilot-pipeline-retrospective.md` | insight | Learnings from first pilot run |
| `pilot-dark-mode-toggle.md` | success | Dark mode toggle implementation validated |
| `pilot-file-picker-web.md` | failure | file_picker web limitations discovered |

## Knowledge Graph (`.agents/memory/knowledge-graph/`)

| File | Type | Summary |
|------|------|---------|
| `bootstrap-architecture.md` | bootstrap | Initial architecture knowledge |
| `seed-flutter-packages.md` | seed | Package compatibility and recommendations |
| `seed-flutter-structure.md` | seed | Project structure patterns for Flutter |

## Evolution Log (`.agents/memory/evolution-log/`)

| File | Type | Summary |
|------|------|---------|
| `bootstrap-genesis.md` | milestone | Framework creation record |
| `pilot-run-2026-04-23.md` | milestone | First pilot run execution and results |

## Context DB (`.agents/memory/context-db/`)

| File | Type | Summary |
|------|------|---------|
| `bootstrap-project-state.md` | bootstrap | Initial project state template |
| `session-checkpoint.md` | active-state | Compact current session state |
| `session-brief.md` | active-state | Short resume briefing for new chats |
| `next-chat-activation-prompt.md` | active-state | Copy-ready prompt for session resume |

## Templates (`.agents/memory/templates/`)

| File | Type | Summary |
|------|------|---------|
| `decision.md` | template | Architecture or implementation decision memory |
| `learning.md` | template | Quick Learning memory entry |
| `risk.md` | template | Risk or warning memory entry |
| `project-state.md` | template | Project state memory entry |
| `next-action.md` | template | Next action memory entry |

---

## How To Use This Index

1. **Before writing:** Check if a similar entry already exists
2. **After writing:** Add a row to the appropriate table above
3. **When searching:** Scan this index first instead of reading all files
4. **Project-specific entries** are kept in the project's own `.agents/memory/` — NOT here

> **Note:** Project-specific entries (like `painel-*` files) exist only in project repositories, not in the framework master.
