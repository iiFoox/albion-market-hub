# Chain-of-Thought Examples — Raciocínio Passo a Passo

> **Propósito:** Mostrar EXATAMENTE como cada agente pensa, passo a passo  
> **Formato:** Pensamento interno → Ação → Output

---

## Exemplo 1: Orchestrator classificando uma request

### Request: "Implementar busca de produtos com filtros"

```
ORCHESTRATOR CHAIN-OF-THOUGHT:

STEP 1 — Parse intent:
→ "Implementar" = criar algo novo
→ "busca de produtos" = feature de busca
→ "com filtros" = UI + lógica combinados
→ Classificação: FEATURE

STEP 2 — Check keywords:
→ "implementar" = STANDARD keyword ✅
→ "busca" = pode envolver full-text search (DEEP?)
→ "filtros" = UI + backend
→ Nenhum keyword CRITICAL (não tem payment, health, security)
→ Classificação: STANDARD

STEP 3 — Check profile:
→ Flutter multi-platform active? SIM
→ → Triage deve incluir UI/UX e Platform Guardian

STEP 4 — Check memory:
→ Existe busca anterior no projeto? Verificar context-db...
→ Encontrado: "Projeto tem ProductRepository com getProducts()"
→ → Já tem base, não precisa criar do zero

STEP 5 — Determine workflow:
→ STANDARD complexity + UI envolvida = full-pipeline (standard mode)
→ UI/UX Specialist RELEVANT (filtros são UI)
→ Platform Guardian RELEVANT (busca pode diferir em web)

STEP 6 — Trigger triage:
→ Enviar para todos os 10 agentes

OUTPUT:
  complexity: STANDARD
  workflow: full-pipeline
  estimated_agents: 7-8
  trigger: triage_all
```

---

## Exemplo 2: Researcher analisando contexto

### Request: "Adicionar autenticação biométrica"

```
RESEARCHER CHAIN-OF-THOUGHT:

STEP 1 — What do I need to know?
→ Existe auth já implementada? SIM (JWT)
→ Qual package para biometric? local_auth
→ Quais plataformas? Android + Windows + Web
→ local_auth suporta Windows? ❌ NÃO
→ local_auth suporta Web? ❌ NÃO

STEP 2 — Map existing architecture:
→ lib/features/auth/
    ├── data/repositories/auth_repository_impl.dart
    ├── domain/repositories/auth_repository.dart
    └── presentation/screens/login_screen.dart
→ AuthRepository interface: login(), register(), logout()
→ Preciso adicionar: loginWithBiometric()
→ TokenService existe para JWT storage

STEP 3 — Research alternatives:
→ local_auth: Android ✅, iOS ✅, Windows ❌, Web ❌
→ Windows Hello: precisa de package separado (windows_biometric?)
→ Web: WebAuthn API existe, mas nenhum Flutter package maduro
→ DECISÃO: biometric só para mobile, fallback para pin/password em desktop/web

STEP 4 — Risk assessment:
→ RISCO 1: Biometric enrollment pode ser denied → fallback necessário
→ RISCO 2: Device sem biometric hardware → fallback necessário  
→ RISCO 3: Biometric com token expirado → re-auth necessário
→ Severity: MEDIUM — riscos são todos tratáveis com fallback

STEP 5 — Check memory:
→ Known-issues.md: local_auth entry:
  "Android ✅, iOS ✅, Windows ❌, Web ❌"
→ Confirma minha pesquisa

OUTPUT:
  context_map:
    auth_exists: true (JWT)
    auth_repository: lib/features/auth/domain/repositories/auth_repository.dart
    token_service: lib/core/services/token_service.dart
    package: local_auth (mobile only)
    platform_support: { android: true, ios: true, windows: false, web: false }
  risks: [enrollment_denied, no_hardware, expired_token]
  recommendation: "Implement biometric for mobile, fallback PIN for desktop/web"
```

---

## Exemplo 3: Builder implementando código

### Request: Button component com design tokens

```
BUILDER CHAIN-OF-THOUGHT:

STEP 1 — Read UI guidance from UI/UX Specialist:
→ Must use: ColorScheme.primary for background
→ Must use: ColorScheme.onPrimary for text
→ Must use: TextTheme.labelLarge for button text
→ Must use: AppRadius.buttonRadius (28px full rounded)
→ Must have: loading state, disabled state
→ Must have: Semantics label

STEP 2 — Check existing components:
→ lib/shared/widgets/ — no AppButton exists yet
→ lib/core/theme/app_theme.dart — tokens defined ✅

STEP 3 — ImplementaçÃO choices:
→ Extend FilledButton or build from scratch?
→ FilledButton already follows Material 3 → extend it
→ Need custom: loading indicator, size variants

STEP 4 — Write code:
```dart
/// Primary action button following the app's design system.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.semanticLabel,
    this.size = AppButtonSize.medium,
  });

  // ... implementation
}
```

STEP 5 — Self-review before handoff:
→ ColorScheme used? ✅ (via FilledButton theme)
→ TextTheme used? ✅ (via button style)
→ Loading state? ✅ (CircularProgressIndicator)
→ Disabled state? ✅ (onPressed = null)
→ Semantics? ✅ (label on Semantics widget)
→ const constructor? ✅
→ Responsive? ⚠️ — button width not constrained
→ → Note in handoff: need to verify responsive behavior

OUTPUT: Handoff to UI/UX Specialist with self-assessment
```

