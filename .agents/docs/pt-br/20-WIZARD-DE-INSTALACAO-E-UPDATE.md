# 20 — Wizard de Instalacao e Update

> Versao do Framework: 8.0.0
> Quando usar: instalar o HEPHAESTUS em um projeto novo ou atualizar um projeto existente.
> Modelo de seguranca: dry-run primeiro, backup antes de update, preservacao de configuracao local do projeto.

---

## O Que Este Wizard Faz

Este guia transforma as ferramentas de instalacao/update em um fluxo claro para o operador. Ele nao adiciona um agente pesado em runtime. Ele ajuda a escolher o comando certo, revisar o dry-run, aplicar apenas quando houver intencao explicita e validar o resultado.

Use quando:

- um projeto ainda nao tem `.agents/`;
- um projeto ja tem `.agents/` e precisa ser atualizado;
- voce quer comparar versoes antes de copiar arquivos;
- voce recebeu um ZIP do framework e precisa de um caminho seguro de setup.

## Passo 1: Definir Origem e Destino

Origem e a pasta que contem o HEPHAESTUS atual com `.agents/`.

Destino e o projeto que deve receber ou atualizar o HEPHAESTUS.

Exemplo:

```powershell
$source = "C:\Project\SuperAgentsClaudiao"
$target = "C:\Project\MeuApp"
```

## Passo 2: Comparar Versoes

Execute:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/compare-framework-version.ps1 -SourceRoot $source -TargetRoot $target
```

Se o destino nao tem `.agents/`, siga para instalacao.

Se o destino ja tem `.agents/`, siga para update.

## Passo 3A: Instalacao Nova

Dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot $source -TargetRoot $target
```

Aplicar depois de revisar o dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot $source -TargetRoot $target -Apply
```

O instalador recusa instalar por cima de uma pasta `.agents/` existente. Nesse caso, use update.

## Passo 3B: Update Existente

Dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot $source -TargetRoot $target
```

Aplicar com backup:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot $source -TargetRoot $target -Apply
```

O updater preserva configuracao local do projeto e estado de sessao por padrao.

## Passo 4: Validar o Destino

Apos instalar ou atualizar, rode dentro do projeto destino:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/validate-framework.ps1 -Root .
```

Para uma validacao completa de nivel release:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Root . -Version 8.0.0
```

## O Que E Preservado Durante Update

O updater preserva:

- `.agents/config/project.yaml`
- `.agents/config/multi-project.yaml`
- `.agents/memory/context-db/session-checkpoint.md`
- `.agents/memory/context-db/session-brief.md`
- `.agents/memory/context-db/next-chat-activation-prompt.md`

Use overwrite apenas quando quiser substituir intencionalmente configuracoes locais do projeto.

## Prompt de Wizard Para o LLM Hospedeiro

```markdown
Leia .agents/protocols/install-update-wizard-protocol.md e .agents/kernel/INSTALL-UPDATE.md.
Me guie pela instalacao ou update do HEPHAESTUS.
Comece com dry-run, preserve configuracao local do projeto e nao aplique mudancas ate eu aprovar.
```

## Checklist de Conclusao

- [ ] Origem confirmada.
- [ ] Destino confirmado.
- [ ] Estado do destino identificado: instalacao nova ou update.
- [ ] Comparacao ou dry-run executado.
- [ ] Apply aprovado explicitamente ou pulado.
- [ ] Backup preservado em update.
- [ ] Validacao do destino executada.



