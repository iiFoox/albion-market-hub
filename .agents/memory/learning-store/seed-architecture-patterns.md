---
id: "ls-seed-arch-003"
type: "best-practice"
created: "2026-04-23T14:40:00-03:00"
outcome: "positive"
impact_score: 0.85
confidence: 0.9
project_context: "any-flutter-project"
request_id: "seed"
agents_involved: ["planner", "builder", "researcher"]
tags: ["flutter", "architecture", "state-management", "navigation", "api", "error-handling"]
related_memories: []
reviewed: true
review_date: "2026-04-23"
---

## Summary
Architecture and code patterns that prevent structural bugs and tech debt.

## Learnings

### L18: State management — pick ONE and be consistent
```
Riverpod: Best for new projects, testable, compile-safe
BLoC: Best for large teams, strict pattern, more boilerplate
Provider: Legacy — works but Riverpod is better in every way

❌ NEVER mix state solutions in the same project
❌ NEVER use setState for anything beyond single-widget local state
```
**Decision tree:**
- Solo/small team → Riverpod
- Large team, strict patterns needed → BLoC
- Existing Provider project → Don't migrate unless pain is real

---

### L19: GoRouter deep links — different config needed per platform
```dart
// Web: uses URL path directly (yourapp.com/products/123)
// Mobile: needs intent-filter (Android) or Associated Domains (iOS)
// Windows: no native deep link support

// Common mistake: testing deep links only on mobile, then they don't work on Web
// because Web uses hash routing by default
GoRouter(
  // ✅ Use path URL strategy for Web (no #)
  routerConfig: GoRouter(routes: [...]),
)

// In web/index.html:
// <script>
//   const strategy = new URL(window.location.href).searchParams.get('usePath');
// </script>
```

---

### L20: API error handling — ALWAYS map server errors to user-friendly messages
```dart
// ❌ WRONG — shows raw error to user
catch (e) {
  showSnackBar(e.toString()); // "DioException [400]: {"error":"invalid_field"}"
}

// ✅ CORRECT — map to user-friendly
catch (e) {
  final message = ApiErrorMapper.toUserMessage(e);
  showSnackBar(message); // "Dados inválidos. Verifique e tente novamente."
}
```
**Always have:** An error mapper class that converts API errors to localized strings.

---

### L21: Repository pattern — ALWAYS abstract data source from UI
```
UI Layer → UseCase (optional) → Repository Interface → Repository Impl → Data Source

❌ WRONG: Widget calls Dio directly
✅ CORRECT: Widget calls ViewModel → calls Repository → calls API

Benefits:
- Easy to swap data source (API → mock for testing)
- Easy to add caching layer
- Easy to add offline support later
- Testable without network
```

---

### L22: Dependency Injection — use get_it or Riverpod, never manual
```dart
// ❌ WRONG — manual instantiation, untestable
class LoginScreen {
  final repo = AuthRepositoryImpl(ApiClient());
}

// ✅ CORRECT — DI container
// With get_it:
final getIt = GetIt.instance;
getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));

// With Riverpod:
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(apiClientProvider));
});
```

---

### L23: Commits — follow Conventional Commits strictly
```
feat(auth): add biometric login for Android
fix(cart): resolve total calculation with discounts
refactor(products): extract ProductCard into sub-widgets
docs(readme): update setup instructions for Windows
chore(deps): bump flutter_bloc to 8.1.4
test(auth): add unit tests for login validation

Breaking: feat(api)!: change response format for /products endpoint
```
**Why:** Enables automatic changelog, semantic versioning, and clear git history.

---

### L24: Never store secrets in code — use environment variables
```dart
// ❌ WRONG — API key in source code
const apiKey = 'sk-abc123...';

// ✅ CORRECT — from environment
// .env file (gitignored)
// API_KEY=sk-abc123...

// In code:
final apiKey = const String.fromEnvironment('API_KEY');
// OR use flutter_dotenv package
```

## Conditions for Reuse
Any Flutter project with clean architecture aspirations.
