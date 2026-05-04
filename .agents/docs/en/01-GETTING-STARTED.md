# 01 — Getting Started

> **When to use:** First-time setup of HEPHAESTUS in a new project.  
> **Time required:** ~10 minutes  
> **Prerequisites:** A project repository, an AI coding assistant (Antigravity, Cursor, Codex, etc.)

---

## Step 1: Install or Update the Framework

Use the current install/update wizard when copying HEPHAESTUS into a project:

- New project: [Install and Update Wizard](20-INSTALL-UPDATE-WIZARD.md)
- Existing project: [Install and Update Wizard](20-INSTALL-UPDATE-WIZARD.md)

Manual target layout after install:

```
your-project/
├── .agents/          ← Copy this entire folder here
├── src/
├── package.json
└── ...
```

## Step 2: Run Project Onboarding

Open a new chat with your AI assistant and paste the activation prompt from `00-ACTIVATION-PROMPT.md`.

Project onboarding should ask for:
1. **Project name** and description
2. **Tech stack** (languages, frameworks, database)
3. **Target platforms** (Web, Android, iOS, Windows, etc.)
4. **Maturity profile** (startup / SMB / enterprise / regulated / legacy)
5. **Custom rules** (anything the AI must always follow)

## Step 3: Verify Setup

After the wizard completes, you should have:

```
.agents/
├── profiles/<your-project>/
│   └── <your-project>-profile.md     ✅ Generated
├── memory/
│   ├── context-db/
│   │   ├── <project>-project-state.md     ✅ Generated
│   │   └── <project>-session-checkpoint.md ✅ Generated
│   └── evolution-log/
│       └── <project>-genesis.md           ✅ Generated
└── config/
    └── framework.yaml                     ✅ Updated with your profile
```

## Step 4: Start Working

Tell the AI what you want to build. The framework will automatically:
- Route your request to the right agents
- Choose the right complexity level (LITE → CRITICAL)
- Apply your project rules
- Save learnings to memory

---

## Quick Reference

| Want to... | Do this |
|-----------|---------|
| Install or update HEPHAESTUS | Use Install and Update Wizard (`20-INSTALL-UPDATE-WIZARD.md`) |
| Start a new project | Run project onboarding (this guide) |
| Continue tomorrow | Use Session Continuity prompt (`03-SESSION-CONTINUITY.md`) |
| Fix a small bug | Just describe it — framework auto-selects Quick Fix |
| Build a feature | Just describe it — framework auto-selects Full Pipeline |
| Review code | Say "review this" — framework runs Review workflow |
| Check framework health | Use Health Dashboard (`workflows/health-dashboard.md`) |

## Maturity Profiles Explained

| Profile | Quality Gates | Risk Tolerance | Best For |
|---------|--------------|----------------|----------|
| **Startup** | 60% coverage, no reviews | HIGH | MVPs, prototypes, hackathons |
| **SMB** | 75% coverage, 1 review | MEDIUM | Products with paying customers |
| **Enterprise** | 90% coverage, 2 reviews | LOW | Large teams, B2B SaaS |
| **Regulated** | 95% coverage, audit trail | VERY LOW | Fintech, healthcare, government |
| **Legacy** | 70% coverage, ADRs required | LOW | Brownfield, high regression risk |
