# 13 — Real Project Adapter

> Framework Version: 8.0.0
> Purpose: Configure HEPHAESTUS to understand a real local project safely.

---

## What This Mode Does

The Real Project Adapter tells HEPHAESTUS how a specific repository works before it plans changes, runs commands, or prepares real-project execution.

The source of truth is:

```text
.agents/config/project.yaml
```

## Why It Exists

Different projects have different commands, stacks, protected files, generated directories, test strategies, and safety rules.

Without an adapter, an agent may infer incorrectly. With an adapter, HEPHAESTUS can operate from explicit local rules.

## What To Configure

| Section | Purpose |
|---|---|
| `project` | Project identity, root, profile, maturity, description |
| `stack` | Languages, frameworks, runtime, databases, package manager, platforms |
| `commands` | Allowed install, test, lint, build, format, and dev commands |
| `paths.source` | Source paths the framework may inspect or modify |
| `paths.tests` | Test paths |
| `paths.docs` | Documentation paths |
| `paths.generated` | Generated paths that should usually not be hand-edited |
| `paths.protected` | Paths that require explicit approval before changes |
| `execution` | Analysis-only, dry-run, or controlled execution rules |
| `quality_gates` | Required, optional, or manual validation checks |

## Safe Default

The default adapter mode is:

```yaml
execution:
  mode: "analysis_only"
  require_plan_before_changes: true
  require_approval_before_apply: true
  backup_before_mutation: true
  allow_destructive_commands: false
```

This means HEPHAESTUS can inspect and reason, but it should not treat the real project as mutable execution territory until the adapter is intentionally configured.

## Recommended Prompt

```text
HEPHAESTUS, activate Real Project Adapter mode.

Read .agents/config/project.yaml, validate the adapter, list missing fields,
identify protected paths, confirm allowed commands, and tell me whether the
project is ready for controlled work.
Do not modify project files yet.
```

## Readiness Status

The adapter should report one of:

| Status | Meaning |
|---|---|
| `ready` | Required fields are configured and controlled work can be planned |
| `partial` | Some fields are missing; use analysis-only or dry-run |
| `missing` | Adapter is not configured |
| `unsafe` | Configuration allows risky behavior or lacks required safety boundaries |

## Token Economy

Adapter context is conditional. It is loaded only when working with real project configuration or preparing controlled project execution.











