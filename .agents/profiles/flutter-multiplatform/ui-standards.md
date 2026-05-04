# Flutter Multi-Platform — UI Standards

> **Profile ID:** flutter-multiplatform  
> **Version:** 4.0.0

---

## 1. Design Tokens

### Color System
```dart
// Use ColorScheme from Material 3 — NEVER hard-code colors
class AppColors {
  // Semantic colors (light theme):
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF...), 
    onPrimary: Color(0xFF...),
    secondary: Color(0xFF...),
    onSecondary: Color(0xFF...),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    // ... complete scheme
  );

  // Dark theme:
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // ... complete dark scheme
  );
}

// Usage in widgets:
Theme.of(context).colorScheme.primary      // ✅ CORRECT
Color(0xFF6750A4)                           // ❌ WRONG — hard-coded
```

### Typography Scale
```dart
class AppTypography {
  static TextTheme textTheme = TextTheme(
    displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
    displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
    headlineMedium:TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge:    TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
    titleMedium:   TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleSmall:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );
}

// Usage:
Theme.of(context).textTheme.titleLarge    // ✅ CORRECT
TextStyle(fontSize: 22)                    // ❌ WRONG — hard-coded
```

### Spacing Scale (8px Grid)
```dart
class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Edge insets helpers:
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
}

// Usage:
Padding(padding: AppSpacing.paddingMd)    // ✅ CORRECT
Padding(padding: EdgeInsets.all(16))       // ⚠️ OK but prefer token
Padding(padding: EdgeInsets.all(13))       // ❌ WRONG — off-grid
```

### Elevation / Shadow System
```dart
class AppElevation {
  static const double level0 = 0;   // Flat
  static const double level1 = 1;   // Cards, app bar
  static const double level2 = 3;   // Raised buttons, navigation
  static const double level3 = 6;   // FAB, bottom sheets
  static const double level4 = 8;   // Dialogs
  static const double level5 = 12;  // Modals, drawers
}
```

### Border Radius
```dart
class AppRadius {
  static const double none = 0;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 28;
  static const double full = 999;  // Fully rounded (pills)

  static BorderRadius get cardRadius => BorderRadius.circular(lg);
  static BorderRadius get buttonRadius => BorderRadius.circular(xxl);
  static BorderRadius get chipRadius => BorderRadius.circular(sm);
}
```

---

## 2. Responsive Breakpoints

```dart
class AppBreakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double wideDesktop = 1440;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet &&
      MediaQuery.of(context).size.width < desktop;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}

// Responsive Builder Pattern:
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext) mobile;
  final Widget Function(BuildContext)? tablet;
  final Widget Function(BuildContext)? desktop;

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= AppBreakpoints.desktop) {
        return (desktop ?? tablet ?? mobile)(context);
      } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
        return (tablet ?? mobile)(context);
      }
      return mobile(context);
    });
  }
}
```

---

## 3. Adaptive Widgets (Platform-Aware)

```dart
// Navigation — adapts to platform and screen size:
// Mobile: BottomNavigationBar
// Tablet: NavigationRail
// Desktop: NavigationDrawer (persistent)

// Dialogs — adapts to platform:
// Mobile: BottomSheet or fullscreen dialog
// Desktop: Centered dialog with max width

// Lists — adapts to screen:
// Mobile: Single column
// Tablet: 2 columns or master-detail
// Desktop: Multi-column or data table

// Input — adapts to platform:
// Mobile: Touch-optimized, larger targets
// Desktop: Mouse/keyboard-optimized, denser layout
```

---

## 4. Component Library Standards

### Every Reusable Component Must Have:
1. **const constructor** where possible
2. **Named parameters** for configuration
3. **Default values** following design tokens
4. **Required semantic label** for accessibility
5. **All interactive states handled** (hover, focus, press, disabled)
6. **Theme-aware** — reads from Theme.of(context), never hard-codes
7. **Documented** — dartdoc comment explaining purpose and usage

### Example:
```dart
/// A primary action button following the app's design system.
/// 
/// Uses [colorScheme.primary] for background and [colorScheme.onPrimary] for text.
/// Supports loading state with circular progress indicator.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: FilledButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        child: isLoading
            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(label),
      ),
    );
  }
}
```

---

## 5. Animation Guidelines

### Duration Standards
| Type | Duration | Curve |
|------|----------|-------|
| Micro (ripple, fade) | 100-150ms | easeOut |
| Small (expand, collapse) | 200-250ms | easeInOut |
| Medium (page transition) | 300-400ms | easeInOutCubic |
| Large (complex, multi-step) | 500-700ms | easeInOutCubicEmphasized |

### Rules
1. **Prefer implicit animations** (AnimatedContainer, AnimatedOpacity) over explicit (AnimationController)
2. **Use `Curves.easeInOutCubic`** as default — never linear
3. **Respect reduced motion settings:** Check `MediaQuery.of(context).disableAnimations`
4. **Every animation must have purpose** — if removing the animation loses no meaning, remove it
5. **Use Hero animations** for shared element transitions between screens

---

## 6. Dark Mode / Light Mode

### Rules
1. **Both modes must be fully functional** — dark mode is not optional
2. **Use ColorScheme** — all theme variants auto-adapt
3. **Test both modes** on every screen
4. **Surface colors** follow Material 3 tonal surface system
5. **Images/icons** should have dark mode variants if they contain fixed colors
6. **Contrast ratios** must be verified in both modes
