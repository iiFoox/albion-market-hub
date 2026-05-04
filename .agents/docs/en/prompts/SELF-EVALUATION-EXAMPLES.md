# Self-Evaluation Examples

> **Purpose:** Shows how each agent decides whether to participate  
> **Format:** Each agent's internal reasoning before joining the pipeline

---

## How Self-Evaluation Works

Before the pipeline runs, each agent asks itself:
1. **Is my expertise relevant?** (YES/NO)
2. **At what depth?** (deep / standard / lite / skip)
3. **What specifically would I do?** (concrete actions)
4. **Confidence in my assessment?** (0.0-1.0)

---

## Example 1: "Create a settings screen with theme toggle and notification preferences"

### UI/UX Specialist Self-Evaluation
```
PARTICIPATE: YES
LEVEL: standard
JUSTIFICATION:
- New screen = layout guidance needed
- Theme toggle = design tokens + dark mode verification
- Notification preferences = toggle/switch UI patterns
- Must verify: responsive breakpoints, accessibility, state coverage
CONFIDENCE: 0.95
ACTIONS: Pre-build guidance → Post-build design review
```

### Platform Guardian Self-Evaluation
```
PARTICIPATE: YES
LEVEL: lite
JUSTIFICATION:
- Theme toggle: ThemeMode works cross-platform ✅
- Notification preferences: notification_permissions package differs by platform
- Android: exact alarm permission needed for scheduled notifications
- iOS: provisional vs explicit authorization
- Web: Push API requires service worker
CONFIDENCE: 0.85
ACTIONS: Quick platform compatibility check on notification APIs
```

### Researcher Self-Evaluation
```
PARTICIPATE: NO (NOT_NEEDED)
JUSTIFICATION:
- Settings screen is well-understood pattern
- Theme toggle has established patterns (ThemeNotifier)
- No unknown technology involved
- Memory has past learnings about SharedPreferences
CONFIDENCE: 0.90
```

---

## Example 2: "Fix the alignment bug on the login button"

### Builder Self-Evaluation
```
PARTICIPATE: YES
LEVEL: lite
JUSTIFICATION: Simple CSS/layout fix, 1 file change
CONFIDENCE: 0.95
```

### UI/UX Specialist Self-Evaluation
```
PARTICIPATE: OPTIONAL
LEVEL: lite
JUSTIFICATION: Alignment fix may affect other elements — quick visual check recommended
CONFIDENCE: 0.70
```

### Researcher Self-Evaluation
```
PARTICIPATE: NO
JUSTIFICATION: Known issue type, no research needed
CONFIDENCE: 0.99
```

### Planner Self-Evaluation
```
PARTICIPATE: NO
JUSTIFICATION: Single-step fix, no planning required
CONFIDENCE: 0.99
```

---

## Example 3: "Implement JWT authentication with refresh tokens"

### Researcher Self-Evaluation
```
PARTICIPATE: YES
LEVEL: deep
JUSTIFICATION:
- Security-critical feature
- Need to evaluate: JWT library options, token storage strategies
- Refresh token rotation: security implications
- Memory: check for past auth decisions
CONFIDENCE: 0.95
```

### Validator Self-Evaluation
```
PARTICIPATE: YES
LEVEL: deep
JUSTIFICATION:
- Security audit required
- Token expiration edge cases
- Refresh flow race conditions
- OWASP compliance check
CONFIDENCE: 0.95
```

### UI/UX Specialist Self-Evaluation
```
PARTICIPATE: OPTIONAL
LEVEL: lite
JUSTIFICATION:
- Auth is mostly backend logic
- BUT: login screen UX (loading state, error messages, redirect flow)
- Quick check on auth-related UI elements
CONFIDENCE: 0.60
```

---

## Summary: Self-Evaluation Patterns

| Scenario | Most Active | Usually Skip |
|----------|-------------|-------------|
| **Bug fix** | Builder, Validator | Researcher, Planner, Docs |
| **New screen** | Builder, UI/UX, Validator | — |
| **Architecture** | Researcher, Planner, Builder, Validator | UI/UX |
| **Security** | Researcher, Builder, Validator | UI/UX, Docs |
| **Performance** | Researcher, Builder, Validator | UI/UX, Docs |
| **Docs only** | Documentation | All others |
