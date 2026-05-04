# 10 — Delivery & Versioning

> **How the Delivery Agent manages commits, releases, and version control.**

---

## Conventional Commits

All commits follow this format:
```
<type>(<scope>): <description>
```

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring |
| `docs` | Documentation only |
| `chore` | Build, config, tooling |
| `test` | Tests only |
| `perf` | Performance improvement |

## Version Bumping

| Change | Bump | Example |
|--------|------|---------|
| Bug fix | **patch** (0.0.X) | 1.2.3 → 1.2.4 |
| New feature | **minor** (0.X.0) | 1.2.3 → 1.3.0 |
| Breaking change | **major** (X.0.0) | 1.2.3 → 2.0.0 |

## Commit Gate Protocol

Not everything gets committed. The Delivery Agent checks:

| Condition | Action |
|-----------|--------|
| Code changes validated | ✅ Commit |
| Tests passing | ✅ Commit |
| Only analysis/planning | ⏸️ Save checkpoint only |
| Exploratory/brainstorm | ⏸️ Save checkpoint only |
| Tests failing | ❌ Block commit |
| Untested code | ❌ Block commit |

## Session Closing (MANDATORY)

At the end of every session, even without a commit:
1. Update session checkpoint
2. Write learnings to memory
3. Generate session brief for next chat

This ensures continuity even when no code was committed.

## Release Checklist

For minor/major releases, the Delivery Agent runs:
- [ ] All changes reviewed and validated
- [ ] No failing tests
- [ ] CHANGELOG.md updated
- [ ] Version bumped
- [ ] Git tag created
- [ ] Pushed to remote
- [ ] Session checkpoint updated
