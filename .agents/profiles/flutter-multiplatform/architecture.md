# Flutter Multi-Platform — Architecture Reference

> **Profile ID:** flutter-multiplatform  
> **Version:** 4.0.0  
> **Targets:** Android, Windows, Web, iOS  
> **Active by Default:** Yes (when project uses Flutter)

---

## 1. Architecture by Project Size

### Small Projects (1-5 screens, 1 developer)
```
lib/
├── main.dart
├── app.dart                    ← MaterialApp, routing, theme
├── core/
│   ├── theme/                  ← ThemeData, ColorScheme, TextTheme
│   ├── constants/              ← App-wide constants
│   └── utils/                  ← Helpers, extensions
├── features/
│   └── [feature_name]/
│       ├── [feature]_screen.dart      ← Screen (UI only)
│       ├── [feature]_controller.dart  ← State/logic
│       ├── [feature]_repository.dart  ← Data access
│       └── widgets/                   ← Feature-specific widgets
├── shared/
│   └── widgets/                ← Cross-feature reusable widgets
└── services/
    ├── api_service.dart        ← HTTP client
    └── storage_service.dart    ← Local persistence
```

### Medium Projects (5-20 screens, 2-4 developers)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart             ← Theme factory
│   │   ├── app_colors.dart            ← Color tokens
│   │   ├── app_typography.dart        ← Text styles
│   │   └── app_spacing.dart           ← Spacing scale
│   ├── router/
│   │   └── app_router.dart            ← GoRouter/AutoRoute config
│   ├── di/
│   │   └── injection.dart             ← Dependency injection setup
│   ├── constants/
│   └── extensions/
├── data/
│   ├── models/                        ← Data models (JSON serializable)
│   ├── repositories/                  ← Repository implementations
│   ├── datasources/
│   │   ├── remote/                    ← API data sources
│   │   └── local/                     ← Local DB data sources
│   └── mappers/                       ← Model ↔ Entity mappers
├── domain/
│   ├── entities/                      ← Business entities (pure Dart)
│   ├── repositories/                  ← Repository interfaces (abstract)
│   └── usecases/                      ← Business use cases
├── presentation/
│   ├── screens/
│   │   └── [feature]/
│   │       ├── [feature]_screen.dart
│   │       ├── [feature]_viewmodel.dart
│   │       └── widgets/
│   ├── shared/
│   │   ├── widgets/                   ← Reusable UI components
│   │   ├── dialogs/
│   │   └── layouts/                   ← Scaffold variations, responsive layouts
│   └── state/                         ← Global state (auth, theme, locale)
├── platform/                          ← Platform-specific implementations
│   ├── android/
│   ├── windows/
│   ├── web/
│   └── adapters/                      ← Platform adapter interfaces
└── services/
    ├── api/                           ← API client, interceptors
    ├── storage/                       ← Abstracted storage
    └── analytics/                     ← Analytics abstraction
```

### Large Projects (20+ screens, 5+ developers)
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_router.dart
│   └── app_bindings.dart
├── core/                              ← Shared infrastructure
│   ├── theme/
│   ├── network/
│   ├── storage/
│   ├── di/
│   ├── error/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── platform/                      ← Platform abstractions
│   └── extensions/
├── features/                          ← Feature-first organization
│   └── [feature_name]/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── screens/
│           ├── viewmodels/
│           ├── widgets/
│           └── state/
├── shared/                            ← Cross-feature shared code
│   ├── widgets/
│   ├── layouts/
│   ├── animations/
│   └── mixins/
└── l10n/                              ← Localization
    ├── app_en.arb
    └── app_pt.arb
```

---

## 2. Architecture Rules (Non-Negotiable)

