# Release Checklist — Delivery Agent

## Purpose
Pre-release verification checklist before version bump, tag, and push.

## Checklist

### 1. Code Quality Gate
- [ ] All changes have been reviewed by Validator agent
- [ ] No known failing tests
- [ ] No unresolved security issues flagged
- [ ] No TODO/FIXME comments in new code (unless tracked)

### 2. Documentation Gate
- [ ] CHANGELOG.md updated with new version entry
- [ ] README.md updated if features/setup changed
- [ ] API docs updated if endpoints changed
- [ ] Architecture docs updated if structure changed

### 3. Version Decision
| Change Type | Version Bump |
|-------------|-------------|
| Bug fix, patch, config tweak | `patch` (0.0.X) |
| New feature, non-breaking | `minor` (0.X.0) |
| Breaking change, major refactor | `major` (X.0.0) |

### 4. Git Hygiene
- [ ] All changes committed (no uncommitted files)
- [ ] Commit messages follow Conventional Commits
- [ ] Branch is clean (no merge conflicts)
- [ ] Remote is reachable

### 5. Tag & Release
```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z: [summary]"
git push origin main --tags
```

### 6. Post-Release
- [ ] Session checkpoint updated
- [ ] Memory entries written (learnings, milestones)
- [ ] Next chat prompt prepared (if session ending)

## When NOT to Release
- Code is "mostly working" but has known issues
- Changes are exploratory / experimental
- User hasn't explicitly approved the changes
- Tests haven't been run after latest changes
