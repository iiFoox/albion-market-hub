---
id: "ls-seed-flutter-002"
type: "best-practice"
created: "2026-04-23T14:40:00-03:00"
outcome: "positive"
impact_score: 0.9
confidence: 0.9
project_context: "any-flutter-project"
request_id: "seed"
agents_involved: ["ui-ux-specialist", "builder"]
tags: ["flutter", "ui", "design-tokens", "responsive", "accessibility", "dark-mode"]
related_memories: []
reviewed: true
review_date: "2026-04-23"
---

## Summary
UI/UX best practices for Flutter that prevent visual bugs, inconsistencies, and accessibility issues.

## Learnings

### L9: Never hardcode colors — ALWAYS use ColorScheme
```dart
// ❌ WRONG — breaks dark mode, inconsistent, hard to maintain
Container(color: Color(0xFF1A1A2E))
Text('Hello', style: TextStyle(color: Colors.white))

// ✅ CORRECT — adapts to theme, dark mode, and design changes
Container(color: Theme.of(context).colorScheme.surface)
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
```
**Impact:** Every hardcoded color is a dark mode bug waiting to happen.

---

### L10: Never hardcode TextStyle — ALWAYS use TextTheme
```dart
// ❌ WRONG
TextStyle(fontSize: 28, fontWeight: FontWeight.bold)

// ✅ CORRECT
Theme.of(context).textTheme.headlineMedium
```
**Impact:** Typography becomes inconsistent across the app. Impossible to change globally.

---

### L11: Use 8px spacing grid — never arbitrary values
```dart
// ❌ WRONG — off-grid, inconsistent
SizedBox(height: 13) // 13 is not on 8px grid
Padding(padding: EdgeInsets.all(7))

// ✅ CORRECT — on 8px grid
SizedBox(height: 16) // 2 × 8
Padding(padding: EdgeInsets.all(8)) // 1 × 8

// ✅ BEST — use named constants
SizedBox(height: AppSpacing.md) // 16
```
**Grid:** 4, 8, 12, 16, 24, 32, 48, 64

---

### L12: Widgets > 100 lines → decompose into sub-widgets
Large widgets cause:
1. Unnecessary rebuilds (parent change → full subtree rebuild)
2. Hard to test individual parts
3. Hard to reuse sections

**Rule:** If a widget has > 100 lines or > 3 logical sections, split it.
**Example:** ProductCard → ProductCardImage + ProductCardInfo + ProductCardActions

---

### L13: Always handle ALL states: loading, error, empty, data
```dart
// ❌ WRONG — only handles data
Widget build(context) {
  return ListView(children: items.map((i) => Card(child: Text(i))).toList());
}

// ✅ CORRECT — handles all states
Widget build(context) {
  if (isLoading) return const LoadingIndicator();
  if (error != null) return ErrorView(error: error, onRetry: retry);
  if (items.isEmpty) return const EmptyView(message: 'Nenhum item');
  return ListView(children: items.map((i) => Card(child: Text(i))).toList());
}
```
**Impact:** Without empty/error states, users see blank screens or confusing behavior.

---

### L14: Always add Semantics to icon-only buttons
```dart
// ❌ WRONG — screen reader says nothing useful
IconButton(icon: Icon(Icons.delete), onPressed: onDelete)

// ✅ CORRECT
IconButton(
  icon: Icon(Icons.delete),
  onPressed: onDelete,
  tooltip: 'Delete item', // also serves as Semantics label
)
// OR
Semantics(
  label: 'Delete item',
  child: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
)
```

---

### L15: Dark mode testing — always verify BOTH themes
Never ship dark mode without testing EVERY screen in both light AND dark.
Common dark mode bugs:
- White text on white background (forgot surface color)
- Icons invisible on dark surface
- Hard-coded shadow colors (black shadow on dark = invisible)
- Images with white backgrounds (need rounded corners or dark border)
- Status bar text color not adapting

---

### L16: Responsive layouts — use LayoutBuilder, not MediaQuery in widgets
```dart
// ⚠️ AVOID in widgets — triggers rebuild on ANY media change (keyboard, etc)
final width = MediaQuery.of(context).size.width;

// ✅ PREFER — only rebuilds when THIS widget's constraints change
LayoutBuilder(builder: (context, constraints) {
  if (constraints.maxWidth > 900) return DesktopLayout();
  if (constraints.maxWidth > 600) return TabletLayout();
  return MobileLayout();
})
```

---

### L17: Form validation — show errors after first submit, not on type
```dart
// ❌ WRONG — user sees error before finishing typing
autovalidateMode: AutovalidateMode.always

// ✅ CORRECT — validate only after user tries to submit
autovalidateMode: AutovalidateMode.onUserInteraction
// AND only enable after first submit attempt:
autovalidateMode: _submitted 
    ? AutovalidateMode.onUserInteraction 
    : AutovalidateMode.disabled
```

## Conditions for Reuse
Any Flutter project with UI components.
