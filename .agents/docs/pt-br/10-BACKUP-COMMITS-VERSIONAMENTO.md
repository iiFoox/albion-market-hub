# 10 — Backup, Commits e Versionamento

> **Nível:** 🟢 Iniciante  
> **Agente responsável:** Delivery

---

## Semantic Versioning (SemVer)

O framework usa **Semantic Versioning** automaticamente:

```
MAJOR.MINOR.PATCH
  │      │     └── Bug fix, typo, config → ex: 1.2.3 → 1.2.4
  │      └──── Feature nova, mudança compatível → ex: 1.2.4 → 1.3.0
  └────── Breaking change, incompatibilidade → ex: 1.3.0 → 2.0.0
```

| Ação | Version Bump | Exemplo |
|------|-------------|---------|
| Bug fix | patch | 1.2.3 → 1.2.4 |
| Nova feature | minor | 1.2.4 → 1.3.0 |
| Breaking change | major | 1.3.0 → 2.0.0 |
| Typo, docs, style | patch (auto) | 1.2.3 → 1.2.4 |

---

## Conventional Commits

Todas as mensagens de commit seguem o padrão **Conventional Commits**:

```
<tipo>(<escopo>): <descrição curta>

[corpo opcional]

[footer opcional]
```

### Tipos:
| Tipo | Quando usar | Bump |
|------|-------------|------|
| `fix` | Bug fix | patch |
| `feat` | Feature nova | minor |
| `feat!` | Feature com breaking change | major |
| `refactor` | Refactor sem mudar comportamento | patch |
| `style` | Formatação, espaçamento | patch |
| `docs` | Documentação | patch |
| `test` | Adicionar/modificar testes | patch |
| `chore` | Build, config, dependências | patch |
| `perf` | Performance improvement | patch |

### Exemplos:
```
fix(auth): add null check to login email validation
feat(profile): add user avatar upload with file picker
refactor(products): extract business logic to use cases
docs(api): update endpoint documentation for v2
chore(deps): upgrade dio to 5.4.0
perf(lists): implement ListView.builder for product list
feat!(api): change auth response format from v1 to v2

BREAKING CHANGE: Auth response now returns { data: { token } } instead of { token }
```

---

## Commit Gate Protocol

O Delivery Agent avalia se o trabalho merece commit:

```
COMMIT GATE:
├── Work changed files? → NO → Don't commit
├── Tests passing? → NO → Don't commit (go back to Builder)
├── Scope clear? → NO → Ask user to confirm scope
└── Commitável? → YES → Commit + push

AUTO-COMMIT PERMITIDO (LITE):
→ docs, chore, style, test → commit automático sem perguntar

USER CONFIRM NECESSÁRIO:
→ feat, fix, refactor, perf → confirmar com usuário antes
→ feat! (breaking) → SEMPRE confirmar
```

---

## Fluxo de Backup

### Backup do Framework:
```markdown
Faça backup do framework HEPHAESTUS:
1. Copie .agents/ para HEPHAESTUS-Framework-v[versão]-[nome]/
2. Comprima em ZIP
3. Confirme os arquivos incluídos
```

### Backup do Projeto:
```markdown
Faça backup completo:
1. Commit de tudo que está pendente
2. Push para repositório remoto
3. Confirme que o remote está atualizado
4. Atualize o session-checkpoint.md
```

---

## Fluxo de Git Gerenciado pelo Framework

### O que o Delivery Agent faz:
```
1. Avalia se merece commit (Commit Gate)
2. Gera mensagem Conventional Commits
3. Determina version bump
4. Atualiza CHANGELOG.md
5. Commita
6. Tag (se minor/major)
7. Push para remote
```

### Pedidos que você pode fazer:
```markdown
# Ver status:
Qual o status do Git? Tem algo pendente?

# Commitar manualmente:
Commit o trabalho atual com mensagem: "feat(auth): add biometric login"

# Tag/Release:
Crie release v2.0.0 com release notes.

# Rollback:
Desfaça o último commit (mantenha os arquivos).

# Branch:
Crie branch feature/payment e mude para ela.
```

---

## CHANGELOG Automático

O Documentation Agent mantém o CHANGELOG.md atualizado:

```markdown
# Changelog

## [1.3.0] - 2026-04-15

### Added
- User profile screen with avatar upload (#45)
- Biometric login for Android and iOS (#52)

### Fixed
- Null pointer on login screen email field (#48)
- Product list scroll lag with 100+ items (#51)

### Changed
- Refactored auth module to Clean Architecture (#50)
```

---

## Próximo

→ [11-EVOLUCAO-DO-FRAMEWORK.md](11-EVOLUCAO-DO-FRAMEWORK.md) — Como fazer o framework evoluir
