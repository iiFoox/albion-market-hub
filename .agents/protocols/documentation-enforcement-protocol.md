# Documentation Enforcement Protocol

> Framework Version: 7.0.0
> Purpose: Keep project documentation aligned with implementation, planning, and delivery without forcing broad documentation loading on every task.

---

## Principle

Documentation is mandatory as an impact assessment, not always as a heavy writing phase.

Every pipeline must produce one of two outcomes:

- documentation updated;
- documentation explicitly assessed as not impacted, with a short reason.

## Required Checkpoints

The Documentation agent must participate as a lightweight checkpoint when:

- files are created, modified, or removed;
- requirements, scope, architecture, or UX direction changes;
- a release note, changelog, migration guide, README, tutorial, API reference, or ADR may be affected;
- a project state, plan, decision, risk, benchmark, simulation, or delivery report is generated.

## Output Contract

Each delivery must include a documentation impact record:

```markdown
## Documentation Impact

- Status: updated | not_impacted | deferred
- Documents touched:
- Documents that should be updated next:
- Reason:
- Risk if skipped:
```

## Token Policy

Use the lightest effective documentation path:

- LITE: document only impact status and touched files.
- STANDARD: update changed user/developer docs and changelog notes.
- DEEP: add or update ADRs, architecture docs, diagrams, migration docs.
- CRITICAL: include compliance, operational, rollback, and audit documentation.

Do not load the full documentation tree unless the task is explicitly documentation-heavy.

## Enforcement

The pre-release gate validates that:

- the Documentation agent is active in the registry;
- the pipeline marks Documentation as mandatory;
- active config points to this protocol and policy;
- the documentation policy exists;
- the documentation impact template exists.




