# AGENT.md Template — Standard Structure

> **Purpose:** Every agent's AGENT.md MUST follow this structure.  
> **Model agent:** `ui-ux-specialist/AGENT.md` (the gold standard)

---

## Required Sections (in this order)

```markdown
# AGENT.md — [Agent Name]

> **Agent ID:** `[id]`  
> **Role:** [one-line role description]  
> **Expertise Level:** [Senior Architect | Senior Engineer | etc.]  
> **Always Active:** [Yes/No — when Yes, explain why]  
> **Framework Version:** [minimum version]

---

## 1. Identity
[2-3 sentences: who is this agent and what is its core function]

## 2. Core Mission
[Numbered list: 5-10 things this agent exists to do]

## 3. Capabilities
[Organized by sub-area. Each capability has a bullet list of specifics]
### 3.1 [Capability Area]
### 3.2 [Capability Area]
...

## 4. Self-Evaluation Protocol
[Template for YES/NO/SKIP decision + activation keywords + skip conditions]

## 5. Input/Output Contract
### Input — what this agent receives
### Output — structured output format with template

## 6. Inter-Agent Communication
[Who sends to this agent, who this agent sends to, with examples]

## 7. Memory Integration
### Before Acting — what to check
### After Completion — what to store

## 8. Quality Standards
[ALWAYS/NEVER rules as bullet list]

## 9. Anti-Patterns
[Numbered list of things this agent must NEVER do]

## 10. Prompts
[References to prompt files in prompts/ directory]
```

---

## Required Prompt Files

Every agent MUST have these prompt files:
- `prompts/system-prompt.md` — Core identity and behavioral rules
- `prompts/deep-reasoning.md` — Complex analysis mode
- `prompts/self-evaluation.md` — Participation decision logic

## Optional Prompt Files (by role)
- `prompts/[task-specific].md` — E.g., `implementation.md`, `design-review.md`, `commit-generation.md`

---

## Compliance Check

| Agent | Sections Complete | Prompts Complete | Status |
|-------|------------------|-----------------|--------|
| orchestrator | 10/10 | 6 prompts | ✅ |
| researcher | 10/10 | 7 prompts | ✅ |
| planner | 10/10 | 7 prompts | ✅ |
| builder | 10/10 | 7 prompts | ✅ |
| validator | 10/10 | 7 prompts | ✅ |
| documentation | 10/10 | 7 prompts | ✅ |
| project-manager | 10/10 | 7 prompts | ✅ |
| ui-ux-specialist | 10/10 | 4 prompts | ✅ |
| platform-guardian | 10/10 | 4 prompts | ✅ |
| delivery | 7/10 | 4 prompts | 🟡 Missing: I/O Contract, Memory Integration, Anti-Patterns |
