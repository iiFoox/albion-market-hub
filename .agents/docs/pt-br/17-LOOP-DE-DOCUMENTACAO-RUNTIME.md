# Loop de Documentacao em Runtime

> Versao do Framework: 8.0.0
> Idioma: Portugues (Brasil)
> Escopo: Guia de uso

## Objetivo

O Loop de Documentacao em Runtime prova que a documentacao acompanha as mudancas do projeto.

Em vez de carregar toda a documentacao, o loop recebe caminhos alterados, classifica impacto documental e gera um relatorio compacto de evidencia.

## Como Rodar

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-documentation-runtime-loop.ps1 -Root . -ChangedFiles src/example.ts -WriteReport
```

Relatorio mais recente:

```text
.agents/reports/documentation/documentation-runtime-latest.md
```

## Comportamento

- Mudancas em codigo normalmente exigem revisao de README ou documentacao de feature.
- Mudancas em API exigem revisao da documentacao de API.
- Mudancas em config/protocolo/workflow do framework exigem revisao da referencia completa.
- `not_impacted` so e permitido com motivo explicito.

## Economia de Tokens

O loop usa caminhos alterados e regras compactas de politica. Ele nao carrega documentacao ampla salvo quando a mudanca exige.






