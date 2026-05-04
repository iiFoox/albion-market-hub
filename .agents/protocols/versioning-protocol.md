# Versioning Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-009
> **Type:** Delivery Control
> **Priority:** MANDATORY — applies to every version bump
> **Status:** Active

---

## Purpose

Standardize how the HEPHAESTUS framework and all projects it manages determine, apply, and communicate version changes using Semantic Versioning 2.0.0.

---

## Version Format

```
MAJOR.MINOR.PATCH[-prerelease][+build]

Examples:
1.0.0          → First stable release
1.2.3          → Stable release
2.0.0-alpha.1  → Pre-release (early development)
1.5.0-beta.2   → Pre-release (feature-complete, testing)
1.5.0-rc.1     → Release candidate
```

## Decision Tree

```
DID THE CHANGE BREAK EXISTING BEHAVIOR?
├── YES → MAJOR bump (X.0.0)
│   Examples:
│   → Removed a public API endpoint
│   → Changed response format of existing endpoint
│   → Renamed database tables/columns (destructive migration)
│   → Dropped support for a runtime/platform
│
└── NO
    ├── DID IT ADD NEW FUNCTIONALITY?
    │   ├── YES → MINOR bump (0.X.0)
    │   │   Examples:
    │   │   → New feature or endpoint
    │   │   → New component or page
    │   │   → New configuration option
    │   │   → Non-breaking schema addition (new nullable column)
    │   │
    │   └── NO → PATCH bump (0.0.X)
    │       Examples:
    │       → Bug fix
    │       → Performance improvement
    │       → Documentation fix
    │       → Dependency update (non-breaking)
    │       → Code refactor (no behavior change)
    │       → Style/formatting fix
    └──
```

## Changelog Format (KEEPACHANGELOG)

```markdown
# Changelog

## [1.3.0] - 2026-04-05

### Added
- User preferences API with dark mode support
- Push notification settings endpoint

### Changed
- Improved dashboard loading performance (p95: 850ms → 120ms)

### Fixed
- N+1 query on user orders endpoint
- Token refresh not rotating refresh token

### Security
- Added rate limiting on login endpoint (5 attempts / 15 min)

### Deprecated
- Legacy /api/v1/settings endpoint (use /api/v2/preferences)

## [1.2.1] - 2026-04-03

### Fixed
- Typo in login button text
- Missing validation on email field
```

## Tagging Rules

```
WHEN TO CREATE A GIT TAG:
→ Every MINOR or MAJOR version bump
→ Format: v1.3.0 (prefixed with 'v')
→ Annotated tags with message: git tag -a v1.3.0 -m "Release v1.3.0"

WHEN NOT TO TAG:
→ PATCH versions during rapid development (daily patches)
→ Pre-release versions (unless explicitly releasing alpha/beta)

RELEASE NOTES:
→ Generated from changelog for tagged versions
→ Include: summary, breaking changes (if MAJOR), migration guide (if needed)
```

## Version Sync Points

```
FILES THAT MUST BE UPDATED ON VERSION BUMP:
→ package.json (version field) — for Node.js/JS projects
→ pyproject.toml (version) — for Python projects
→ *.csproj (Version) — for .NET projects
→ pubspec.yaml (version) — for Flutter projects
→ CHANGELOG.md — always
→ README.md — only if version badge exists

THE DELIVERY AGENT MUST:
1. Update version in project config file
2. Update CHANGELOG.md with new entries
3. Create commit: "chore(release): bump version to X.Y.Z"
4. Create annotated tag (for minor/major)
5. Push commit + tag to remote
```
