# Install and Update Wizard Protocol

> Framework Version: 7.6.0
> Purpose: Guide operators through safe HEPHAESTUS install and update flows using the existing dry-run-first tooling.

---

## Scope

This protocol does not replace the installer or updater scripts. It defines the operator-facing wizard flow that selects the right existing tool, confirms intent, preserves project-specific state, and validates the result.

Use this protocol when the operator asks to:

- install HEPHAESTUS into a new project;
- update HEPHAESTUS in an existing project;
- compare the framework version between source and target;
- verify whether an install or update is safe;
- recover orientation after copying a framework ZIP.

## Token Economy Rule

Do not load full framework documentation for routine install/update questions.

Load only:

- `.agents/kernel/INSTALL-UPDATE.md`
- `.agents/protocols/install-update-wizard-protocol.md`
- `.agents/tools/compare-framework-version.ps1`
- `.agents/tools/install-framework.ps1` or `.agents/tools/update-framework.ps1`
- the language-specific wizard guide when the user needs step-by-step instructions.

## Wizard Decision Flow

1. Identify the target project path.
2. Detect whether the target already has `.agents/`.
3. If `.agents/` is absent, choose the install flow.
4. If `.agents/` exists, choose the update flow.
5. Run compare/dry-run before Apply.
6. Explain the exact command to run or run it when the operator has approved execution in the current environment.
7. For updates, preserve project-local config and session state by default.
8. After Apply, run validation or tell the operator which validation command confirms the result.

## Safety Requirements

- Dry-run is the default.
- Apply requires explicit operator intent.
- Updates must create or preserve backup behavior unless the operator intentionally disables it.
- Project-local files must be preserved unless the operator explicitly asks to overwrite them.
- The wizard must never suggest destructive cleanup commands as part of install/update.
- The wizard must not require network access.

## Operator Prompts

The wizard may ask only the minimum needed questions:

- target project path;
- new install or existing update, if path detection is unavailable;
- whether to run dry-run only or Apply after reviewing the dry-run;
- whether project-local config should be preserved.

## Completion Criteria

The wizard is complete when:

- the selected path is clear;
- the correct flow was chosen;
- dry-run output was reviewed or made available;
- Apply was either completed or intentionally skipped;
- post-install/update validation was run or documented;
- documentation points to the current EN/PT-BR wizard guides.

