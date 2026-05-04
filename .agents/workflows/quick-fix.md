---
description: Quick fix workflow — fast-track for simple changes
---

# Quick Fix Workflow

> Use this workflow for: simple bug fixes, minor tweaks, small config changes, formatting fixes.
> **Complexity Level:** LITE (Adaptive Complexity Protocol)

## When to Use

```
User request matches ALL of these?
│
├── Change is well-understood?               → YES ✓
├── Only 1-2 files need modification?        → YES ✓
├── No architecture changes?                 → YES ✓
├── No new technologies introduced?          → YES ✓
├── Risk is low?                             → YES ✓
│
└── ALL YES → Quick Fix
    ANY NO  → Use full-pipeline instead
```

### Examples of Quick Fixes
- "Corrija o texto do botão de Salvar para Confirmar"
- "O padding do card está 16, mude para 12"
- "O endpoint /api/users retorna 500 quando email é null"
- "Atualize a versão do pacote X para 2.0.1"
- "Adicione o campo createdAt no model User"

### NOT Quick Fixes (use full-pipeline)
- "Adicione autenticação JWT ao sistema" → feature
- "Refatore o módulo de pagamentos" → refactor
- "Mude de REST para GraphQL" → architecture
- "Crie uma tela de dashboard" → new feature

## Pipeline Steps

### 1. Request Reception (Orchestrator)
Quick analysis confirming this is truly a quick fix.
- Classify as LITE complexity
- If complexity is higher than expected → **auto-escalate** to full pipeline

### 2. Abbreviated Triage
All 10 agents evaluate with expectation that most will mark NOT_NEEDED.
- Expected active: **Builder** + **Validator** + Delivery
- UI/UX Specialist: OPTIONAL (only for visual fixes)
- Platform Guardian: NOT_NEEDED (unless platform-specific bug)
- Researcher/Planner: typically SKIP

### 3. Implementation (Builder)
Implement the fix directly.
- Follow existing patterns and conventions
- Keep changes minimal and focused
- **Output:** Modified files, change summary

### 3.5. Quick UI Check (UI/UX Specialist) — only for visual fixes
- Quick token compliance check
- Verify visual consistency not broken
- **Output:** Quick approval or fix suggestion

### 4. Validation (Validator)
Quick but thorough verification.
- Run existing tests
- Check for regressions
- **Output:** Pass/fail decision

### 5. Delivery (Delivery Agent)
Auto-commit and sync.
- Generate commit message: `fix(<scope>): <description>`
- Version bump: **patch**
- Push to remote
- **Output:** Commit hash, sync confirmation

### 6. Memory Update
- Write Quick Learning if something unexpected happened
- Update session checkpoint

---

## Example

**User:** "O botão de login não responde quando clicado rapidamente duas vezes"

**Execution:**
```
1. Orchestrator: LITE complexity ✓
2. Triage: Builder + Validator active
3. Builder: Added debounce to login button in login_screen.dart:45
4. Validator: Existing tests pass, no regression
5. Delivery: fix(auth): add debounce to login button tap (v1.2.4)
6. Memory: Quick Learning — "Always debounce user actions on auth screens"
```

**Total time:** ~2 minutes (vs ~10 minutes for full pipeline)
