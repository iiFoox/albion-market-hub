# 14 — Real Project Execution

> Framework Version: 8.0.0
> Purpose: Use HEPHAESTUS for controlled execution planning in a real local project.

---

## What This Mode Does

Real Project Execution lets HEPHAESTUS prepare real-project work through a safety-first process:

1. read `.agents/config/project.yaml`;
2. validate adapter boundaries;
3. generate a DryRun execution plan;
4. identify planned files and protected-path conflicts;
5. list allowed commands and quality gates;
6. require explicit approval before any Apply path.

## Safe Default

The default project config remains safe:

```yaml
execution:
  mode: "analysis_only"
  require_plan_before_changes: true
  require_approval_before_apply: true
  backup_before_mutation: true
  allow_destructive_commands: false
```

In this state, HEPHAESTUS may reason and produce a plan, but real mutation is blocked.

## Recommended Prompt

```text
HEPHAESTUS, activate Real Project Execution mode.

Use .agents/config/project.yaml as the source of truth.
First produce a DryRun plan with planned files, protected path checks,
commands to run, quality gates, risks, and documentation impact.
Do not apply changes until I explicitly approve the current plan.
```

## Apply Requirements

Apply is allowed only when:

- the adapter is ready;
- `execution.mode` is `controlled`;
- a plan exists;
- backup is required;
- protected paths are clear;
- quality gates are defined or explicitly manual;
- the operator approves the current plan.

## Output

The framework writes a Real Project Execution Status with:

- status;
- request;
- adapter status;
- execution mode;
- planned files;
- protected path conflicts;
- backup and approval status;
- commands and quality gates;
- risks;
- documentation impact;
- next action.

## Token Economy

This mode is conditional. It is loaded only when real-project execution is requested.










