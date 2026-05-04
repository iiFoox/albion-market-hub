# Compatibility Check Prompt — Platform Guardian (v4.0.0)

> **Version:** 4.0.0
> **Prerequisite:** Load `system-prompt.md` first

You are performing a **cross-platform compatibility check** on the Builder's implementation.

## Check Process

### Phase 1: Package Compatibility Scan
```
FOR EACH new/updated package in pubspec.yaml:
  1. Check platform support on pub.dev
  2. Verify implementation exists (not just declaration) for:
     - Android ✅/❌
     - Windows ✅/❌
     - Web ✅/❌
     - iOS ✅/❌
  3. Check if federated plugin (has platform sub-packages)
  4. Check known issues for this package + version
  5. Flag if ANY target platform is unsupported
  6. Suggest alternative if flagged
```

### Phase 2: Platform API Usage Detection
```
SCAN code for:
→ import 'dart:io'          → FAILS on Web
→ import 'dart:html'        → FAILS on mobile/desktop
→ import 'dart:ffi'         → FAILS on Web
→ Platform.isAndroid         → Not available on Web (use kIsWeb first)
→ Platform.isWindows         → Not available on Web
→ Process.run()              → Not available on Web
→ File(), Directory()        → Not available on Web
→ HttpClient()              → Not available on Web (use http package)
→ Socket(), ServerSocket()   → Not available on Web
→ stdin, stdout              → Not available on Web/mobile

FOR EACH detection:
  → Flag the file and line
  → Determine which platforms break
  → Recommend conditional import pattern
```

### Phase 3: Conditional Import Verification
```
FOR EACH platform-specific code file:
  → Is it properly isolated in a platform-specific file?
  → Does the import use conditional syntax?
  → Is there an interface/abstract class that all platforms implement?
  → Is there a stub for unsupported platforms?

PATTERN CHECK:
  lib/src/[feature]/
  ├── [feature]_interface.dart     ✅ Abstract contract
  ├── [feature]_mobile.dart        ✅ Mobile implementation
  ├── [feature]_desktop.dart       ✅ Desktop implementation
  ├── [feature]_web.dart           ✅ Web implementation
  └── [feature]_stub.dart          ✅ Fallback stub
```

### Phase 4: Build Configuration Check
```
ANDROID:
  → android/app/build.gradle: minSdkVersion compatible with all packages?
  → android/app/build.gradle: targetSdkVersion current?
  → AndroidManifest.xml: all required permissions declared?
  → proguard-rules.pro: rules for packages that need them?

WINDOWS:
  → windows/CMakeLists.txt: all plugin dependencies listed?
  → windows/runner/main.cpp: window configuration correct?
  → MSIX configuration present if targeting Store?

WEB:
  → web/index.html: CanvasKit/HTML/Wasm renderer configured?
  → web/index.html: base href set correctly?
  → CORS proxy needed for API calls?
  → Service worker configured for PWA?

iOS:
  → ios/Podfile: platform version compatible?
  → ios/Runner/Info.plist: permissions descriptions present?
  → ios/Runner/*.entitlements: required entitlements?
```

### Phase 5: Known Issues Cross-Reference
```
FOR EACH package + platform combination:
  → Check known-issues.md database
  → Check if current Flutter version has relevant issues
  → Check if workarounds are available
  → Flag if issue is blocking or workable
```

## Output Format

```markdown
## Platform Compatibility Report — [Feature Name]

### New/Updated Packages
| Package | Version | Android | Windows | Web | iOS | Action |
|---------|---------|---------|---------|-----|-----|--------|
| [name] | [ver] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | [action needed] |

### Platform API Issues
| File:Line | API Used | Breaks On | Fix |
|-----------|----------|-----------|-----|
| [file:line] | [api] | [platforms] | [fix description] |

### Conditional Import Status
| Feature | Interface | Mobile | Desktop | Web | Stub |
|---------|-----------|--------|---------|-----|------|
| [feature] | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ | ✅/❌ |

### Build Config Issues
| Platform | Issue | Fix |
|----------|-------|-----|
| [platform] | [issue] | [fix] |

### Known Issues Matched
| Issue | Package | Platforms | Workaround | Severity |
|-------|---------|-----------|------------|----------|
| [desc] | [pkg] | [platforms] | [fix] | [high/med/low] |

### Per-Platform Verdict
| Platform | Verdict | Blocking Issues | Warnings |
|----------|---------|-----------------|----------|
| Android | PASS/WARN/FAIL | [count] | [count] |
| Windows | PASS/WARN/FAIL | [count] | [count] |
| Web | PASS/WARN/FAIL | [count] | [count] |
| iOS | PASS/WARN/FAIL | [count] | [count] |

### Overall: PASS / PASS_WITH_WARNINGS / FAIL
```

## Few-Shot Examples

### Example 1: Adding image_picker package

```markdown
## Platform Compatibility Report — Image Upload Feature

### New/Updated Packages
| Package | Version | Android | Windows | Web | iOS | Action |
|---------|---------|---------|---------|-----|-----|--------|
| image_picker | ^1.0.7 | ✅ | ❌ limited | ✅ web API | ✅ | Use image_picker_windows or file_picker as fallback |

### Platform API Issues
| File:Line | API Used | Breaks On | Fix |
|-----------|----------|-----------|-----|
| image_service.dart:12 | File(path) | Web | Use XFile from image_picker instead of dart:io File |

### Per-Platform Verdict
| Platform | Verdict | Blocking Issues | Warnings |
|----------|---------|-----------------|----------|
| Android | PASS | 0 | 0 |
| Windows | PASS_WITH_WARNINGS | 0 | 1 (limited picker UI) |
| Web | PASS_WITH_WARNINGS | 0 | 1 (File → XFile) |
| iOS | PASS | 0 | 0 |

### Overall: PASS_WITH_WARNINGS
Windows image picker has limited UI. Web needs XFile instead of File. Both workable.
```
