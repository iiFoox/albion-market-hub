---
id: "ls-2026-0423-pilot-002"
type: "best-practice"
created: "2026-04-23T14:50:00-03:00"
outcome: "positive"
impact_score: 0.8
confidence: 0.9
project_context: "pilot-run"
request_id: "pilot-run-profile-screen"
agents_involved: ["builder", "ui-ux-specialist"]
tags: ["flutter", "dark-mode", "theme", "persistence", "shared-preferences"]
related_memories: ["ls-seed-flutter-002"]
reviewed: true
review_date: "2026-04-23"
---

## Summary
Dark mode toggle: use ValueNotifier + SharedPreferences for instant UI update + persistence.

## Context
Implementing dark mode toggle in user profile. Need: instant visual feedback AND persistence
across app restarts.

## Decision Made
```dart
class ThemeService {
  static final ValueNotifier<ThemeMode> themeMode = 
      ValueNotifier(ThemeMode.system);
  
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode') ?? 'system';
    themeMode.value = ThemeMode.values.firstWhere(
      (m) => m.name == savedMode,
      orElse: () => ThemeMode.system,
    );
  }
  
  static Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;  // instant UI update
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);  // persist
  }
}

// In MaterialApp:
ValueListenableBuilder<ThemeMode>(
  valueListenable: ThemeService.themeMode,
  builder: (context, mode, _) => MaterialApp(
    themeMode: mode,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    // ...
  ),
)
```

## Lessons Learned
- ValueNotifier gives instant UI update without setState or state management overhead
- SharedPreferences persist the preference across restarts
- ThemeMode.system follows the OS dark mode setting (best default)
- Initialize ThemeService in main() before runApp()
- Works on ALL platforms (SharedPreferences is cross-platform)

## Conditions for Reuse
Any Flutter app that needs dark mode toggle with persistence.
