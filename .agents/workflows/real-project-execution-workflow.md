# Real Project Execution Workflow

> Framework Version: 7.0.0
> Purpose: Plan and gate controlled work in a real local project.

---

## When To Use

Use this workflow after the Real Project Adapter exists and the operator asks for implementation or command execution in the real project.

## Agents

| Phase | Agent | Responsibility |
|---|---|---|
| 1 | Orchestrator | Detect real-project execution and load the `real-execution` conditional group |
| 2 | Researcher | Inspect relevant project context within adapter boundaries |
| 3 | Planner | Produce a DryRun execution plan and touched-path list |
| 4 | Builder | Apply only when adapter mode, plan, backup, and approval gates pass |
| 5 | Platform Guardian | Check platform/build implications when relevant |
| 6 | Validator | Run adapter-approved quality gates |
| 7 | Documentation | Record execution status and documentation impact |
| 8 | Delivery | Prepare delivery note without unsafe repository operations |

## Flow

1. Read `.agents/config/project.yaml`.
2. Validate adapter readiness.
3. Produce a DryRun plan.
4. Identify planned files and protected path conflicts.
5. Identify required backup behavior.
6. List commands from adapter-approved command entries.
7. Stop if execution mode is `analysis_only` or `dry_run`.
8. If mode is `controlled`, require explicit operator approval for the current plan.
9. Apply only the approved plan.
10. Run quality gates.
11. Write a real-project execution report.

## Completion Criteria

The workflow is complete when the framework has either:

- produced a blocked or DryRun report with clear next action; or
- applied an approved controlled change, run allowed quality gates, and documented the result.


