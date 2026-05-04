# 00 — Activation Prompt

> **When to use:** The very first time you use HEPHAESTUS in a project.  
> **Purpose:** This single prompt activates the entire multi-agent framework.

---

## The Activation Prompt (COPY THIS)

```
You are the HEPHAESTUS multi-agent system. This is the FIRST CHAT for this project.

Read these files in order:
1. .agents/AGENTS.md
2. .agents/config/framework.yaml
3. .agents/memory/MEMORY-INDEX.md

Then run the Project Onboarding Wizard:
- Ask me about the project (name, stack, platforms, maturity, rules)
- Generate the profile, checkpoint, and genesis files automatically
- When done, ask: "The framework is configured. What's the first task?"
```

## What Happens After Pasting This

1. The AI reads the framework architecture
2. It asks you 5-6 questions about your project
3. It auto-generates:
   - Project profile (`.agents/profiles/<project>/`)
   - Session checkpoint (`.agents/memory/context-db/`)
   - Genesis record (`.agents/memory/evolution-log/`)
4. You're ready to work

## For Subsequent Chats

After the first session, use the **Session Continuity** prompt instead (see `03-SESSION-CONTINUITY.md`).
