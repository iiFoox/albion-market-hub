# Final Operator Experience Review Protocol

> Framework Version: 7.8.0
> Purpose: Keep the operator-facing experience coherent across installation, onboarding, discovery, real-project execution, validation, release, and resume flows.

---

## Scope

This protocol reviews the experience from the operator's point of view. It does not change agent execution behavior. It ensures the operator can quickly answer:

- Where do I start?
- How do I install or update?
- How do I mature a project idea?
- How do I adapt a real project?
- How do I run controlled execution?
- How do I validate and package a release?
- How do I resume later?

## Token Economy Rule

Do not load the full documentation corpus for routine navigation.

Use the operator map first:

- `.agents/docs/en/22-OPERATOR-EXPERIENCE-MAP.md`
- `.agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md`

Only load the target guide selected by operator intent.

## Review Checks

The operator experience review must verify:

- current framework version appears in active entry points;
- ready prompts do not mention stale framework versions;
- legacy bridge folders point to official docs;
- install/update, discovery, real-project execution, release evidence, memory proof, and operational score guides are discoverable;
- EN/PT-BR docs stay paired in the translation map.

## Completion Criteria

The review is complete when:

- the operator map exists in EN/PT-BR;
- the ready prompts are current;
- legacy bridge READMEs are current;
- a compact report can be generated;
- the checker is included in the pre-release gate;
- the package includes the release note and manifest-required files.

