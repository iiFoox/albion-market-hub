# Real Project Execution Hardening Protocol

> Framework Version: 7.0.0
> Purpose: Allow controlled developer execution planning for real local projects through the Real Project Adapter.

---

## Principle

Real project execution must be adapter-bound, dry-run first, and approval-gated.

HEPHAESTUS must never treat a real repository like a disposable simulation workspace. Before any real-project mutation, it must validate `.agents/config/project.yaml`, produce an execution plan, identify touched paths, check protected paths, define quality gates, and require explicit operator approval.

## Activation Triggers

Activate this protocol when the user asks to:

- implement a change in a real local project;
- run project-local tests, lint, build, or format as part of a change;
- move from analysis/discovery into execution using `.agents/config/project.yaml`;
- apply edits outside temporary simulation workspaces;
- prepare a real-project delivery plan.

## Required Preconditions

Before applying changes:

- Real Project Adapter status must be `ready`.
- `execution.mode` in `.agents/config/project.yaml` must be `controlled`.
- `execution.require_plan_before_changes` must be `true`.
- `execution.require_approval_before_apply` must be `true`.
- `execution.backup_before_mutation` must be `true`.
- No planned target may match `paths.protected`.
- Quality gates must be known or explicitly marked manual.
- Operator approval must be explicit for the current plan.

## Modes

| Mode | Behavior |
|---|---|
| `analysis_only` | Read adapter and report why execution is blocked |
| `dry_run` | Build execution plan, touched paths, commands, risks, and gates without file changes |
| `controlled` | May apply only after plan, backup, protected-path check, and explicit approval |

## Output Contract

Every real-project execution attempt must produce:

```markdown
## Real Project Execution Status

- Status: dry_run | blocked | ready_for_apply | applied | failed
- Request:
- Adapter status:
- Execution mode:
- Planned files:
- Protected path conflicts:
- Backup required:
- Approval required:
- Commands to run:
- Quality gates:
- Risks:
- Next action:
```

## Safety Rules

- Do not run destructive commands.
- Do not apply changes in `analysis_only` or `dry_run`.
- Do not apply changes without explicit approval for the current plan.
- Do not edit `.agents/`, `.git/`, secrets, credentials, generated files, or configured protected paths unless the operator explicitly overrides protection.
- Prefer small, reversible changes.
- Write a report even when execution is blocked.

## Token Policy

Load this protocol only for real-project execution. Normal adapter review, project discovery, documentation, and simulation work should not load execution-specific context.


