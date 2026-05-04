---
id: "kg-seed-flutter-001"
type: "technology-pattern"
created: "2026-04-23T14:40:00-03:00"
project_context: "any-flutter-multiplatform"
tags: ["flutter", "packages", "platform-compatibility"]
---

## Flutter Package Compatibility — Quick Reference

### ❌ Packages that DON'T work cross-platform
| Package | Android | iOS | Windows | Web | Alternative |
|---------|---------|-----|---------|-----|-------------|
| sqflite | ✅ | ✅ | ❌ | ❌ | drift, Hive, Isar |
| path_provider | ✅ | ✅ | ✅ | ❌ | conditional + localStorage |
| image_picker | ✅ | ✅ | ❌ | ⚠️ | file_picker (all platforms) |
| share_plus | ✅ | ✅ | ❌ | ⚠️ | Clipboard + conditional |
| local_auth | ✅ | ✅ | ❌ | ❌ | PIN fallback on desktop/web |
| geolocator | ✅ | ✅ | ❌ | ✅ | conditional for Windows |
| camera | ✅ | ✅ | ❌ | ⚠️ | html.MediaDevices on Web |
| video_player | ✅ | ✅ | ❌ | ✅ | media_kit for Windows |

### ✅ Packages that work everywhere
| Package | Notes |
|---------|-------|
| dio | HTTP client — all platforms |
| flutter_bloc / riverpod | State management — pure Dart |
| go_router | Navigation — all platforms |
| intl | Localization — needs initializeDateFormatting() on Web |
| flutter_svg | SVG rendering — all platforms |
| json_serializable | JSON — pure Dart |
| freezed | Immutable models — pure Dart |
| drift | SQL — all platforms (FFI + sql.js) |
| hive / hive_flutter | Key-value — all platforms |
| cached_network_image | Image cache — Web needs CORS |
| provider / riverpod | DI — pure Dart |
| url_launcher | URL — all platforms (popup blocker on Web) |
| shared_preferences | Key-value — Web uses localStorage (5MB limit) |

### ⚠️ Patterns that need conditional imports
| Pattern | Mobile | Web |
|---------|--------|-----|
| File I/O | dart:io File | html.Blob / IndexedDB |
| HTTP | HttpClient | html.HttpRequest or dio |
| Platform check | Platform.isX | kIsWeb |
| Local storage | sqflite/drift | localStorage / IndexedDB |
| Camera | camera package | html.MediaDevices |
| Download file | saveTo path | html.AnchorElement.click() |

## Usage
When Builder or Platform Guardian encounter a new package, check this list first.
When adding to project, verify platform support before implementation.
