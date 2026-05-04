# Flutter Multi-Platform — Platform Compatibility Checklist

> **Profile ID:** flutter-multiplatform  
> **Version:** 4.0.0

---

## Pre-Delivery Platform Checklist

Use this checklist BEFORE marking any feature as complete.

---

### ✅ Android Checklist

| # | Check | Status |
|---|-------|--------|
| 1 | `minSdkVersion` compatible with all packages | ☐ |
| 2 | `targetSdkVersion` is current (34+) | ☐ |
| 3 | Required permissions declared in `AndroidManifest.xml` | ☐ |
| 4 | Runtime permissions requested before use | ☐ |
| 5 | ProGuard/R8 rules configured for packages that need them | ☐ |
| 6 | App tested on at least 2 screen sizes (phone + tablet) | ☐ |
| 7 | Back button behavior correct (physical + gesture) | ☐ |
| 8 | Splash screen configured (android 12+ splash API) | ☐ |
| 9 | Deep links configured in `AndroidManifest.xml` (if applicable) | ☐ |
| 10 | Gradle dependencies resolve without conflicts | ☐ |

---

### ✅ Windows Checklist

| # | Check | Status |
|---|-------|--------|
| 1 | Window minimum size set in `main.cpp` or via `window_manager` | ☐ |
| 2 | Window title set correctly | ☐ |
| 3 | App tested at multiple window sizes (resizing) | ☐ |
| 4 | Keyboard navigation works (Tab, Enter, Escape) | ☐ |
| 5 | Mouse hover states visible on interactive elements | ☐ |
| 6 | Right-click context menus where appropriate | ☐ |
| 7 | File paths use platform-aware handling (path package) | ☐ |
| 8 | No `dart:html` imports in non-web code | ☐ |
| 9 | MSIX packaging configured (if targeting Store) | ☐ |
| 10 | Visual C++ redistributable documented or bundled | ☐ |
| 11 | Scrollbar visible (Windows users expect scrollbars) | ☐ |
| 12 | Text selection enabled where appropriate | ☐ |

---

### ✅ Web Checklist

| # | Check | Status |
|---|-------|--------|
| 1 | No `dart:io` imports in shared code | ☐ |
| 2 | CORS configured for all API endpoints | ☐ |
| 3 | Renderer specified in `web/index.html` (CanvasKit/Wasm) | ☐ |
| 4 | Base href correct for deployment path | ☐ |
| 5 | URL strategy configured (hash vs path) | ☐ |
| 6 | Browser refresh doesn't lose app state | ☐ |
| 7 | Loading indicator shown during Flutter engine initialization | ☐ |
| 8 | Favicon and `manifest.json` configured | ☐ |
| 9 | Text is selectable where appropriate | ☐ |
| 10 | Tab/keyboard navigation works | ☐ |
| 11 | Browser back/forward buttons work with GoRouter | ☐ |
| 12 | No localStorage overflow (careful with large data) | ☐ |
| 13 | Images have proper `width`/`height` to prevent layout shift | ☐ |
| 14 | Service worker configured for PWA (if applicable) | ☐ |

---

### ✅ iOS Checklist

| # | Check | Status |
|---|-------|--------|
| 1 | Minimum iOS version compatible with all packages | ☐ |
| 2 | `Info.plist` permission descriptions present (camera, location, etc.) | ☐ |
| 3 | App tested on multiple screen sizes (SE, standard, Plus, iPad) | ☐ |
| 4 | Safe area handled (notch, Dynamic Island, home indicator) | ☐ |
| 5 | Swipe-back gesture navigation works | ☐ |
| 6 | Keyboard avoidance (resize/scroll when keyboard appears) | ☐ |
| 7 | Dark mode follows system setting | ☐ |
| 8 | Provisioning profiles and signing configured | ☐ |
| 9 | App Store assets prepared (screenshots, descriptions) | ☐ |
| 10 | No private API usage (App Store rejection risk) | ☐ |

---

### ✅ Cross-Platform Checks (All Platforms)

| # | Check | Status |
|---|-------|--------|
| 1 | All platform-specific code uses conditional imports | ☐ |
| 2 | `kIsWeb` checked BEFORE `Platform.is*` | ☐ |
| 3 | Feature fallbacks defined for unsupported platforms | ☐ |
| 4 | Theme adapts to platform (Material/Cupertino/Fluent) | ☐ |
| 5 | Responsive layout works at mobile/tablet/desktop widths | ☐ |
| 6 | Navigation adapts to screen size (bottom nav → rail → drawer) | ☐ |
| 7 | Touch targets ≥ 48dp on mobile, mouse-friendly on desktop | ☐ |
| 8 | Text input behavior correct per platform | ☐ |
| 9 | Scroll behavior correct per platform (momentum vs precise) | ☐ |
| 10 | Accessibility works per platform (TalkBack, Narrator, VoiceOver, screen reader) | ☐ |

---

## Verdict Template

```markdown
## Platform Compatibility Verdict — [Feature Name]

| Platform | Checks Passed | Total | Verdict |
|----------|--------------|-------|---------|
| Android | X/10 | 10 | ✅ PASS / ⚠️ WARN / ❌ FAIL |
| Windows | X/12 | 12 | ✅ PASS / ⚠️ WARN / ❌ FAIL |
| Web | X/14 | 14 | ✅ PASS / ⚠️ WARN / ❌ FAIL |
| iOS | X/10 | 10 | ✅ PASS / ⚠️ WARN / ❌ FAIL |
| Cross-Platform | X/10 | 10 | ✅ PASS / ⚠️ WARN / ❌ FAIL |

**Overall:** PASS / PASS_WITH_WARNINGS / FAIL
**Blocking items:** [list]
**Non-blocking warnings:** [list]
```
