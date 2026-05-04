# Revisao de Nota Operacional

> Versao do Framework: 8.0.0
> Idioma: Portugues (Brasil)
> Escopo: Guia de uso

## Objetivo

A Revisao de Nota Operacional resume a prontidao do framework depois da sequencia de hardening v7.x.

Ela avalia:

- integridade estrutural;
- enforcement de seguranca;
- prontidao para execucao em projeto real;
- continuidade documental;
- governanca de release;
- economia de tokens;
- lacunas operacionais residuais.

## Como Rodar

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-operational-score-review.ps1 -Root . -WriteReport
```

Relatorio mais recente:

```text
.agents/reports/operational/score-review-latest.md
```

## Significado

A nota e um indicador de prontidao operacional, nao uma promessa de que o framework substitui julgamento humano.



