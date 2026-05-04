# Agent Contract Test Expectations

> Framework Version: 5.6.0
> Purpose: Human-readable summary of expected routing fixtures.

---

The executable fixtures live in `.agents/tests/fixtures/`.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/test-routing.ps1
```

These tests validate expected routing contracts for canonical request types. They are not a substitute for agent reasoning; they prevent obvious drift in complexity, workflow, and agent activation expectations.
