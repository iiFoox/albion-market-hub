# Smart Loading Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-011
> **Type:** Context Window Management
> **Priority:** MANDATORY — executes BEFORE any file loading
> **Status:** Active (v3.6.0+ / Updated v5.4.0)

---

## Purpose

Optimize context window usage by loading **only the framework files needed** for the current task's complexity level. Without this protocol, every chat loads ~114 files consuming 60-80% of available context, leaving minimal space for actual project code.

**Problem solved:** LLMs have finite context windows (128K-200K tokens). Loading the entire framework leaves too little room for the project's source code, which is what actually needs analysis and modification.

---

## How It Works

```
1. User sends request (or resumption prompt)
2. Orchestrator makes QUICK complexity guess from keywords (< 5 seconds)
3. Smart Loading loads ONLY the files for that level
4. All agents do lightweight triage (~100 words each)
5. Auto-Escalation Protocol checks triggers:
   → IF escalation needed → DELTA LOAD (only extra files, not full reload)
   → IF no escalation → continue at current level
6. Pipeline executes with optimized context
```

> **Delta Loading:** When escalating (e.g., LITE→STANDARD), only the DIFFERENCE 
> is loaded (~14-18 extra files), not the full STANDARD tier (~22-28 files).
> Files already in context are never reloaded. See `auto-escalation-protocol.md`.

## Loading Tiers

The auditable source of truth for tier membership is `.agents/config/loading-tiers.yaml`.
Use `.agents/tools/estimate-loading.ps1` to estimate file count, bytes, and approximate tokens for any tier before expanding the loading rules.

### Tier 1: LITE (Bug fix, config, typo)
**Load ~8 files | ~5% of framework | Context saved: ~80%**

```
ALWAYS LOAD (Core — mandatory for every tier):
├── .agents/config/framework.yaml
├── .agents/config/complexity-routing.yaml
├── .agents/memory/context-db/session-checkpoint.md
└── .agents/agents/orchestrator/prompts/system-prompt.md

LITE-SPECIFIC:
├── .agents/agents/builder/prompts/system-prompt.md
├── .agents/agents/validator/prompts/system-prompt.md
├── .agents/agents/delivery/prompts/system-prompt.md
└── .agents/protocols/commit-gate-protocol.md

LITE-CONDITIONAL (load IF relevant keywords detected):
├── .agents/agents/ui-ux-specialist/prompts/system-prompt.md   ← IF UI/visual keywords
└── .agents/agents/platform-guardian/prompts/system-prompt.md  ← IF platform keywords
```

**DO NOT LOAD:** Blueprints, tech cards, security KB, industry profiles, incident archetypes, anti-patterns, deep-reasoning prompts, analysis frameworks, governance, benchmarks.

---

### Tier 2: STANDARD (Feature, CRUD, integration)
**Load ~20 files | ~18% of framework | Context saved: ~60%**

```
EVERYTHING FROM LITE, PLUS:

Agents (system prompts only — no deep-reasoning):
├── .agents/agents/researcher/prompts/system-prompt.md
├── .agents/agents/planner/prompts/system-prompt.md
├── .agents/agents/documentation/prompts/system-prompt.md
└── .agents/agents/project-manager/prompts/system-prompt.md

Protocols:
├── .agents/protocols/universal-triage-protocol.md
├── .agents/protocols/adaptive-complexity-protocol.md
├── .agents/protocols/versioning-protocol.md
└── .agents/protocols/memory-governance-protocol.md

Config:
├── .agents/config/triage-rules.yaml
└── .agents/config/maturity-profiles.yaml

New Agents (if relevant to task):
├── .agents/agents/ui-ux-specialist/prompts/system-prompt.md   ← IF UI work
├── .agents/agents/platform-guardian/prompts/system-prompt.md  ← IF multi-platform

Flutter Profile (if active):
├── .agents/profiles/flutter-multiplatform/architecture.md     ← IF Flutter project
├── .agents/profiles/flutter-multiplatform/ui-standards.md     ← IF UI work + Flutter

Knowledge (SELECTIVE — only relevant to the task):
├── .agents/knowledge/tech-cards/[RELEVANT tech card only]
└── .agents/knowledge/database-playbook/ (if DB work involved)

Memory:
├── .agents/memory/learning-store/[latest entries]
└── .agents/memory/knowledge-graph/[latest entries]
```

**DO NOT LOAD:** All tech cards (only relevant ones), all architecture patterns (only if architecture work), all security KBs (only if security relevant), industry profiles (only if activated), blueprints (only if planning new project), full Flutter profile (only relevant files).

---

### Tier 3: DEEP (Architecture, migration, complex features)
**Load ~45 files | ~40% of framework | Context saved: ~35%**

