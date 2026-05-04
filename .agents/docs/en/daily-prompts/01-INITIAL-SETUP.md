# 01 — Initial Setup

> Use when: You are adding HEPHAESTUS to a new or existing project for the first time.
> Estimated time: 5 minutes

---

## Step 1: Add the Framework

Copy the `.agents/` folder into the project root.

Expected structure:

```text
MyProject/
└── .agents/
    ├── AGENTS.md
    ├── agents/
    ├── config/
    ├── docs/
    ├── knowledge/
    ├── memory/
    ├── protocols/
    └── workflows/
```

## Step 2: Open the Documentation

Use one of the language-specific documentation sets:

- English: `.agents/docs/en/README.md`
- Portuguese: `.agents/docs/pt-br/README.md`

## Step 3: Start the First Chat

Open your LLM host and paste the activation prompt:

- English: `.agents/docs/en/00-ACTIVATION-PROMPT.md`
- Portuguese: `.agents/docs/pt-br/00-ACTIVATION-PROMPT.md`

## Step 4: Ask for Onboarding

Use:

```text
Initialize HEPHAESTUS for this project. Read .agents/AGENTS.md, inspect the project structure, identify the stack, and create an onboarding summary before proposing the first workflow.
```