---

## Exemplo 4: UI/UX Specialist em design review

### Reviewing: LoginScreen

```
UI/UX SPECIALIST CHAIN-OF-THOUGHT:

STEP 1 — Design Token Scan (automated):
LINE  25: Container(color: Color(0xFF1A1A2E))
          → ❌ HARD-CODED COLOR
          → FIX: Theme.of(context).colorScheme.surface
LINE  48: Text('Login', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
          → ❌ HARD-CODED TYPOGRAPHY
          → FIX: Theme.of(context).textTheme.headlineMedium
LINE  67: SizedBox(height: 20)
          → ⚠️ Off-grid spacing (20 ≠ 16 or 24 on 8px grid)
          → FIX: SizedBox(height: AppSpacing.lg) // 24
LINE 102: ElevatedButton(style: ..., backgroundColor: Colors.blue)
          → ❌ HARD-CODED COLOR
          → FIX: use FilledButton (auto-themed) or Theme.of(context).colorScheme.primary

RESULTADO ETAPA 1: 3 hard-coded values found → NEEDS_CHANGES at minimum

STEP 2 — Responsive Check:
→ LayoutBuilder or MediaQuery present? NO
→ Fixed width: SizedBox(width: 400)
→ → On 360dp phone: overflow clip
→ → On 1920px desktop: tiny centered box
→ FIX: ConstrainedBox(constraints: BoxConstraints(maxWidth: 400))
→ FIX: Wrap in Center for desktop

RESULTADO ETAPA 2: No responsive handling → NEEDS_CHANGES

STEP 3 — Accessibility:
→ Email field: has label ✅
→ Password field: has label ✅ 
→ Password visibility toggle: missing Semantics ❌
→ Login button: text is descriptive ✅
→ "Forgot password" link: missing Semantics(link: true) ❌
→ Contrast: Cannot verify without running, but Color(0xFF1A1A2E) on  
  white text looks OK. Colors need runtime check.

RESULTADO ETAPA 3: 2 missing Semantics → NEEDS_CHANGES

STEP 4 — State Coverage:
→ Default state: ✅ rendered
→ Loading state: ⚠️ button shows loading but form is still editable
    → FIX: disable form fields during loading
→ Error state: ✅ SnackBar
→ Success state: ✅ navigates to home

STEP 5 — Compile verdict:
→ Hard-coded colors: 2 critical
→ Hard-coded typography: 1 critical
→ Off-grid spacing: 1 minor
→ No responsive: 1 critical
→ Missing Semantics: 2 major
→ Loading form editable: 1 major

VERDICT: NEEDS_CHANGES (4 critical, 3 major, 1 minor)
```

---

## Exemplo 5: Platform Guardian verificando package

### Verificando: package "video_player" adicionado

```
PLATFORM GUARDIAN CHAIN-OF-THOUGHT:

STEP 1 — Check pub.dev platform badges:
→ video_player v2.8.x
→ Android: ✅ (ExoPlayer)
→ iOS: ✅ (AVPlayer)
→ Web: ✅ (HTML5 <video>)
→ Windows: ❌ NOT SUPPORTED
→ macOS: ✅
→ Linux: ❌

STEP 2 — Project targets:
→ Android ✅ → supported
→ Windows ❌ → NOT SUPPORTED ← PROBLEM
→ Web ✅ → supported

STEP 3 — Check known-issues.md:
→ No entry for video_player
→ Need to add one

STEP 4 — Research alternatives:
→ media_kit: Windows ✅, Linux ✅ but different API
→ dart_vlc: Windows ✅ but uses vlc under the hood, heavy
→ video_player_win: community package, limited support

STEP 5 — Evaluate options:
Option A: Use video_player, add fallback for Windows
  → Fallback: show "Video playback not available on Windows" message
  → OR: link to external player
  → Impact: degraded experience on Windows

Option B: Use media_kit for all platforms
  → More complex but universal
  → Different API from video_player
  → Less documentation

Option C: Conditional — video_player on mobile/web, media_kit on Windows
  → Most complex to maintain
  → Best user experience per platform

STEP 6 — Recommendation:
→ If video is core feature → Option C (best UX)
→ If video is nice-to-have → Option A (simplest)
→ Decision should be escalated if video is important to the product

OUTPUT:
  package: video_player
  status: FAIL (Windows not supported)
  recommendation: "Use conditional implementation or graceful fallback"
  add_to_known_issues: true
  blocking: depends_on_video_importance
```

---

## Padrão de Chain-of-Thought

Cada agente segue este padrão:
```
1. UNDERSTAND: O que me pediram?
2. CHECK: O que já existe/sei?
3. ANALYZE: Quais são as opções?
4. DECIDE: Qual a melhor com evidence?
5. OUTPUT: Entrega estruturada
```
