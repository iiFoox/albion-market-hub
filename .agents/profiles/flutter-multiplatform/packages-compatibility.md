# Flutter Multi-Platform — Package Compatibility Matrix

> **Profile ID:** flutter-multiplatform  
> **Version:** 4.0.0  
> **Last Updated:** 2026-04-15

---

## Package Compatibility by Platform

### Legend
- ✅ Full support
- ⚠️ Partial/limited support
- ❌ Not supported
- 🔄 Community alternative available

---

### Core / Essential Packages

| Package | Android | iOS | Windows | Web | macOS | Linux | Notes |
|---------|---------|-----|---------|-----|-------|-------|-------|
| `http` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Web has CORS restrictions |
| `dio` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Same CORS caveat on web |
| `shared_preferences` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |
| `provider` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart |
| `riverpod` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart |
| `flutter_bloc` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart |
| `go_router` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Web URL handling built-in |
| `freezed` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Build-time, pure Dart |
| `json_serializable` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Build-time, pure Dart |
| `intl` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart |
| `get_it` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | Pure Dart |

---

### Storage / Database

| Package | Android | iOS | Windows | Web | Notes |
|---------|---------|-----|---------|-----|-------|
| `sqflite` | ✅ | ✅ | ❌ | ❌ | Mobile only — use `drift` for cross-platform |
| `sqflite_common_ffi` | ✅ | ✅ | ✅ | ❌ | Desktop via FFI, no web |
| `drift` (moor) | ✅ | ✅ | ✅ | ✅ | ✅ Best SQL option cross-platform |
| `hive` | ✅ | ✅ | ✅ | ✅ | NoSQL, fast, fully cross-platform |
| `isar` | ✅ | ✅ | ✅ | ✅ | Fast NoSQL, good cross-platform |
| `path_provider` | ✅ | ✅ | ✅ | ❌ | No file system on web |
| `flutter_secure_storage` | ✅ | ✅ | ✅ | ⚠️ | Web uses localStorage (not truly secure) |

---

### UI / Visual

| Package | Android | iOS | Windows | Web | Notes |
|---------|---------|-----|---------|-----|-------|
| `cached_network_image` | ✅ | ✅ | ✅ | ✅ | Uses different cache per platform |
| `flutter_svg` | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |
| `shimmer` | ✅ | ✅ | ✅ | ✅ | Pure Flutter |
| `lottie` | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |
| `flutter_animate` | ✅ | ✅ | ✅ | ✅ | Pure Flutter |
| `fl_chart` | ✅ | ✅ | ✅ | ✅ | Pure Flutter rendering |
| `google_fonts` | ✅ | ✅ | ✅ | ✅ | Network-fetched fonts |

---

### Device Features

| Package | Android | iOS | Windows | Web | Notes |
|---------|---------|-----|---------|-----|-------|
| `camera` | ✅ | ✅ | ❌ | ⚠️ | Web via getUserMedia, desktop unsupported |
| `image_picker` | ✅ | ✅ | ⚠️ | ⚠️ | Desktop/web = file dialog only |
| `file_picker` | ✅ | ✅ | ✅ | ✅ | Better desktop support than image_picker |
| `geolocator` | ✅ | ✅ | ⚠️ | ✅ | Windows limited, Web via Geolocation API |
| `local_notifications` | ✅ | ✅ | ⚠️ | ⚠️ | Limited on desktop/web |
| `permission_handler` | ✅ | ✅ | ❌ | ❌ | Mobile only |
| `url_launcher` | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |
| `share_plus` | ✅ | ✅ | ⚠️ | ✅ | Web Share API, Windows limited |
| `connectivity_plus` | ✅ | ✅ | ✅ | ✅ | Different APIs per platform |
| `device_info_plus` | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |
| `package_info_plus` | ✅ | ✅ | ✅ | ✅ | Fully cross-platform |

---

### Firebase

| Package | Android | iOS | Windows | Web | Notes |
|---------|---------|-----|---------|-----|-------|
| `firebase_core` | ✅ | ✅ | ❌ | ✅ | No Windows support |
| `firebase_auth` | ✅ | ✅ | ❌ | ✅ | No Windows support |
| `cloud_firestore` | ✅ | ✅ | ❌ | ✅ | No Windows support |
| `firebase_storage` | ✅ | ✅ | ❌ | ✅ | No Windows support |
| `firebase_messaging` | ✅ | ✅ | ❌ | ✅ | Web push API |
| `firebase_analytics` | ✅ | ✅ | ❌ | ✅ | No Windows support |

**Windows Alternative:** Use REST APIs directly, `supabase` or custom backend.

---

### Desktop-Specific

| Package | Windows | macOS | Linux | Notes |
|---------|---------|-------|-------|-------|
| `window_manager` | ✅ | ✅ | ✅ | Window sizing, position, always-on-top |
| `system_tray` | ✅ | ✅ | ✅ | Tray icon + menu |
| `desktop_drop` | ✅ | ✅ | ✅ | Drag-and-drop files |
| `screen_retriever` | ✅ | ✅ | ✅ | Monitor info |
| `hotkey_manager` | ✅ | ✅ | ✅ | Global hotkeys |
| `launch_at_startup` | ✅ | ✅ | ✅ | Auto-start |
| `msix` | ✅ | — | — | Windows MSIX packaging |

---

## Decision Guide

### When choosing a package:

1. **Check this matrix first** — save time
2. **Verify on pub.dev** — badges may have changed since last update
3. **Check GitHub issues** — search for `[platform]` label
4. **Prefer pure Dart** — cross-platform by definition
5. **If plugin-based** — verify platform implementations exist (federated plugins)
6. **Have a fallback plan** — what if the package drops support?

### Safe choices (always cross-platform):
- Pure Dart packages (freezed, riverpod, bloc, etc.)
- Flutter-only rendering (fl_chart, flutter_svg, shimmer, etc.)
- Officially maintained `_plus` packages (connectivity_plus, device_info_plus, etc.)

### Risky choices (check carefully):
- Camera/media packages
- File system packages
- Native notification packages
- Firebase on desktop
- Platform channel plugins
