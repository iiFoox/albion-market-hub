# HEPHAESTUS Documentation

> Framework Version: 8.7.0
> Documentation Structure: Bilingual user-facing documentation
> Operational Language: English
> User Communication: Portuguese (pt-BR)

---

## Documentation Sets

HEPHAESTUS keeps its operational framework definitions in English while offering complete user-facing documentation in two separate language folders.

| Language | Path | Purpose |
|---|---|---|
| English | [en/README.md](en/README.md) | Complete documentation and tutorial set in English |
| Portuguese (Brazil) | [pt-br/README.md](pt-br/README.md) | Complete documentation and tutorial set in Brazilian Portuguese |

## Release History

Release history is tracked in [../releases/CHANGELOG.md](../releases/CHANGELOG.md).

## Operational Boundary

The following framework internals remain in English and are not duplicated by language:

- `.agents/AGENTS.md`
- `.agents/agents/**`
- `.agents/config/**`
- `.agents/protocols/**`
- `.agents/workflows/**`
- `.agents/memory/**`
- `.agents/knowledge/**`
- `.agents/profiles/**`

The documentation folders explain how to use the framework. They do not replace the operational source of truth.

## Compatibility

The legacy `.agents/Tutorial/` and `.agents/daily-prompts/` folders are preserved as README-only compatibility bridges. New user-facing documentation should point to `.agents/docs/en/` or `.agents/docs/pt-br/`.










