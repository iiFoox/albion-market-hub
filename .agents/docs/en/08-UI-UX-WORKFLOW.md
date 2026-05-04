# 08 — UI/UX Workflow

> **When to use:** Visual changes, new screens, design system work, components, animations  
> **Key agents:** UI/UX Specialist + Builder + Platform Guardian

---

## What Makes This Different

The UI Workflow adds a **design review loop** around the Builder:

```
UI/UX Specialist → Guidance (before build)
Builder → Implementation
UI/UX Specialist → Review (after build)
Platform Guardian → Cross-platform check
```

## What the UI/UX Specialist Checks

| Category | Checks |
|----------|--------|
| **Design Tokens** | No hard-coded colors, sizes, or fonts |
| **Responsive** | Works at mobile, tablet, and desktop breakpoints |
| **Accessibility** | Contrast 4.5:1+, touch targets 48dp+, semantic labels |
| **States** | Hover, focus, pressed, disabled, loading, error, empty |
| **Dark Mode** | Light/dark parity verified |
| **Platform** | Material (Android), Fluent (Windows), Cupertino (iOS) |

## Example

**You:** "Create a product detail screen with image gallery"

**Output includes:**
```
🎨 UI/UX Review: APPROVED ✅

Design Tokens:   ✅ All colors from ColorScheme
Typography:      ✅ TextTheme hierarchy correct
Spacing:         ✅ 8px grid consistent
Responsive:      ✅ Mobile ✅ Tablet ✅ Desktop
Accessibility:   ✅ Contrast 6.8:1, touch targets 48dp
States:          ✅ Loading skeleton, error with retry, empty state
Dark Mode:       ✅ Parity verified
```

## When Review Fails

If the UI/UX Specialist returns `NEEDS_CHANGES`, it sends specific fixes back to the Builder:
```
❌ NEEDS_CHANGES:
1. Line 45: Hard-coded Color(0xFF333333) → use Theme.of(context).colorScheme.onSurface
2. Line 78: Touch target is 36dp → increase to 48dp minimum
3. Missing: No empty state widget when product list is empty
```

The Builder fixes and resubmits. Maximum 3 review loops.
