# 23 — Barramento de Comunicacao Entre Agentes

> Versao do Framework: 8.0.0
> Quando usar: auditar handoffs, consultas, conflitos, decisoes, alertas ou loops de correcao entre agentes.

---

## Proposito

O barramento de comunicacao da ao HEPHAESTUS uma forma compacta e auditavel de provar que os agentes estao coordenando. Ele registra resumos estruturados, nao transcricoes completas.

## O Que Ele Captura

| Tipo de Mensagem | Uso |
|---|---|
| `handoff` | Transferencia de responsabilidade entre agentes |
| `consultation` | Consulta especialista sem transferencia de responsabilidade |
| `broadcast` | Informacao compartilhada via Orchestrator |
| `alert` | Risco de seguranca, producao, comando destrutivo ou perda de dados |
| `conflict` | Divergencia sobre escopo, qualidade, arquitetura, risco ou prioridade |
| `decision` | Decisao do Orchestrator apos revisao de evidencias |
| `correction` | Rejeicao downstream enviada de volta upstream |

## Rodar a Prova

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-communication-bus-proof.ps1 -Root . -WriteReport
```

Saida esperada:

```text
Communication bus summary: status=PASS, messages=4
```

Relatorio mais recente:

```text
.agents/reports/communication/communication-bus-latest.md
```

## Validar a Amarracao

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-communication-bus.ps1 -Root .
```

## Limite de Tokens

Carregue este guia apenas quando a tarefa envolver coordenacao entre agentes, evidencia de auditoria, handoffs, conflitos, correcoes ou prova de release.


