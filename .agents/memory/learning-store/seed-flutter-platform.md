---
id: "ls-seed-flutter-001"
type: "best-practice"
created: "2026-04-23T14:40:00-03:00"
outcome: "positive"
impact_score: 0.95
confidence: 0.95
project_context: "any-flutter-multiplatform"
request_id: "seed"
agents_involved: ["platform-guardian", "builder"]
tags: ["flutter", "web", "cross-platform", "dart:io", "conditional-import"]
related_memories: []
reviewed: true
review_date: "2026-04-23"
---

## Summary
Critical cross-platform Flutter patterns that prevent crashes and build failures.

## Learnings

### L1: dart:io breaks Web builds — ALWAYS use conditional imports
```dart
// ❌ WRONG — crashes on Web
import 'dart:io';
if (Platform.isAndroid) { ... }

// ✅ CORRECT — conditional import
import 'stub_platform.dart'
    if (dart.library.io) 'io_platform.dart'
    if (dart.library.html) 'web_platform.dart';
```
**Impact:** App won't compile for Web if dart:io is imported unconditionally.
**Trigger:** Any code using Platform.isAndroid, Platform.isIOS, File, Directory, HttpClient.

---

### L2: Platform.isAndroid / Platform.isIOS crashes on Web — use kIsWeb first
```dart
// ❌ WRONG — throws on Web
if (Platform.isAndroid) { ... }

// ✅ CORRECT — check Web first
import 'package:flutter/foundation.dart';
if (kIsWeb) {
  // web logic
} else if (Platform.isAndroid) {
  // android logic
}
```
**Impact:** Runtime crash on Web. kIsWeb is compile-time constant, safe everywhere.

---

### L3: sqflite doesn't work on Web or Windows — use drift
```yaml
# ❌ sqflite: Android ✅, iOS ✅, Windows ❌, Web ❌
# ✅ drift:    Android ✅, iOS ✅, Windows ✅ (FFI), Web ✅ (sql.js)
```
**Impact:** App crashes on first SQL query on Web/Windows.
**Alternative:** Also consider Hive (key-value, all platforms) or Isar.

---

### L4: Image.file doesn't work on Web — use conditional rendering
```dart
// ❌ WRONG — File doesn't exist on Web
Image.file(File(path))

// ✅ CORRECT
kIsWeb ? Image.network(url) : Image.file(File(path))
```

---

### L5: cached_network_image on Web needs CORS headers
The package works on Web but images fail to load if the server doesn't send
proper CORS headers (Access-Control-Allow-Origin). This is a server-side fix,
not a Flutter fix.
**Workaround:** Use a CORS proxy or configure the CDN/server.

---

### L6: SharedPreferences on Web uses localStorage — 5-10MB limit
Mobile SharedPreferences have virtually no limit, but Web localStorage is
capped at 5-10MB depending on browser. For larger data, use IndexedDB
(via package like idb_shim or drift with web support).

---

### L7: path_provider paths differ wildly per platform
- Android: /data/data/com.app/files/
- iOS: /Library/Application Support/
- Windows: C:\Users\X\AppData\Roaming\
- Web: NOT SUPPORTED (throws)

Always check platform before using path_provider. On Web, use html.window.localStorage or IndexedDB.

---

### L8: url_launcher works differently on each platform
- Mobile: opens external browser or in-app browser
- Windows: opens default browser via shell
- Web: window.open() — may be blocked by popup blockers

Always handle LaunchMode and provide fallback for popup-blocked scenarios on Web.

## Conditions for Reuse
Any Flutter project targeting more than one platform.
