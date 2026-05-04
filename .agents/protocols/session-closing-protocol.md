# Session Closing Protocol

> **Protocol ID:** session-closing  
> **Version:** 1.0.0  
> **Priority:** MANDATORY — must execute at the end of EVERY session  
> **Purpose:** Ensure the memory system is fed after every work session

---

## Why This Exists

Without this protocol, the memory system dies. The AI finishes work, the chat closes, and all learnings vanish. This protocol prevents that by making memory writes **mandatory** before session end.

---

## When To Trigger

This protocol MUST execute when:
- The user says they're done / finishing / closing
- The user asks for a commit or final save
- The user asks for a "next chat prompt"
- The conversation is reaching token limits
- Any natural end-of-session signal

---

## Session Closing Checklist

### Step 1: Update Session Checkpoint (ALWAYS)
Write/update the session checkpoint file:
```
.agents/memory/context-db/<project>-session-checkpoint.md
```

Include:
- What was accomplished this session
- Current state of the active front
- What's pending / next steps
- Any blockers discovered

### Step 2: Record Quick Learnings (IF applicable)
If anything was validated, discovered, or failed during this session, write a Quick Learning:
```
.agents/memory/learning-store/<descriptive-name>.md
```

Use the **Quick Learning Format** (not the full 12-section template):
```markdown
---
id: "ql-YYYY-MM-DD-NNN"
type: "success" | "failure" | "insight"
created: "ISO-8601"
confidence: 0.0-1.0
tags: ["tag1", "tag2"]
---

## What
[One sentence: what was learned]

## Context  
[One sentence: what task triggered this learning]

## Evidence
[One sentence: how was it validated]

## Reuse Rule
[One sentence: when to apply this learning in the future]
```

### Step 3: Record Architecture Decisions (IF applicable)
If an architectural or design decision was made, write to:
```
.agents/memory/knowledge-graph/<descriptive-name>.md
```

### Step 4: Log Evolution Milestone (IF applicable)
If a significant milestone was reached (feature complete, migration done, new capability), write to:
```
.agents/memory/evolution-log/<milestone-name>.md
```

### Step 5: Generate Next Chat Prompt (RECOMMENDED)
Create/update the activation prompt for the next session:
```
.agents/memory/context-db/next-chat-activation-prompt.md
```

---

## Decision Tree

```
Session ending?
│
├── Did you change code?
│   ├── YES → Step 1 (checkpoint) + Step 2 (learning if validated)
│   └── NO  → Step 1 (checkpoint only)
│
├── Did you make an architecture decision?
│   ├── YES → Step 3 (knowledge-graph entry)
│   └── NO  → Skip Step 3
│
├── Did you reach a milestone?
│   ├── YES → Step 4 (evolution log)
│   └── NO  → Skip Step 4
│
└── Will work continue later?
    ├── YES → Step 5 (next chat prompt)
    └── NO  → Skip Step 5
```

---

## Anti-Patterns

- ❌ **NEVER** end a session without at least updating the checkpoint (Step 1)
- ❌ **NEVER** write learnings to legacy `memory/` folders if HEPHAESTUS is active
- ❌ **NEVER** skip this protocol because "it was a small session" — even small sessions produce context
- ❌ **NEVER** write multi-page learnings — use Quick Learning format (4 fields max)

---

## Enforcement

This protocol is referenced in:
- `framework.yaml` → `execution.session_checkpoint.enabled: true`
- `profiles/<project>/<project>-profile.md` → Session Closing Protocol section
- Each agent's pipeline position → Delivery agent triggers this as final step