### Rule 1: No Business Logic in Widget Tree
```dart
// ❌ WRONG — logic inside build method:
Widget build(BuildContext context) {
  final total = items.fold(0.0, (sum, item) => sum + item.price * item.qty);
  final discount = total > 100 ? total * 0.1 : 0;
  final finalPrice = total - discount;
  return Text('R\$ ${finalPrice.toStringAsFixed(2)}');
}

// ✅ CORRECT — logic in ViewModel/Controller:
Widget build(BuildContext context) {
  return Text('R\$ ${viewModel.formattedTotal}');
}
```

### Rule 2: View/ViewModel Separation
```dart
// View — ONLY UI concerns:
class ProductScreen extends StatelessWidget {
  // Listens to ViewModel, renders UI, delegates events
}

// ViewModel — ONLY state and logic:
class ProductViewModel extends ChangeNotifier {
  // Holds state, executes use cases, exposes computed properties
}
```

### Rule 3: Repository Pattern for Data Access
```dart
// Abstract — in domain layer:
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
}

// Concrete — in data layer:
class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remote;
  final LocalDataSource local;
  // Implementation with caching strategy
}
```

### Rule 4: Platform Adapters for Platform-Specific Code
```dart
// Interface:
abstract class StorageAdapter {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

// Mobile:
class MobileStorageAdapter implements StorageAdapter {
  // Uses secure_storage or shared_preferences
}

// Web:
class WebStorageAdapter implements StorageAdapter {
  // Uses localStorage or IndexedDB
}
```

### Rule 5: API Contracts Centralized
```dart
// All API contracts in one place:
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com/v1';
  static const String products = '/products';
  static const String auth = '/auth';
  static const String users = '/users';
}

// Use typed API client:
class ApiClient {
  Future<T> get<T>(String endpoint, T Function(Map<String, dynamic>) fromJson);
  Future<T> post<T>(String endpoint, Map<String, dynamic> body, T Function(Map<String, dynamic>) fromJson);
}
```

---

## 3. State Management Guidelines

### Recommended by Project Size
| Size | Primary | Secondary | Notes |
|------|---------|-----------|-------|
| Small | setState + Provider | — | Keep it simple |
| Medium | Riverpod or BLoC | Provider for simple state | Pick one and commit |
| Large | Riverpod or BLoC | — | Consistent across all features |

### Rules
1. **Pick ONE** state management solution and use it everywhere
2. **Never mix** — don't use Provider in one feature and BLoC in another
3. **Global state** (auth, theme, locale) managed at app level
4. **Feature state** managed at feature level, disposed when leaving
5. **Use computed/derived state** — don't duplicate data

---

## 4. Navigation Guidelines

### Recommended: GoRouter or AutoRoute

```dart
// GoRouter setup:
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/products/:id', builder: (_, state) =>
      ProductScreen(id: state.pathParameters['id']!)),
  ],
  redirect: (context, state) {
    // Auth guard
    if (!isLoggedIn && state.uri.path != '/login') return '/login';
    return null;
  },
);
```

### Adaptive Navigation Pattern
```dart
class AdaptiveNavigation extends StatelessWidget {
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return Scaffold(bottomNavigationBar: BottomNavBar());
    } else if (width < 1024) {
      return Scaffold(body: Row(children: [NavigationRail(), Expanded(child: content)]));
    } else {
      return Scaffold(body: Row(children: [NavigationDrawer(), Expanded(child: content)]));
    }
  }
}
```

---

## 5. Dependency Injection

### Recommended: get_it + injectable (Medium/Large)

```dart
// Setup:
@InjectableInit()
void configureDependencies() => getIt.init();

// Registration:
@lazySingleton
class ApiClient { ... }

@injectable
class ProductRepository {
  ProductRepository(this._apiClient); // Auto-injected
  final ApiClient _apiClient;
}
```

### For Small Projects: Manual DI via Provider
```dart
MultiProvider(
  providers: [
    Provider(create: (_) => ApiClient()),
    ProxyProvider<ApiClient, ProductRepository>(
      update: (_, api, __) => ProductRepository(api),
    ),
  ],
)
```
