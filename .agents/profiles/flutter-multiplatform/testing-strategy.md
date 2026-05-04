# Flutter Multi-Platform — Testing Strategy

> **Profile ID:** flutter-multiplatform  
> **Version:** 4.0.0

---

## 1. Test Pyramid for Flutter

```
          ┌─────────────────┐
          │   Integration /  │  ← Few: Full user flows
          │   E2E Tests      │     (10% of test effort)
          ├─────────────────┤
          │   Widget Tests   │  ← Many: Component behavior
          │                  │     (30% of test effort)
          ├─────────────────┤
          │   Unit Tests     │  ← Most: Business logic
          │                  │     (60% of test effort)
          └─────────────────┘
```

---

## 2. Unit Tests

### What to Test
- UseCases / Business Logic
- Repositories (with mocked data sources)
- ViewModels / Controllers (state transitions)
- Utilities and Extensions
- Model serialization (fromJson / toJson)

### Example
```dart
// test/domain/usecases/calculate_total_test.dart
void main() {
  group('CalculateTotal', () {
    test('should sum all item prices', () {
      final items = [Item(price: 10), Item(price: 20), Item(price: 30)];
      final result = calculateTotal(items);
      expect(result, equals(60.0));
    });

    test('should apply discount when total > 100', () {
      final items = [Item(price: 50), Item(price: 60)];
      final result = calculateTotal(items, applyDiscount: true);
      expect(result, equals(99.0)); // 110 - 10% = 99
    });

    test('should return 0 for empty list', () {
      expect(calculateTotal([]), equals(0.0));
    });
  });
}
```

### Tools
- `flutter_test` (built-in)
- `mockito` + `build_runner` for mocks
- `mocktail` as lightweight alternative

---

## 3. Widget Tests

### What to Test
- Widget renders correctly with given data
- Widget responds to user interactions
- Widget handles all states (loading, error, empty, data)
- Widget accessibility (semantic labels present)
- Widget responsive behavior (different sizes)

### Example
```dart
// test/presentation/widgets/product_card_test.dart
void main() {
  group('ProductCard', () {
    testWidgets('renders product name and price', (tester) async {
      final product = Product(name: 'Test', price: 29.99);
      
      await tester.pumpWidget(
        MaterialApp(home: ProductCard(product: product)),
      );
      
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('R\$ 29.99'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(home: ProductCard(
          product: mockProduct,
          onTap: () => tapped = true,
        )),
      );
      
      await tester.tap(find.byType(ProductCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading skeleton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductCard.loading()),
      );
      
      expect(find.byType(Shimmer), findsWidgets);
    });

    testWidgets('has correct semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: ProductCard(product: mockProduct)),
      );
      
      final semantics = tester.getSemantics(find.byType(ProductCard));
      expect(semantics.label, contains('Test Product'));
    });
  });
}
```

---

## 4. Golden Tests (Visual Regression)

### Purpose
Snapshot testing — compare widget rendering against golden (reference) images. Catches unintended visual changes.

### Example
```dart
testWidgets('AppButton matches golden', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: AppButton(label: 'Submit', onPressed: () {}),
    ),
  );
  
  await expectLater(
    find.byType(AppButton),
    matchesGoldenFile('goldens/app_button_light.png'),
  );
});
```

### Rules
1. Generate goldens for both light and dark mode
2. Generate goldens at mobile, tablet, and desktop widths
3. Update goldens intentionally — review every golden diff in PR
4. Use `flutter test --update-goldens` to regenerate

---

## 5. Integration / E2E Tests

### What to Test
- Critical user flows (login, checkout, CRUD operations)
- Navigation flows (deep links, back button)
- Offline → online transitions
- Multi-step forms

### Example
```dart
// integration_test/auth_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Enter credentials
    await tester.enterText(find.byKey(Key('email_field')), 'user@test.com');
    await tester.enterText(find.byKey(Key('password_field')), 'password123');
    
    // Tap login
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    // Verify navigation to home
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
```

### Run per platform:
```bash
flutter test integration_test --device-id=<device>
```

---

## 6. Platform-Specific Tests

### Testing Platform Adapters
```dart
// test/platform/storage_adapter_test.dart
void main() {
  group('MobileStorageAdapter', () {
    test('writes and reads value', () async {
      final adapter = MobileStorageAdapter();
      await adapter.write('key', 'value');
      final result = await adapter.read('key');
      expect(result, equals('value'));
    });
  });
  
  // Similar test for WebStorageAdapter and DesktopStorageAdapter
}
```

### Conditional Test Execution
```dart
testWidgets('shows bottom nav on mobile', (tester) async {
  // Set screen size to mobile
  tester.view.physicalSize = Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  
  await tester.pumpWidget(MaterialApp(home: MainScreen()));
  
  expect(find.byType(BottomNavigationBar), findsOneWidget);
  expect(find.byType(NavigationRail), findsNothing);
  
  addTearDown(tester.view.resetPhysicalSize);
});
```

---

## 7. Test Organization

```
test/
├── unit/
│   ├── domain/
│   │   ├── entities/
│   │   └── usecases/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   └── datasources/
│   └── core/
│       └── utils/
├── widget/
│   ├── screens/
│   ├── shared/
│   └── goldens/
├── integration/
│   └── flows/
├── fixtures/                  ← JSON fixtures for testing
│   ├── product.json
│   └── user.json
└── helpers/                   ← Test utilities
    ├── test_app.dart          ← Wrapper with providers/theme
    ├── mocks.dart             ← Generated mocks
    └── finders.dart           ← Custom finders
```

---

## 8. Coverage Targets

| Layer | Minimum Coverage | Target Coverage |
|-------|-----------------|-----------------|
| Domain (entities, usecases) | 90% | 95% |
| Data (repositories, models) | 80% | 90% |
| Presentation (viewmodels) | 80% | 85% |
| Widgets (key components) | 70% | 80% |
| E2E (critical flows) | — | All critical paths |

### Run coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```
