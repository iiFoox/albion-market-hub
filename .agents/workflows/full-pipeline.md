---
description: Full development pipeline — all agents activated for complex tasks
---

# Full Pipeline Workflow

> Use this workflow for: new features, major changes, complex implementations, architecture modifications.

## When to Use

```
User request matches ANY of these?
│
├── New feature with multiple files?         → YES → Full Pipeline
├── Architecture change?                     → YES → Full Pipeline
├── Refactoring across modules?              → YES → Full Pipeline
├── New technology integration?              → YES → Full Pipeline
├── Security-sensitive change?               → YES → Full Pipeline (DEEP)
├── Production deployment?                   → YES → Full Pipeline (CRITICAL)
│
└── ALL NO → Consider quick-fix, ui-workflow, or research-only instead
```

### Examples
- "Implemente o sistema de autenticação JWT completo"
- "Refatore o módulo de pagamentos para usar Clean Architecture"
- "Adicione suporte a multi-tenancy"
- "Migre o banco de SQLite para PostgreSQL"

## Pipeline Steps

### 1. Complexity Classification (Adaptive Complexity Protocol)
The Orchestrator classifies the request into LITE / STANDARD / DEEP / CRITICAL.
- Analyze keywords, scope, and risk
- Check if industry profile is active (escalates minimum level)
- Check if Flutter multi-platform profile is active
- User can override: "use DEEP pipeline for this"

### 2. Universal Triage Phase
ALL 10 agents perform a lightweight relevance scan (~100 words each).
- Each agent responds: CRITICAL / RELEVANT / OPTIONAL / NOT_NEEDED
- Orchestrator assembles pipeline based on triage + complexity minimums
- If an agent marks CRITICAL and is excluded → justification required
- UI/UX Specialist and Platform Guardian participate in triage like all other agents

### 3. Research Phase (Researcher)
Deep context analysis and technology intelligence.
- Map system context and affected areas
- Identify dependencies and risks
- Research relevant technologies and patterns
- Consult memory for prior decisions
- **Output:** Context map, risk assessment, technology evaluation

### 4. Planning Phase (Planner)
Transform research into executable plan.
- Decompose task into atomic steps
- Define execution strategy with trade-off analysis
- Set acceptance criteria for each deliverable
- Define scope boundaries explicitly
- **Output:** Task plan, acceptance criteria, validation requirements

### 5. Implementation Phase (Builder)
Execute the plan with production-quality code.
- Implement changes following the plan
- Follow design tokens and UI standards (if UI work)
- Manage version control operations
- Follow project conventions and patterns
- **Output:** Modified files, change summary, pending items

### 5.5 UI Review Phase (UI/UX Specialist) — if UI work involved
Design quality gate after implementation.
- Verify design token compliance
- Check responsive/adaptive behavior
- Audit accessibility
- Verify interactive state coverage
- Check visual polish and consistency
- **Output:** Design review report with verdict
- **If NEEDS_CHANGES:** Return to Builder with specific fix instructions

### 5.7 Platform Check Phase (Platform Guardian) — if multi-platform
Cross-platform compatibility gate after UI review.
- Verify package compatibility on all target platforms
- Check for platform-specific API usage
- Verify conditional imports
- Check build configurations
- **Output:** Platform compatibility report with per-platform verdict
- **If FAIL:** Return to Builder with platform-specific fixes

### 6. Validation Phase (Validator)
Independent quality verification.
- Generate and run tests
- Perform security audit
- Check regressions
- Validate against acceptance criteria
- **Output:** Validation report, pass/fail decision
- **If FAIL:** Return to Builder with specific fix instructions (max 3 loops)

### 7. Documentation Phase (Documentation)
Update all affected documentation.
- Generate/update API docs, changelogs, architecture docs
- Review inline code documentation
- Create/update diagrams
- **Output:** Updated documentation, changelog entries

### 8. Oversight Phase (Project Manager)
Telemetry, metrics, and evolution tracking.
- Log complete pipeline telemetry
- Calculate performance metrics
- Assess evolution points
- Update risk register and technical debt tracker
- **Output:** Telemetry log, evolution assessment

### 9. Delivery Phase (Delivery Agent)
Persist completed work.
- Assess if work merits a commit (Commit Gate Protocol)
- Generate commit message (Conventional Commits format)
- Determine version bump (patch/minor/major)
- Update CHANGELOG.md
- Push to remote repository
- **On first run:** Execute Repository Bootstrap Protocol
- **Output:** Commit hash, version number, sync confirmation

### 10. Memory Update
All agents contribute to memory.
- Store new learnings
- Update project context
- Score referenced memory entries
- Build knowledge graph connections
- UI/UX Specialist records design decisions
- Platform Guardian records compatibility findings

### 11. Result Delivery
The Orchestrator presents results to the user in pt-BR.
- Structured summary of what was done
- Design review verdict (if UI work)
- Platform compatibility status (if multi-platform)
- Commit and version info
- Any issues or concerns
- Recommendations for next steps
