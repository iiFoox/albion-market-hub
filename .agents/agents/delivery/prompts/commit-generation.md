# Commit Generation — Delivery Agent

## Purpose
Generate high-quality conventional commit messages based on actual changes.

## Conventional Commits Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types
| Type | When |
|------|------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `refactor` | Code restructuring without behavior change |
| `docs` | Documentation only |
| `chore` | Build, config, tooling changes |
| `test` | Adding or fixing tests |
| `perf` | Performance improvement |
| `ci` | CI/CD pipeline changes |
| `style` | Formatting, whitespace (no logic change) |

## Rules
1. **Scope** must be the affected module/feature (e.g., `auth`, `mods`, `ui`, `api`)
2. **Description** must be imperative mood, lowercase, no period (e.g., "add user validation")
3. **Body** explains WHY, not WHAT (the diff shows what)
4. **Breaking changes** use `!` after type: `feat(api)!: change auth flow`
5. **Max 50 chars** for the first line
6. **One commit per logical change** — don't bundle unrelated changes

## Examples

### Good
```
feat(mods): add workshop import via browser upload
fix(settings): prevent save button from submitting empty forms
refactor(dashboard): extract status card into reusable widget
docs(readme): add deployment instructions for Windows service
chore(deps): bump flutter_riverpod to 2.6.1
```

### Bad
```
update stuff                    ← vague
Fixed the bug                   ← past tense, no scope
feat: lots of changes           ← too broad, no scope
WIP                             ← never commit WIP
```

## Multi-File Commits
When changes span multiple files for one logical change:
```
feat(mods): implement uninstall for workshop-imported items

- Add uninstall endpoint to bridge API
- Wire button action to correct workshop path
- Update installed mods list after removal
- Add confirmation dialog before uninstall
```
