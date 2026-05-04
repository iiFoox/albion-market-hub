# Real Project Execution Hardening Workflow

> Framework Version: 7.0.0
> Purpose: Configure and validate HEPHAESTUS against a real local project before controlled execution.

---

## When To Use

Use this workflow when the operator wants HEPHAESTUS to understand or work inside a real repository.

## Agents

| Phase | Agent | Responsibility |
|---|---|---|
| 1 | Orchestrator | Detect real-project intent and load the `adapter` conditional group |
| 2 | Researcher | Inspect project structure and infer stack signals when needed |
| 3 | Planner | Map commands, quality gates, protected paths, and execution constraints |
| 4 | Builder | Use adapter boundaries before proposing file changes |
| 5 | Platform Guardian | Check platform-specific command and path constraints |
| 6 | Validator | Verify the adapter contract and quality gates |
| 7 | Documentation | Record adapter status and project-specific usage notes |
| 8 | Delivery | Preserve project config and avoid unsafe repository operations |

## Flow

1. Read `.agents/config/project.yaml`.
2. Validate required adapter fields.
3. Inspect project structure only if the adapter allows it.
4. Compare configured source, test, docs, and protected paths against the filesystem.
5. Confirm allowed commands and quality gates.
6. Produce Real Project Execution Hardening Status.
7. If status is `ready`, allow future controlled execution modes to use the adapter.
8. If status is `partial`, use analysis-only or dry-run behavior until gaps are resolved.
9. If status is `unsafe`, stop before modifying files or running commands.

## Safety Rules

- Never assume protected paths are safe to edit.
- Never run commands not listed in the adapter as allowed.
- Never convert adapter analysis into implementation without the required plan/approval flags.
- Keep global framework files separate from project-local configuration.

## Completion Criteria

The workflow is complete when:

- adapter status is reported;
- missing fields are listed;
- unsafe configuration is blocked;
- quality gates are mapped;
- next action is clear.



