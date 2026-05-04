# 05 — Standard Workflow (STANDARD)

> **Complexity:** STANDARD  
> **When to use:** New features, multi-file changes, CRUD operations, refactoring  
> **Active agents:** Researcher + Planner + Builder + Validator + Documentation + Delivery

---

## How to Trigger

Describe the feature you want:
- "Add user profile editing with avatar upload"
- "Create a settings page with theme switching"
- "Implement search with filtering and pagination"

## What Happens

```
1. Orchestrator classifies as STANDARD
2. Researcher analyzes context, dependencies, existing patterns
3. Planner creates a task decomposition with acceptance criteria
4. Builder implements following the plan
5. UI/UX Specialist reviews (if UI involved)
6. Platform Guardian checks (if multi-platform)
7. Validator runs tests + security check
8. Documentation updates API docs / changelog
9. Delivery commits with conventional message
10. Memory stores learnings and updates checkpoint
```

## Example

**You:** "Add dark mode toggle to the settings page"

**Framework response:**
```
📋 Plan: 4 steps
1. Create ThemeNotifier with dark/light state
2. Add toggle switch to settings_screen.dart
3. Persist preference with SharedPreferences
4. Apply theme to MaterialApp

🔨 Implementation: 3 files modified, 1 created
- lib/providers/theme_notifier.dart [NEW]
- lib/screens/settings_screen.dart [MODIFIED]
- lib/main.dart [MODIFIED]
- pubspec.yaml [MODIFIED] (shared_preferences added)

🎨 UI Review: APPROVED ✅
- Dark tokens verified
- Contrast ratios: 7.2:1 (AAA)
- Toggle follows Material 3 guidelines

✅ Tests: 8/8 passing
📝 Commit: feat(settings): add dark mode toggle with persistence
📦 Version: 1.3.0 (minor — new feature)

💡 Learnings saved:
- "Use ThemeNotifier with ChangeNotifier for theme switching"
- "SharedPreferences is sufficient for simple preference storage"
```

## When STANDARD Escalates to DEEP

Auto-escalation triggers:
- Security flag raised by any agent
- Platform compatibility failure detected
- 3+ phases required in the plan
- Past failure pattern found in memory
