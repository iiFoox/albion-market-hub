# 28 — Baseline de Estabilidade

> Versao do Framework: 8.7.0
> Quando usar: voce quer confirmar que a superficie operacional estavel nao regrediu.

## Proposito

O Stability Baseline and Regression Sentinel protege as capacidades centrais que o operador usa depois de varias evolucoes incrementais.

Ele verifica conexoes compactas, nao o comportamento completo. O comportamento especifico continua coberto pelos checkers de cada feature.

## Comando

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-stability-baseline.ps1 -Root .
```

## O Que Ele Verifica

- Contagens estruturais minimas.
- Presenca das acoes do CLI unificado.
- Marcadores de config das capacidades criticas.
- Protocolos e checkers obrigatorios das capacidades criticas.
- Alinhamento de versao da baseline com o manifesto.

## Saida

O runner escreve:

```text
.agents/reports/operational/stability-baseline-latest.md
```

Qualquer FAIL bloqueia release pelo pre-release gate.

## Seguranca

A sentinela nao executa comandos de projeto, nao altera arquivos do projeto e nao exige acesso de rede.
