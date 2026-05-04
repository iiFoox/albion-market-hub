# HEPHAESTUS Compatibility Policy

> Framework Version: 8.7.0
> Purpose: Define what compatibility means for kernel users and project installs.

---

## Compatibility Promise

HEPHAESTUS 6.x and later keep the kernel surface stable for projects that follow the manifest and package checklist.

Compatibility applies to:

- directory layout;
- required config entry points;
- validation commands;
- package verification behavior;
- documentation parity structure;
- telemetry schema validation;
- loading-tier estimation.
- dry-run install/update automation.
- operator-guided install/update wizard documentation.
- optional memory proof and telemetry retention validation with dry-run-first behavior.
- operator experience review that updates documentation entry points without changing kernel behavior.
- communication bus evidence that remains compact and does not require full transcript logging.

## Versioning Rules

Patch releases:

- fix validation bugs;
- correct documentation;
- update generated reports;
- improve wording without changing behavior.

Minor releases:

- add optional capabilities;
- add validators or stricter checks with migration guidance;
- add new docs or protocols;
- add config keys backed by real tooling.

Major releases:

- change kernel contracts;
- remove deprecated required files;
- rename stable directories;
- change release gate behavior in a breaking way.

## Deprecation Rules

Deprecations must be documented in the release note and changelog.

A deprecated kernel entry point should remain available for at least one minor release unless it is unsafe or invalid.

## Host Requirements

The stable kernel requires:

- local filesystem access;
- PowerShell execution for tooling;
- no network access for validation;
- Markdown and YAML-compatible text files.











