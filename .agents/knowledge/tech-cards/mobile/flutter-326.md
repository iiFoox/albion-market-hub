# Flutter 3.26 — Tech Card

> **Category:** Mobile Framework (Cross-platform)
> **Current Version:** 3.26.x
> **Platforms:** iOS, Android, Web, Windows, macOS, Linux
> **Language:** Dart

---

## Quick Setup
```bash
flutter create myapp --org com.example --platforms ios,android
cd myapp && flutter run
```

## Key Features
- **Hot Reload** — sub-second UI updates without losing state
- **Dart 3.x** — records, patterns, sealed classes
- **Impeller renderer** — new rendering engine (smoother, consistent 60fps)
- **Material 3** — Google's latest design system built-in
- **Platform Channels** — call native iOS/Android code from Dart
- **Widget system** — compose UI from small, reusable widgets

## Top 10 Best Practices

1. **Use `StatelessWidget`** when possible — cheaper than `StatefulWidget`
2. **Use `const` constructors** — enables widget tree optimization
3. **Use BLoC or Riverpod** — for state management (not `setState` in complex apps)
4. **Use `go_router`** — declarative routing with deep link support
5. **Use `freezed`** — immutable data classes with `copyWith`, JSON serialization
6. **Separate UI from logic** — never put business logic in widgets
7. **Use `flutter_lint`** — enable all recommended lint rules
8. **Test widgets** — `testWidgets()` with `WidgetTester`
9. **Use themes** — `ThemeData` for consistent styling
10. **Use `late` carefully** — prefer nullable types with null checks

## Top 10 Gotchas

1. ❌ **`setState` for everything** — use state management for shared state
2. ❌ **Deep widget nesting** — extract into separate widget classes
3. ❌ **Not using `const`** — widgets without `const` rebuild unnecessarily
4. ❌ **`BuildContext` after async** — context may be invalid; check `mounted`
5. ❌ **Large `build()` methods** — break into smaller widgets
6. ❌ **ListView without `builder`** — `ListView.builder` virtualizes; `ListView` doesn't
7. ❌ **Images without caching** — use `cached_network_image`
8. ❌ **Missing null safety** — Dart is null-safe; use `?`, `!`, `??` properly
9. ❌ **Platform-specific code without checks** — use `Platform.isIOS`
10. ❌ **Not disposing controllers** — `TextEditingController`, `AnimationController` must dispose

## Project Structure
```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── app.dart             # MaterialApp configuration
│   └── routes.dart          # GoRouter configuration
├── features/
│   ├── auth/
│   │   ├── presentation/    # Screens, Widgets
│   │   ├── domain/          # Entities, Use Cases
│   │   ├── data/            # Repositories, Data Sources
│   │   └── bloc/            # BLoC/Cubit state management
│   └── home/
├── shared/
│   ├── widgets/             # Reusable widgets
│   ├── theme/               # ThemeData, colors, typography
│   └── utils/               # Helpers, extensions
└── core/
    ├── network/             # Dio/http client configuration
    ├── storage/             # SharedPreferences, Hive
    └── di/                  # Dependency injection (get_it)
```

## State Management Decision
| Complexity | Solution |
|---|---|
| Single widget state | `setState` |
| Shared between widgets | `InheritedWidget` / `Provider` |
| Complex app state | `Riverpod` or `BLoC` |
| Form state | `flutter_form_builder` |

## Performance Checklist
- [ ] Use `const` widgets wherever possible
- [ ] Use `ListView.builder` for long lists (not `ListView`)
- [ ] Cache network images (`cached_network_image`)
- [ ] Profile with Flutter DevTools (timeline, memory)
- [ ] Use `RepaintBoundary` to isolate frequently changing areas
- [ ] Minimize `setState` scope (only the widget that needs rebuild)
- [ ] Use Impeller renderer (default on iOS, opt-in on Android)
