# Supported Host Matrix

> Framework Version: 8.7.0
> Purpose: Define supported execution hosts for the stable kernel.

---

## Support Levels

| Host | Support | Notes |
|---|---|---|
| Codex CLI / Codex workspace | Supported | Primary local automation and validation host |
| Antigravity-style agent workspace | Supported | Compatible with `.agents/AGENTS.md` and local docs |
| Generic LLM chat with file access | Compatible | Requires manual execution of PowerShell tools |
| Read-only chat | Documentation only | Can read docs but cannot validate or package |
| Network-only automation | Not required | Kernel validation must work without network access |

## Required Capabilities

Supported hosts need:

- read/write access to `.agents`;
- PowerShell script execution;
- ZIP creation support;
- ability to preserve Markdown/YAML text files.

## Non-Requirements

The kernel does not require:

- external package managers;
- internet access;
- background services;
- databases;
- scheduled jobs.











