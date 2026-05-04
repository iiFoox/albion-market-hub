# Auto-Escalation Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-012  
> **Type:** Dynamic Context Management  
> **Priority:** MANDATORY — executes DURING triage and pipeline execution  
> **Status:** Active (v4.0.1+)  
> **Depends on:** Smart Loading Protocol (011), Adaptive Complexity Protocol (006)

---

## Purpose

Allow the framework to **start lean and scale up automatically**. The user always starts with the lowest level they think is needed (even always LITE). During triage or execution, if the framework detects the task requires deeper analysis, it **escalates automatically** — loading only the DELTA (additional files), not reloading everything.

**Problem solved:** Users shouldn't need to guess the right complexity level. Start fast, scale when needed — zero waste.

---

## How It Works

```
USER REQUEST → Start at Level X (user-specified or auto-detected)
                    │
                    ▼
          ┌─────────────────────┐
          │  INITIAL LOADING    │  Load files for Level X only
          │  (Smart Loading)    │  (e.g., ~8 files for LITE)
          └────────┬────────────┘
                   │
                   ▼
          ┌─────────────────────┐
          │  TRIAGE PHASE       │  All agents do quick self-eval
          │  (100 words each)   │
          └────────┬────────────┘
                   │
                   ▼
          ┌─────────────────────┐
          │  ESCALATION CHECK   │  ← THIS IS THE NEW STEP
          │                     │
          │  Trigger detected?  │
          │  YES → Delta Load   │
          │  NO  → Continue     │
          └────────┬────────────┘
                   │
            ┌──────┴──────┐
            │             │
      (no escalation) (escalation)
            │             │
            ▼             ▼
     Continue at     ┌──────────────┐
     Level X         │ DELTA LOAD   │  Load ONLY the extra files
                     │ Level X → Y  │  (Y files - X files = delta)
                     └──────┬───────┘
                            │
                            ▼
                     Continue at Level Y
```

---

## Escalation Triggers

The framework auto-escalates when ANY of these conditions are detected:

### LITE → STANDARD Triggers
```
TRIGGER 1: Triage shows ≥ 3 agents as RELEVANT or CRITICAL
  Reasoning: LITE expects 2-3 agents. If triage shows more need, escalate.
  Example: "Fix login bug" → but triage reveals auth architecture issue
  
TRIGGER 2: Request involves creating NEW files (not just modifying)
  Reasoning: New files = new feature, needs planning.
  Example: "Fix the user display" → requires new UserViewModel file
  
TRIGGER 3: Builder reports needing context from Researcher
  Reasoning: Builder can't implement without understanding dependencies.
  Example: "Fix the API call" → but which API? What format? Need research.
  
TRIGGER 4: ≥ 2 files need modification across different modules
  Reasoning: Cross-module changes need coordination.
  Example: "Fix the cart total" → touches model, service, and UI
```

### STANDARD → DEEP Triggers
```
TRIGGER 5: Validator detects security vulnerability in scope
  Reasoning: Security issues need deep security KB + audit prompts.
  Example: Standard CRUD, but Validator sees SQL injection risk.
  
TRIGGER 6: Platform Guardian reports FAIL on any platform
  Reasoning: Platform failure needs deep investigation + known-issues DB.
  Example: Standard feature, but uses dart:io which breaks on Web.
  
TRIGGER 7: Planner identifies ≥ 3 phases needed
  Reasoning: Multi-phase work needs deeper planning + rollback strategy.
  Example: "Add favorites" → needs model, API, UI, sync = 4 phases.
  
TRIGGER 8: Memory returns NEGATIVE learning for similar past approach
  Reasoning: Past failure means we need deeper analysis to avoid repetition.
  Example: Learning store says "Last time we used X, it caused Y problem"
  
TRIGGER 9: Conflict detected between agents during execution
  Reasoning: Conflicts need conflict resolution protocol + deep reasoning.
  Example: Builder and UI/UX disagree on component structure.
```

