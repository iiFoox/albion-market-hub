---
description: UI/UX workflow — optimized pipeline for visual changes and UI work
---

# UI Workflow

> Use this workflow for: UI changes, layout adjustments, new screens, design system work, component creation, visual polish.
> **Complexity Level:** STANDARD (can escalate to DEEP for design system creation)

## When to Use

```
User request involves visual/UI elements?
│
├── New screen or layout?                    → YES → UI Workflow
├── Design tokens or theme changes?          → YES → UI Workflow
├── Component creation or modification?      → YES → UI Workflow
├── Responsive/adaptive behavior?            → YES → UI Workflow
├── Animation or visual polish?              → YES → UI Workflow
├── Accessibility improvements?              → YES → UI Workflow
│
├── Also involves architecture/state?        → YES → Full Pipeline (not UI-only)
└── ALL NO → use quick-fix, full-pipeline, or research-only
```

### Examples
- "Crie a tela de perfil do usuário"
- "Ajuste o espaçamento e cores do card de produto"
- "Implemente dark mode no app"
- "Melhore a responsividade da tela de dashboard"

### NOT UI Workflow
- "Implemente o endpoint de usuários" → full-pipeline (backend)
- "Corrija o texto do botão" → quick-fix (too small)

## Pipeline Steps

### 1. Request Classification (Orchestrator)
Quick classification confirming this is UI-focused work.
- Classify complexity (usually STANDARD for UI work)
- If involves architecture or complex state → upgrade to full pipeline

### 2. Abbreviated Triage
All agents evaluate with expectation that UI/UX Specialist and Builder are primary.
- Expected active: UI/UX Specialist + Builder + Platform Guardian + Validator + Delivery
- Researcher: only if new UI technology/pattern research needed
- Planner: only if multi-screen UI architecture decision needed

### 3. UI Guidance (UI/UX Specialist — Pre-Build)
Before Builder implements, UI/UX Specialist provides:
- Design token references to use
- Responsive breakpoints to implement
- Accessibility requirements for this specific UI
- Component patterns to follow or create
- Platform-specific adaptations needed
- **Output:** UI implementation guide for Builder

### 4. Implementation (Builder)
Implement the UI following the UI/UX Specialist's guidance.
- Follow design tokens — no hard-coded values
- Implement responsive behaviors
- Add Semantics labels
- Handle all states (loading, error, empty, default)
- **Output:** Modified files, change summary

### 5. Design Review (UI/UX Specialist — Post-Build)
Review Builder's implementation for visual quality.
- Verify design token compliance
- Check responsive behavior
- Audit accessibility
- Verify state coverage
- Check visual polish
- **Output:** Design review report with verdict

### 6. Platform Check (Platform Guardian)
If multi-platform profile is active:
- Verify UI works on all target platforms
- Check adaptive widgets
- Verify platform conventions (Material/Fluent/Cupertino)
- **Output:** Platform compatibility report (UI-focused)

### 7. Validation (Validator)
Quick but thorough verification.
- Run widget tests
- Check for regressions
- Golden test comparison if applicable
- **Output:** Pass/fail decision

### 8. Delivery (Delivery Agent)
Commit and sync.
- Generate commit message
- Version bump: patch (or minor for new screens)
- Push to remote
- **Output:** Commit hash, sync confirmation

### 9. Memory Update
All active agents contribute:
- UI/UX Specialist: design decisions, component patterns, token usage
- Platform Guardian: platform-specific UI findings
- Builder: implementation patterns
- PM: pipeline telemetry

### 10. Result Delivery (Orchestrator)
Present results to user in pt-BR.
- Summary of visual changes
- Design review verdict
- Platform compatibility status
- Commit info
