# Real Project Execution Hardening Protocol

> Framework Version: 7.0.0
> Purpose: Harden controlled Apply, backup, audit, allowlist, and restore behavior for real local projects.

---

## Principle

Controlled Apply is allowed only when it is reversible, audited, and adapter-bound.

The framework must prove that real-project execution can:

- block unsafe Apply attempts;
- create a backup artifact before mutation;
- write an audit trail;
- avoid protected paths by default;
- restore from the latest backup;
- keep tests isolated from the real framework workspace.

## Required Gates

| Gate | Requirement |
|---|---|
| Adapter | `.agents/config/project.yaml` must exist |
| Mode | `execution.mode` must be `controlled` for Apply |
| Plan | Plan required before changes |
| Approval | Current-plan approval token required |
| Backup | Backup artifact created before mutation |
| Audit | Apply, blocked Apply, dry-run, backup, and restore events recorded |
| Protected Paths | Protected path conflicts block Apply unless an override reason exists |
| Restore | Latest backup can be restored in an isolated fixture |

## Test Strategy

The hardening test must use a temporary fixture project. It must not apply mutations to the real framework workspace.

The fixture must prove:

1. DryRun passes without mutation.
2. Apply is blocked in the real default project.
3. Controlled Apply in a fixture creates a marker and backup artifact.
4. Restore from latest backup succeeds in the fixture.

## Token Policy

This protocol is loaded only for real-project execution hardening, Apply, backup, audit, or restore work.