```
EVERYTHING FROM STANDARD, PLUS:

Deep Reasoning (all agents where present):
├── .agents/agents/*/prompts/deep-reasoning.md

Additional Prompts:
├── .agents/agents/builder/prompts/implementation.md
├── .agents/agents/builder/prompts/refactoring.md
├── .agents/agents/validator/prompts/security-audit.md
├── .agents/agents/validator/prompts/quality-gate.md
├── .agents/agents/planner/prompts/strategy-selection.md
├── .agents/agents/planner/prompts/task-decomposition.md
├── .agents/agents/ui-ux-specialist/prompts/design-review.md
└── .agents/agents/platform-guardian/prompts/compatibility-check.md

New Agent Knowledge:
├── .agents/agents/platform-guardian/knowledge/known-issues.md

Flutter Profile (full, if Flutter project):
├── .agents/profiles/flutter-multiplatform/ (ALL files)

Knowledge (EXPANDED):
├── .agents/knowledge/architecture-patterns/decision-tree.md
├── .agents/knowledge/architecture-patterns/[RELEVANT pattern]
├── .agents/knowledge/tech-cards/[ALL relevant tech cards]
├── .agents/knowledge/security/owasp-top-10/
└── .agents/knowledge/operational-intelligence/incident-archetypes.md

Blueprints (if new project/module):
├── .agents/agents/planner/blueprints/[RELEVANT blueprint]

Profiles (if activated):
├── .agents/profiles/[ACTIVE profile]

Patterns:
├── .agents/agents/builder/patterns/[RELEVANT patterns]
├── .agents/agents/validator/playbooks/[RELEVANT playbook]
```

**DO NOT LOAD:** Non-relevant architecture patterns, non-relevant tech cards, non-active industry profiles, anti-pattern registry (unless code review), benchmarks.

---

### Tier 4: CRITICAL (Production, financial, compliance, security)
**Load ~80+ files | ~70% of framework | Context saved: ~10%**

```
EVERYTHING FROM DEEP, PLUS:

Full Security KB:
├── .agents/knowledge/security/ (ALL 4 files)

Full Operational Intelligence:
├── .agents/knowledge/operational-intelligence/incident-archetypes.md
├── .agents/knowledge/operational-intelligence/anti-pattern-registry.md

Full Resilience:
├── .agents/knowledge/resilience/resilience-patterns.md
├── .agents/knowledge/observability/observability-guide.md

Full Governance:
├── .agents/agents/project-manager/governance/governance-framework.md

Full Validator Suite:
├── .agents/agents/validator/prompts/ (ALL files)
├── .agents/agents/validator/playbooks/ (ALL files)

Full Documentation Templates:
├── .agents/agents/documentation/templates/template-library.md

Benchmarks:
├── .agents/benchmarks/benchmark-suite.md

Industry Profiles (ALL active):
├── .agents/profiles/[ALL relevant profiles]

All Protocols:
├── .agents/protocols/ (ALL 11 files)
```

**EVERYTHING is fair game at CRITICAL level.** Context window is secondary to thoroughness.

---

## Escalation Loading

When complexity is escalated mid-task (e.g., LITE → STANDARD):

```
ESCALATION RULES:
1. Do NOT reload files already loaded
2. Load ONLY the delta (new files for the higher tier)
3. Inform the user: "Escalating to STANDARD — loading additional context"
4. Continue pipeline without restarting

EXAMPLE:
- Task started as LITE (8 files loaded)
- Validator detects security concern → escalates to DEEP
- Load delta: deep-reasoning prompts + security KB + incident archetypes
- Continue validation with expanded context
```

## Quick Reference Card

```
┌─────────┬──────────┬─────────────┬───────────────┐
│  Level  │  Files   │ Context     │ Best For      │
│         │  Loaded  │ Saved       │               │
├─────────┼──────────┼─────────────┼───────────────┤
│ LITE    │  ~8-10   │ ~75-80%     │ Fixes, config │
│ STANDARD│  ~22-28  │ ~55-60%     │ Features      │
│ DEEP    │  ~50-55  │ ~30-35%     │ Architecture  │
│ CRITICAL│  ~90+    │ ~5-10%      │ Production    │
└─────────┴──────────┴─────────────┴───────────────┘
```

## Integration with Daily Prompts

The resumption prompt (05-RETOMADA-DE-CHAT.md) should:

1. ALWAYS load the Core files (4 files)
2. Read session-checkpoint.md to understand current task
3. Determine expected complexity for today's work
4. Load the appropriate tier
5. If user changes task mid-session → load additional files as needed

```
RESUMPTION PROMPT SHOULD SAY:
"Load framework at [TIER] level for today's work on [task description]"

NOT:
"Read all protocols, all configs, all memory" ← old pattern, wastes context
```
