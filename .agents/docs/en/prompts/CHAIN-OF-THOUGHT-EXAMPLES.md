# Chain-of-Thought Examples — Step by Step Reasoning

> **Purpose:** Shows EXACTLY how each agent thinks, step by step  
> **Format:** Internal thinking → Action → Output

---

## Example 1: Orchestrator classifying a request

### Request: "Implement product search with filters"

```
ORCHESTRATOR CHAIN-OF-THOUGHT:

STEP 1 — Parse intent:
→ "Implement" = create something new
→ "product search" = search feature
→ "with filters" = UI + logic combined
→ Classification: FEATURE

STEP 2 — Check keywords:
→ "implement" = STANDARD keyword ✅
→ "search" = may involve full-text search (DEEP?)
→ "filters" = UI + backend
→ No CRITICAL keywords (no payment, health, security)
→ Classification: STANDARD

STEP 3 — Check profile:
→ Multi-platform profile active? YES
→ → Triage must include UI/UX and Platform Guardian

STEP 4 — Check memory:
→ Past search implementation in project? Check context-db...
→ Found: "Project has ProductRepository with getProducts()"
→ → Has a base, doesn't need to build from scratch

STEP 5 — Determine workflow:
→ STANDARD complexity + UI involved = full-pipeline (standard mode)
→ UI/UX Specialist RELEVANT (filters are UI)
→ Platform Guardian RELEVANT (search may differ on web)

STEP 6 — Trigger triage:
→ Send to all 10 agents

OUTPUT:
  complexity: STANDARD
  workflow: full-pipeline
  estimated_agents: 7-8
  trigger: triage_all
```

---

## Example 2: Researcher analyzing context

### Request: "Add biometric authentication"

```
RESEARCHER CHAIN-OF-THOUGHT:

STEP 1 — What do I need to know?
→ Auth already implemented? YES (JWT)
→ Package for biometric? local_auth
→ Target platforms? Android + Windows + Web
→ local_auth supports Windows? ❌ NO
→ local_auth supports Web? ❌ NO

STEP 2 — Map existing architecture:
→ lib/features/auth/
    ├── data/repositories/auth_repository_impl.dart
    ├── domain/repositories/auth_repository.dart
    └── presentation/screens/login_screen.dart
→ AuthRepository interface: login(), register(), logout()
→ Need to add: loginWithBiometric()

STEP 3 — Research alternatives:
→ local_auth: Android ✅, iOS ✅, Windows ❌, Web ❌
→ Windows Hello: needs separate package
→ Web: WebAuthn API exists, but no mature Flutter package
→ DECISION: biometric for mobile only, fallback to pin/password on desktop/web

STEP 4 — Risk assessment:
→ RISK 1: Biometric enrollment may be denied → fallback needed
→ RISK 2: Device without biometric hardware → fallback needed
→ RISK 3: Biometric with expired token → re-auth needed
→ Severity: MEDIUM — all risks treatable with fallback

OUTPUT:
  platform_support: { android: true, ios: true, windows: false, web: false }
  risks: [enrollment_denied, no_hardware, expired_token]
  recommendation: "Implement biometric for mobile, fallback PIN for desktop/web"
```

---

## Example 3: Builder implementing code

### Request: Button component with design tokens

```
BUILDER CHAIN-OF-THOUGHT:

STEP 1 — Read UI guidance from UI/UX Specialist:
→ Must use: ColorScheme.primary for background
→ Must use: ColorScheme.onPrimary for text
→ Must use: TextTheme.labelLarge for button text
→ Must have: loading state, disabled state
→ Must have: Semantics label

STEP 2 — Check existing components:
→ lib/shared/widgets/ — no AppButton exists yet
→ lib/core/theme/app_theme.dart — tokens defined ✅

STEP 3 — Implementation choices:
→ Extend FilledButton or build from scratch?
→ FilledButton already follows Material 3 → extend it
→ Need custom: loading indicator, size variants

STEP 4 — Self-review before handoff:
→ ColorScheme used? ✅
→ TextTheme used? ✅
→ Loading state? ✅ (CircularProgressIndicator)
→ Disabled state? ✅ (onPressed = null)
→ Semantics? ✅
→ Responsive? ⚠️ — button width not constrained
→ → Note in handoff: need to verify responsive behavior

OUTPUT: Handoff to UI/UX Specialist with self-assessment
```

---

## Example 4: UI/UX Specialist design review

### Reviewing: LoginScreen

```
UI/UX SPECIALIST CHAIN-OF-THOUGHT:

STEP 1 — Design Token Scan:
LINE  25: Container(color: Color(0xFF1A1A2E))
          → ❌ HARD-CODED COLOR → FIX: Theme.of(context).colorScheme.surface
LINE  48: Text('Login', style: TextStyle(fontSize: 28))
          → ❌ HARD-CODED TYPOGRAPHY → FIX: Theme.of(context).textTheme.headlineMedium
LINE  67: SizedBox(height: 20)
          → ⚠️ Off-grid spacing (20 ≠ 16 or 24 on 8px grid)
LINE 102: ElevatedButton(backgroundColor: Colors.blue)
          → ❌ HARD-CODED COLOR → FIX: use FilledButton (auto-themed)

RESULT STEP 1: 3 hard-coded values → NEEDS_CHANGES

STEP 2 — Responsive Check:
→ LayoutBuilder or MediaQuery present? NO
→ Fixed width: SizedBox(width: 400)
→ → On 360dp phone: overflow clip
→ → On 1920px desktop: tiny centered box
→ FIX: ConstrainedBox(constraints: BoxConstraints(maxWidth: 400))

STEP 3 — Accessibility:
→ Password visibility toggle: missing Semantics ❌
→ "Forgot password" link: missing Semantics(link: true) ❌

STEP 4 — State Coverage:
→ Loading state: ⚠️ button shows loading but form is still editable
→ FIX: disable form fields during loading

VERDICT: NEEDS_CHANGES (4 critical, 3 major, 1 minor)
```

---

## Example 5: Platform Guardian checking package

### Checking: package "video_player" added

```
PLATFORM GUARDIAN CHAIN-OF-THOUGHT:

STEP 1 — Check pub.dev platform badges:
→ video_player v2.8.x
→ Android: ✅ | iOS: ✅ | Web: ✅ | Windows: ❌ | Linux: ❌

STEP 2 — Project targets:
→ Android ✅ → supported
→ Windows ❌ → NOT SUPPORTED ← PROBLEM
→ Web ✅ → supported

STEP 3 — Research alternatives:
→ media_kit: Windows ✅, Linux ✅ but different API
→ dart_vlc: Windows ✅ but heavy (uses VLC)

STEP 4 — Evaluate options:
Option A: video_player + fallback for Windows (simplest)
Option B: media_kit for all platforms (universal)
Option C: Conditional per platform (best UX, most complex)

STEP 5 — Recommendation:
→ If video is core feature → Option C
→ If video is nice-to-have → Option A

OUTPUT:
  status: FAIL (Windows not supported)
  recommendation: "Use conditional implementation or graceful fallback"
  blocking: depends_on_video_importance
```

---

## Chain-of-Thought Pattern

Every agent follows this pattern:
```
1. UNDERSTAND: What am I being asked?
2. CHECK: What already exists / what do I know?
3. ANALYZE: What are the options?
4. DECIDE: Which is best, with evidence?
5. OUTPUT: Structured deliverable
```
