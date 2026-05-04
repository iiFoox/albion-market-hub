# 21 — Prova Opcional de Telemetria e Memoria

> Versao do Framework: 8.0.0
> Quando usar: validacao de release, auditoria de consulta de memoria ou evidencia opcional de telemetria.
> Modelo de tokens: prova compacta, sem carregar stores completos de memoria.

---

## Proposito

Este guia explica como provar que o HEPHAESTUS consegue consultar memoria com seguranca sem obrigar telemetria de memoria em toda sessao normal.

A prova e opcional. Ela existe para gates de release, auditorias e confianca operacional do operador.

## O Que Ela Prova

A prova verifica que:

- a politica de memoria existe;
- o protocolo de consulta de memoria existe;
- a memoria usa consulta index-first;
- o carregamento completo de stores de memoria fica desativado por padrao;
- consulta de memoria no inicio e no fechamento da sessao esta configurada;
- o schema de telemetria aceita evidencia de memory-proof;
- a limpeza de retencao de telemetria roda em dry-run.

## Rodar a Prova

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-memory-proof.ps1 -Root . -WriteReport
```

Saida esperada:

```text
Memory proof summary: status=PASS, evidence=7
```

O relatorio mais recente fica em:

```text
.agents/reports/memory/memory-proof-latest.md
```

## Validar a Amarracao

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-memory-proof.ps1 -Root .
```

## Retencao Opcional de Telemetria

Checagem dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365
```

Arquive logs antigos apenas depois de aprovacao intencional:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365 -Archive -Apply
```

O framework nao deleta telemetria como parte desta feature.

## Limite de Economia de Tokens

Requests normais nao carregam este guia nem o protocolo de prova de memoria. Carregue apenas quando o pedido falar de prova de memoria, prova de telemetria, retencao, validacao de release ou auditoria de memoria.




