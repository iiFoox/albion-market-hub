# Commit Gate Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-008
> **Type:** Delivery Control
> **Priority:** MANDATORY — must pass before any commit
> **Status:** Active

---

## Purpose

Ensure that **only validated, complete, and well-described work** gets committed to the repository. Prevents premature, incomplete, or poorly documented commits.

---

## Gate Criteria

### Gate 1: Completeness
```
□ The task's acceptance criteria are met
□ No partial implementation left (all files touched are complete)
□ No placeholder code (TODO, FIXME, HACK) unless explicitly documented
□ If a multi-step task: current step is fully complete
```

### Gate 2: Validation
```
□ Validator has approved (for implementation changes)
□ Linting passes (if configured)
□ Tests pass (if configured)
□ No regressions introduced
□ For docs-only changes: Documentation agent reviewed
```

### Gate 3: Scope
```
□ Changes match the original request scope
□ No unrelated changes mixed in (keep commits atomic)
□ If unrelated changes found: split into separate commits
□ File changes are reviewed against intent
```

### Gate 4: Message Quality
```
□ Commit message follows Conventional Commits format
□ Type is accurate (feat/fix/refactor/docs/chore/test/perf/ci)
□ Scope is specified where applicable
□ Description is clear and non-generic
□ Body explains WHY (if change is non-obvious)
```

### Gate 5: Repository State
```
□ Working directory is clean (no unstaged unwanted changes)
□ .gitignore is appropriate (no secrets, no node_modules, no build artifacts)
□ Remote is reachable (for sync-ready commits)
□ No merge conflicts pending
```

---

## Decision Matrix

| Gate Result | Action |
|---|---|
| All 5 gates pass | ✅ Commit + Push |
| Gates 1-4 pass, Gate 5 fails | ⚠️ Commit locally, fix repo issue, then push |
| Gate 2 fails | ❌ Return to Validator for review |
| Gate 1 fails | ❌ Return to Builder for completion |
| Gate 3 fails | ⚠️ Split changes, commit separately |
| Gate 4 fails | ⚠️ Regenerate commit message |

---

## Auto-Commit Policy

```
AUTO-COMMIT ALLOWED (no user confirmation needed):
→ Complexity level: LITE
→ Change type: docs, chore, style, test
→ All 5 gates pass
→ Version bump: patch only

USER CONFIRMATION REQUIRED:
→ Complexity level: STANDARD+
→ Change type: feat, fix, refactor, perf
→ Version bump: minor or major
→ Any breaking change
→ Database migration involved
```
