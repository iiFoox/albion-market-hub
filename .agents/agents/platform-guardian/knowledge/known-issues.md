# Known Cross-Platform Issues — Platform Guardian Knowledge Base

> **Last Updated:** 2026-04-15
> **Maintained by:** Platform Guardian Agent
> **Purpose:** Quick reference of known compatibility issues, workarounds, and package limitations

---

## Flutter Framework Issues

### Web Renderer Selection
| Renderer | Quality | Size | Performance | Use Case |
|----------|---------|------|-------------|----------|
| CanvasKit | High (desktop-like) | ~2MB payload | Good | Apps needing pixel-perfect rendering |
| HTML | Variable | Smaller | Good for text | Content-heavy, SEO-needed |
| Wasm (skwasm) | High | Medium | Best | Flutter 3.22+ recommended for production |

**Issue:** Default renderer changed across Flutter versions. Always specify explicitly in `web/index.html`.

### dart:io on Web
- **Issue:** `dart:io` is completely unavailable on web target
- **Affected:** File, Directory, Platform, Process, HttpClient, Socket, InternetAddress
- **Workaround:** Conditional imports with `dart.library.io` / `dart.library.html`
- **Pattern:**
```dart
export 'src/stub.dart'
    if (dart.library.io) 'src/mobile.dart'
    if (dart.library.html) 'src/web.dart';
```

### Platform.isX on Web
- **Issue:** `Platform.isAndroid`, `Platform.isWindows`, etc. throw on web
- **Workaround:** Check `kIsWeb` first, then `Platform.is*`
```dart
if (kIsWeb) {
  // web-specific
} else if (Platform.isAndroid) {
  // android-specific
}
```

---

## Common Package Issues

### sqflite
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ Native | Works out of the box |
| iOS | ✅ Native | Works out of the box |
| Windows | ❌ | Use `sqflite_common_ffi` |
| Web | ❌ | Use `drift` with sql.js or `hive` |
| macOS | ❌ | Use `sqflite_common_ffi` |
| Linux | ❌ | Use `sqflite_common_ffi` |

**Alternative:** `drift` (formerly moor) — supports all platforms with appropriate backends.

### path_provider
| Platform | Support | Base Path |
|----------|---------|-----------|
| Android | ✅ | `/data/data/<pkg>/files` |
| iOS | ✅ | `NSDocumentDirectory` |
| Windows | ✅ | `%APPDATA%` |
| Web | ❌ | No file system access |
| macOS | ✅ | `~/Library/Application Support` |
| Linux | ✅ | `~/.local/share` |

**Web workaround:** Use `shared_preferences` for small data, IndexedDB for larger data.

### url_launcher
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ | Intent-based |
| iOS | ✅ | UIApplication.open |
| Windows | ✅ | ShellExecute |
| Web | ✅ | window.open |
| macOS | ✅ | NSWorkspace.open |
| Linux | ✅ | xdg-open |

**Known issue:** `canLaunchUrl` requires Android 11+ query declarations in `AndroidManifest.xml`.

### image_picker
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ | Camera + gallery |
| iOS | ✅ | Camera + gallery |
| Windows | ⚠️ | Limited — file dialog only, no camera |
| Web | ⚠️ | HTML file input, limited camera via getUserMedia |
| macOS | ⚠️ | File dialog only |
| Linux | ⚠️ | File dialog only |

**Alternative for desktop:** `file_picker` package for broader file selection.

### file_picker ⭐ (Pilot Run Finding)
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ | Intent-based file selection |
| iOS | ✅ | UIDocumentPickerViewController |
| Windows | ✅ | Win32 file dialog |
| Web | ✅ | html.FileUploadInputElement |
| macOS | ✅ | NSOpenPanel |
| Linux | ✅ | GTK file chooser |

**Known issue (Web):** `platformFile.path` is `null` on Web. Use `platformFile.bytes` instead.
```dart
// Universal upload pattern:
final file = result.files.single;
final multipart = file.path != null
    ? await MultipartFile.fromFile(file.path!, filename: file.name)
    : MultipartFile.fromBytes(file.bytes!, filename: file.name);
```
**Discovered:** Pilot Run 2026-04-23

### firebase_core / firebase_auth / cloud_firestore
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ | Full support |
| iOS | ✅ | Full support |
| Web | ✅ | JS SDK wrapper |
| Windows | ❌ | No official support |
| macOS | ✅ | Full support |
| Linux | ❌ | No official support |

**Windows/Linux workaround:** Use REST API directly or community packages like `firedart`.

### shared_preferences
| Platform | Support | Backend |
|----------|---------|---------|
| Android | ✅ | SharedPreferences (Android) |
| iOS | ✅ | NSUserDefaults |
| Windows | ✅ | JSON file in AppData |
| Web | ✅ | localStorage |
| macOS | ✅ | NSUserDefaults |
| Linux | ✅ | JSON file in XDG path |

**Note:** Fully cross-platform ✅ — safe to use everywhere.

### local_notifications
| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ | Full support |
| iOS | ✅ | Full support |
| Windows | ⚠️ | Basic support via win32 |
| Web | ⚠️ | Web Notifications API (requires permission) |
| macOS | ✅ | Full support |
| Linux | ✅ | via libnotify |

---

## Windows-Specific Issues

### Window Management
- Flutter windows app starts at 1280x720 by default
- Customize in `windows/runner/main.cpp` or use `window_manager` package
- Minimum window size must be set explicitly
- Taskbar integration requires additional packages

### MSIX Packaging
- Required for Microsoft Store distribution
- Needs signing certificate
- Package: `msix` (pub.dev) for build automation
- Identity name must be unique in the Store

### Visual C++ Redistributable
- Flutter Windows apps require Visual C++ Redistributable
- Must be bundled or documented as prerequisite
- MSIX installer can include it

---

## Web-Specific Issues

### CORS
- **Every** API call from web is subject to CORS
- Backend must send appropriate `Access-Control-Allow-Origin` headers
- Alternatives: use a proxy during development, configure server for production
- `flutter run -d chrome --web-browser-flag="--disable-web-security"` for dev ONLY

### URL Strategy
- Hash strategy (default): `/#/page` — no server config needed
- Path strategy: `/page` — requires server rewrite rules
- Set in `main.dart` or `GoRouter` configuration

### SEO and Initial Load
- Flutter web is SPA — poor SEO by default
- Initial load includes Flutter engine (~2MB with CanvasKit)
- Consider server-side rendering for SEO-critical pages
- Use deferred loading for large features

---

## How to Use This Database

1. **Before implementing:** Check if your feature/package has known issues above
2. **During implementation:** Follow the workarounds documented here
3. **After implementing:** If you discover new issues, ADD THEM to this file
4. **Memory integration:** Platform Guardian stores new findings in memory AND updates this file

> This file grows with every project. The more projects use the framework, the more comprehensive it becomes.
