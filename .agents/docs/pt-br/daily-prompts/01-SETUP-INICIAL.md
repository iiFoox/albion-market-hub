# 01 — Setup Inicial: Colocando o HEPHAESTUS no Projeto

> **Quando usar:** Primeira vez que você vai usar o HEPHAESTUS em um projeto (novo ou existente).
> **Tempo estimado:** 5 minutos

---

## Passo 1: Obter o Framework

### Opção A — Projeto NOVO (ainda não existe)
```
1. Crie a pasta do seu projeto:
   mkdir MeuProjeto
   cd MeuProjeto

2. Copie a pasta .agents/ do HEPHAESTUS para dentro:
   — Se você tem o ZIP: descompacte o ZIP mais recente (v5.1.0 ou superior)
   — Se você tem o repositório: copie a pasta .agents/ inteira

3. Resultado esperado:
   MeuProjeto/
   └── .agents/          ← HEPHAESTUS Framework
       ├── agents/
       ├── config/
       ├── knowledge/
       ├── protocols/
       ├── memory/
       └── ...
```

### Opção B — Projeto EXISTENTE (já tem código)
```
1. Navegue até a raiz do seu projeto:
   cd /caminho/para/MeuProjetoExistente

2. Copie a pasta .agents/ para a raiz do projeto:
   — Certifique-se de que .agents/ fica na RAIZ, ao lado de src/, package.json, etc.

3. Resultado esperado:
   MeuProjetoExistente/
   ├── src/               ← seu código existente
   ├── package.json       ← suas configs existentes
   └── .agents/           ← HEPHAESTUS Framework (novo)
       ├── agents/
       ├── config/
       ├── knowledge/
       └── ...

4. IMPORTANTE: Adicione ao seu .gitignore (se não quiser versionar o framework):
   # Opcional — se quiser manter o framework apenas local
   # .agents/memory/     ← memória é local por padrão
```

## Passo 2: Verificar a Estrutura

Confirme que estes diretórios existem dentro de `.agents/`:

```
✅ agents/          (8 pastas — orchestrator, researcher, planner, builder, validator, documentation, project-manager, delivery)
✅ protocols/       (10 arquivos .md)
✅ workflows/       (4 arquivos .md)
✅ config/          (6 arquivos .yaml/.yaml)
✅ knowledge/       (pastas com architecture-patterns, tech-cards, security, etc.)
✅ memory/          (4 sub-pastas + MEMORY.md)
✅ profiles/        (5 pastas — fintech, healthcare, etc.)
✅ docs/pt-br/daily-prompts/   (guias oficiais de uso)
✅ ROADMAP.md
✅ GETTING_STARTED.md
```

## Passo 3: Pronto!

O framework não precisa de instalação, build ou dependência. Ele funciona **apenas com os arquivos .md e .yaml** sendo lidos pelo seu assistente de IA (Gemini, Claude, GPT, Cursor, etc.).

**Próximo passo:** Vá para [02-PRIMEIRA-CHAMADA.md](./02-PRIMEIRA-CHAMADA.md)