### DEEP → CRITICAL Triggers
```
TRIGGER 10: Request touches payment, financial, or health data
  Reasoning: Regulatory compliance is mandatory, never negotiable.
  Example: Any mention of payment processing, even in "standard" scope.
  
TRIGGER 11: Validator's security scan finds HIGH severity issue
  Reasoning: High security issues require full security KB + OWASP audit.
  Example: Deep architecture work reveals auth bypass possibility.
  
TRIGGER 12: Production deployment is in scope
  Reasoning: Live data = maximum caution.
  Example: Migration plan that will run against production database.
```

---

## Delta Loading — What Gets Loaded

The key efficiency: only load the DIFFERENCE, never reload what's already loaded.

### LITE → STANDARD (Delta: ~14-18 extra files)
```
LOAD ADDITIONALLY:
├── agents/researcher/prompts/system-prompt.md
├── agents/planner/prompts/system-prompt.md
├── agents/documentation/prompts/system-prompt.md
├── agents/project-manager/prompts/system-prompt.md
├── config/triage-rules.yaml
├── config/maturity-profiles.yaml
├── profiles/flutter-multiplatform/architecture.md (if Flutter)
├── profiles/flutter-multiplatform/ui-standards.md (if UI work)
├── memory/learning-store/[latest entries]
└── memory/knowledge-graph/[latest entries]

Already loaded (from LITE, keep):
├── config/framework.yaml ✅
├── config/complexity-routing.yaml ✅
├── agents/builder/prompts/system-prompt.md ✅
├── agents/validator/prompts/system-prompt.md ✅
├── agents/delivery/prompts/system-prompt.md ✅
└── protocols/commit-gate-protocol.md ✅
```

### STANDARD → DEEP (Delta: ~25-30 extra files)
```
LOAD ADDITIONALLY:
├── agents/*/prompts/deep-reasoning.md (all agents)
├── agents/ui-ux-specialist/prompts/design-review.md
├── agents/platform-guardian/prompts/compatibility-check.md
├── agents/platform-guardian/knowledge/known-issues.md
├── agents/validator/prompts/security-audit.md
├── agents/builder/prompts/code-review.md
├── agents/builder/prompts/refactoring.md
├── agents/planner/prompts/architecture-decision.md
├── profiles/flutter-multiplatform/ (ALL remaining files)
├── knowledge/tech-cards/[relevant]
├── knowledge/architecture-patterns/decision-tree.md
└── knowledge/security/ (if security trigger)

Already loaded (from LITE + STANDARD, keep):
[everything from previous tiers] ✅
```

### DEEP → CRITICAL (Delta: ~35+ extra files)
```
LOAD ADDITIONALLY:
├── knowledge/ (ALL remaining)
├── profiles/[industry-specific] (ALL)
├── knowledge/operational-intelligence/
├── benchmarks/benchmark-suite.md
├── global/organization-standards.md
└── all remaining prompts and playbooks

Already loaded (from LITE + STANDARD + DEEP, keep):
[everything from previous tiers] ✅
```

---

## User Notification

When auto-escalation happens, the framework MUST inform the user:

### Notification Format:
```markdown
⚡ **Auto-Escalation: LITE → STANDARD**

**Motivo:** [trigger description]
**Exemplo do trigger:** [specific evidence]
**Arquivos adicionais carregados:** [count] (+14 files)
**Agentes adicionados ao pipeline:** [list]

Continuando com nível STANDARD...
```

### Example:
```markdown
⚡ **Auto-Escalation: LITE → DEEP**

**Motivo:** Platform Guardian detectou uso de `dart:io` em código compartilhado — 
incompatível com a plataforma Web (target do projeto).

**Trigger:** #6 — Platform Guardian reports FAIL on target platform
**Arquivos adicionais carregados:** +28 files (delta LITE→DEEP)
**Agentes adicionados:** Researcher, Planner, UI/UX Specialist, Platform Guardian, Documentation, PM

Continuando com nível DEEP...
```

---

## De-Escalation (raro, mas possível)

Se durante uma análise STANDARD/DEEP o Orchestrator percebe que a tarefa é mais simples do que parecia:

