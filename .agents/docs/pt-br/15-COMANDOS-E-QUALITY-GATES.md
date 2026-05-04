# Allowlist de Comandos e Quality Gates

> Versao do Framework: 8.0.0
> Idioma: Portugues (Brasil)
> Escopo: Guia de uso

## Objetivo

O HEPHAESTUS pode executar quality gates locais do projeto por meio de `.agents/config/project.yaml`, mas apenas quando o comando estiver explicitamente permitido.

Isso mantem a execucao em projeto real controlada: o framework pode validar testes, lint, build ou checagens similares sem transformar qualquer comando local em comportamento padrao.

## Configuracao

Os comandos ficam no adaptador do projeto:

```yaml
commands:
  test:
    command: "powershell -NoProfile -ExecutionPolicy Bypass -File tests/quality.test.ps1"
    allowed: true
  lint:
    command: ""
    allowed: false
```

Somente comandos com `allowed: true` e `command` preenchido podem ser executados.

## Comportamento de Seguranca

O runner bloqueia padroes destrutivos antes da execucao, incluindo exclusao recursiva, `git reset/clean` destrutivo, formatacao de disco, shutdown, exclusao de registro e comandos destrutivos de banco.

Isso e uma protecao, nao um substituto para julgamento do operador. Mantenha comandos do projeto pequenos, previsiveis e locais ao projeto.

## Executando Gates

Executar todos os gates permitidos:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-quality-gates.ps1 -Root . -WriteReport
```

Executar gates selecionados:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-quality-gates.ps1 -Root . -GateNames test,lint -WriteReport
```

O relatorio compacto mais recente e gravado em:

```text
.agents/reports/executions/quality-gates-latest.md
```

## Economia de Tokens

Essa capacidade so deve ser carregada quando quality gates ou execucao de comandos do adaptador forem relevantes. Os relatorios permanecem compactos e evitam trazer logs completos para o contexto normal.








