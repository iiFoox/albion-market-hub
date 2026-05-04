# Multi-Project Support

> **Purpose:** How HEPHAESTUS manages multiple projects simultaneously.  
> **Status:** Supported via profile system since v4.0.0

---

## How It Works

Each project gets its own **profile** and **memory space**. The framework itself is shared, but context is isolated per project.

```
.agents/
├── config/
│   └── framework.yaml          ← active_profiles lists ALL projects
├── profiles/
│   ├── flutter-multiplatform/  ← Technology profile (shared)
│   ├── painel/                 ← Project: Painel
│   ├── gameforge/              ← Project: GameForge
│   └── my-saas/                ← Project: My SaaS
├── memory/
│   ├── context-db/
│   │   ├── painel-session-checkpoint.md
│   │   ├── painel-session-brief.md
│   │   ├── gameforge-session-checkpoint.md
│   │   └── gameforge-session-brief.md
│   ├── learning-store/
│   │   ├── painel-workshop-import.md      ← Project-specific learning
│   │   ├── gameforge-lobby-system.md      ← Project-specific learning
│   │   └── seed-flutter-ui.md             ← Shared learning (no prefix)
│   └── knowledge-graph/
│       ├── painel-architecture.md         ← Project-specific
│       └── seed-flutter-packages.md       ← Shared
```

---

## Naming Convention

| Type | Pattern | Example |
|------|---------|---------|
| Project profile | `<project>-profile.md` | `painel-profile.md` |
| Session checkpoint | `<project>-session-checkpoint.md` | `painel-session-checkpoint.md` |
| Session brief | `<project>-session-brief.md` | `painel-session-brief.md` |
| Project-specific learning | `<project>-<topic>.md` | `painel-workshop-import.md` |
| Shared learning (no project) | `<topic>.md` or `seed-<topic>.md` | `seed-flutter-ui.md` |
| Project genesis | `<project>-genesis.md` | `painel-genesis.md` |

**Rule:** Project-specific entries are prefixed with the project name. Shared entries (applicable to any project) have no prefix.

---

## Registering a New Project

### Option A: Onboarding Wizard (recommended)
Use the `project-onboarding.md` workflow — it handles everything automatically.

### Option B: Manual Registration
1. Create profile: `.agents/profiles/<project>/<project>-profile.md`
2. Add to `framework.yaml` under `active_profiles`:
```yaml
active_profiles:
  - id: "flutter-multiplatform"
    path: ".agents/profiles/flutter-multiplatform/"
    active: true
    # ...existing...

  - id: "<project>"
    path: ".agents/profiles/<project>/"
    active: true
    target_platforms: [Web, Android]
    description: "Project description"
    auto_activate_agents: []
```
3. Create initial checkpoint: `.agents/memory/context-db/<project>-session-checkpoint.md`
4. Update MEMORY-INDEX.md

---

## Switching Between Projects

### Same Machine, Same Framework
When working on different projects in the same workspace:
```
Estamos trabalhando no projeto [nome].
Leia .agents/profiles/[nome]/[nome]-profile.md e o checkpoint mais recente.
```

### Different Machines (Framework Deployed Per Repo)
Each project repo has its own `.agents/` copy. Memory is local to each repo.
Shared learnings (seeds) should be synced from the framework master.

---

## Isolation Rules

1. **Profile** — Each project has its own profile. Never mix project rules.
2. **Memory** — Project-specific entries are prefixed. Shared entries are not.
3. **Checkpoint** — Each project has its own checkpoint file.
4. **Session Brief** — Each project has its own brief.
5. **Learnings** — A learning about Flutter web applies to ALL Flutter projects (shared). A learning about Painel's Workshop import applies only to Painel (prefixed).
