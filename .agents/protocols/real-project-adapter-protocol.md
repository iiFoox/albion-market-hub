# Real Project Execution Hardening Protocol

> Framework Version: 7.0.0
> Purpose: Let HEPHAESTUS understand a real local project safely before planning, testing, building, or executing work.

---

## Principle

Do not assume how a project works.

Before acting on a real project, HEPHAESTUS must read the project adapter contract in `.agents/config/project.yaml`. The adapter tells the framework what stack is active, where the project root is, which commands are allowed, which paths are protected, and what validation gates exist.

## Activation Triggers

Activate this protocol when the user asks HEPHAESTUS to:

- work in a real local project;
- run tests, lint, build, format, or validation;
- inspect stack, package manager, dependencies, or repository structure;
- modify files outside temporary simulation workspaces;
- prepare controlled developer execution for a real project;
- adapt framework behavior to a specific repository.

## Required Adapter Fields

The project adapter must define:

| Field | Purpose |
|---|---|
| `project.id` | Stable project identifier |
| `project.name` | Human-readable project name |
| `project.root` | Root path relative to the workspace |
| `project.stack` | Languages, frameworks, runtime, database, package manager |
| `commands` | Allowed test/build/lint/format/dev commands |
| `paths.source` | Source directories the framework may inspect or edit |
| `paths.tests` | Test directories |
| `paths.docs` | Documentation directories |
| `paths.protected` | Files/directories that must not be modified without explicit approval |
| `execution.mode` | `analysis_only`, `dry_run`, or `controlled` |
| `execution.require_plan_before_changes` | Whether implementation requires a plan first |
| `execution.require_approval_before_apply` | Whether file changes need explicit approval |
| `quality_gates` | Commands or checks that prove correctness |

## Operating Rules

- If `.agents/config/project.yaml` is missing or empty, operate in `analysis_only` mode.
- If commands are missing, do not invent commands; infer only as a recommendation and ask/record confirmation.
- Never edit protected paths without explicit operator approval.
- Never run destructive commands from project config.
- Prefer dry-run or read-only analysis until the adapter is validated.
- Treat adapter configuration as project-local truth, not global framework truth.
- Keep the adapter compact and specific; do not store broad technology catalogs.

## Adapter Readiness

A real project is adapter-ready when:

- project identity and root are defined;
- at least one source path is defined;
- protected paths are explicit;
- execution mode is defined;
- commands are either defined or explicitly marked unavailable;
- quality gates are mapped to commands or manual checks.

## Output Contract

Adapter review must produce:

```markdown
## Real Project Execution Hardening Status

- Status: ready | partial | missing | unsafe
- Project root:
- Stack:
- Allowed commands:
- Protected paths:
- Quality gates:
- Execution mode:
- Missing adapter fields:
- Risks:
- Recommended next action:
```

## Token Policy

Load this protocol only when project-local adaptation is relevant. Normal framework tasks and documentation edits should not load adapter details.