```
DE-ESCALATION:
→ NÃO descarrega arquivos (já estão no contexto)
→ Apenas reduz a profundidade de análise dos agentes
→ Agentes usam "lite mode" mesmo com prompts DEEP carregados
→ Economiza tempo de processamento, não espaço de contexto
```

---

## Integration with Orchestrator

The Orchestrator's pipeline assembly step now includes:

```
STEP 1: Classify (keywords) → Initial Level
STEP 2: Load (Smart Loading) → Tier X files
STEP 3: Triage (all agents) → Gather evaluations
STEP 4: Escalation Check → Compare evaluations vs. current level
         IF requires_escalation:
           → Delta Load (Smart Loading delta)
           → Notify user
           → Re-triage with new context (only new agents)
STEP 5: Assemble pipeline → With final level
STEP 6: Execute
```

---

## Practical Examples

### Example 1: User says LITE, framework stays LITE
```
User: "LITE: Corrija o typo 'Cadastrarr' para 'Cadastrar' em register_screen.dart"

Triage result:
- Builder: CRITICAL ← only one that matters
- All others: NOT_NEEDED

Escalation check: 
- Only 1 agent needed ✅
- No new files ✅
- Single file modification ✅
→ NO ESCALATION. Stay LITE.
```

### Example 2: User says LITE, framework escalates to STANDARD
```
User: "LITE: Adicione campo de telefone no cadastro"

Triage result:
- Builder: CRITICAL
- UI/UX Specialist: RELEVANT ← needs design token check
- Validator: RELEVANT ← needs form validation test
- Platform Guardian: OPTIONAL ← phone input keyboard type

Escalation check:
- 3 agents RELEVANT or higher (> threshold of 2 for LITE) ← TRIGGER 1
- May need new widget file for masked input ← TRIGGER 2
→ ESCALATE LITE → STANDARD

⚡ Auto-Escalation: LITE → STANDARD
Motivo: Triage mostra 3 agentes necessários (UI/UX, Validator, Platform).
Campo de telefone pode precisar de máscara e validação específica.
Carregando +14 arquivos delta...
```

### Example 3: User says STANDARD, framework escalates to DEEP
```
User: "STANDARD: Implemente upload de avatar no perfil"

Triage result:
- All analysis agents: RELEVANT/CRITICAL
- Platform Guardian: CRITICAL — "image_picker não funciona igual em Windows/Web"

Escalation check:
- Platform Guardian reports FAIL on Windows ← TRIGGER 6
- Need to research alternatives (file_picker) ← needs Researcher deep
→ ESCALATE STANDARD → DEEP

⚡ Auto-Escalation: STANDARD → DEEP
Motivo: Platform Guardian detectou incompatibilidade de image_picker 
com Windows (target do projeto). Necessário pesquisa de alternativas 
e strategy de conditional import.
Carregando +25 arquivos delta...
```

---

## Configuration

In `framework.yaml`:
```yaml
auto_escalation:
  enabled: true
  notify_user: true
  max_escalation_per_request: 2  # LITE→STANDARD→DEEP (max 2 jumps)
  allow_skip_level: false        # LITE→DEEP requires LITE→STANDARD→DEEP
  de_escalation: true            # Allow reducing depth
  
  trigger_thresholds:
    lite_to_standard:
      min_relevant_agents: 3     # ≥3 agents say RELEVANT → escalate
      new_files_detected: true   # Creating new files → escalate
    standard_to_deep:
      security_flag: true        # Any security concern → escalate
      platform_fail: true        # Any platform FAIL → escalate
      phases_threshold: 3        # ≥3 phases → escalate
      negative_memory: true      # Past failure pattern → escalate
    deep_to_critical:
      regulatory_data: true      # Payment/health → always escalate
      production_scope: true     # Production deployment → escalate
```

---

## Memory Integration

After auto-escalation, record:
```yaml
memory_entry:
  type: escalation
  original_level: LITE
  final_level: STANDARD
  trigger: "3 agents marked RELEVANT during triage"
  request: "Adicione campo de telefone no cadastro"
  outcome: "Escalation was correct — phone masking needed cross-platform research"
  learning: "Form field additions with masking/validation → STANDARD minimum"
```

This helps future classifications be more accurate over time.
