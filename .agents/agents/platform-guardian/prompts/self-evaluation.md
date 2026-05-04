# Self-Evaluation Prompt — Platform Guardian (v4.0.0)

> **Version:** 4.0.0
> **Use:** Universal Triage — determine participation need

## Self-Evaluation Process

```
STEP 1: Does the project target multiple platforms?
  → YES: Continue evaluation
  → NO (single-platform): NOT_NEEDED

STEP 2: Does this request introduce new packages/dependencies?
  → YES: At least RELEVANT (package compatibility check needed)

STEP 3: Does this request use platform-specific APIs?
  → dart:io, dart:html, dart:ffi, Platform.is*, kIsWeb: CRITICAL
  → File, Directory, Process, HttpClient: CRITICAL

STEP 4: Does this request modify build configurations?
  → YES: RELEVANT (build config verification needed)

STEP 5: Does this request create features that behave differently per platform?
  → Storage, permissions, camera, notifications: CRITICAL
  → Navigation, deep links, URL handling: RELEVANT
  → UI-only changes: NOT_NEEDED (UI/UX Specialist handles)
```

## Response Format

```yaml
agent: platform-guardian
relevance: CRITICAL | RELEVANT | OPTIONAL | NOT_NEEDED
confidence: HIGH | MEDIUM | LOW
reason: "[1 sentence explaining why]"
risk_if_skipped: "[1 sentence: what could go wrong]"
recommended_mode: "deep | standard | lite | skip"
```

## Examples

### "Adicionar upload de imagens no perfil do usuário"
```yaml
agent: platform-guardian
relevance: CRITICAL
confidence: HIGH
reason: "Image upload involves camera/gallery access which differs across Android, Windows, Web, and iOS."
risk_if_skipped: "Image picker may not work on Windows/Web, file handling may crash on Web."
recommended_mode: "standard"
```

### "Corrigir cor do botão de login"
```yaml
agent: platform-guardian
relevance: NOT_NEEDED
confidence: HIGH
reason: "Color change is purely visual — no platform API or package involved."
risk_if_skipped: "None."
recommended_mode: "skip"
```

### "Implementar armazenamento offline com SQLite"
```yaml
agent: platform-guardian
relevance: CRITICAL
confidence: HIGH
reason: "SQLite implementation differs per platform: sqflite for mobile, sqflite_common_ffi for desktop, IndexedDB fallback for web."
risk_if_skipped: "App crashes on Windows/Web because sqflite mobile-only implementation used."
recommended_mode: "deep"
```

### "Adicionar package http para chamadas de API"
```yaml
agent: platform-guardian
relevance: RELEVANT
confidence: HIGH
reason: "http package works cross-platform, but web has CORS restrictions that need proxy or server config."
risk_if_skipped: "API calls fail on web due to CORS without proper configuration."
recommended_mode: "lite"
```

### "Refatorar business logic dos repositories"
```yaml
agent: platform-guardian
relevance: NOT_NEEDED
confidence: HIGH
reason: "Pure business logic refactor with no platform-specific code."
risk_if_skipped: "None."
recommended_mode: "skip"
```
