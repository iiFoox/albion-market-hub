# 04 — Basic Workflow (LITE)

> **Complexity:** LITE  
> **When to use:** Bug fixes, typos, small config changes, minor tweaks  
> **Active agents:** Builder + Validator + Delivery

---

## How to Trigger

Just describe the problem naturally:
- "Fix the save button — it's not responding on double click"
- "Change the padding from 16 to 12 on the profile card"
- "The /api/users endpoint returns 500 when email is null"

The framework auto-detects this is LITE and uses the Quick Fix workflow.

## What Happens

```
1. Orchestrator classifies as LITE
2. Builder implements the fix (1-2 files)
3. Validator runs tests, checks regression
4. Delivery commits: fix(<scope>): <description>
5. Memory saves a Quick Learning (if something unexpected happened)
```

## Example

**You:** "The login button freezes when tapped twice quickly"

**Framework response:**
```
✅ Fix applied

File: lib/screens/login_screen.dart:45
Change: Added 300ms debounce to login button onPressed

Tests: 12/12 passing ✅
Commit: fix(auth): add debounce to login button tap
Version: 1.2.4 (patch)

💡 Learning saved: "Always debounce user actions on auth-critical screens"
```

## When LITE Auto-Escalates to STANDARD

The framework upgrades automatically if:
- The fix requires 3+ files
- A security concern is detected
- The change affects multiple modules
- An agent flags something during triage
