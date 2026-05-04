# 25 — Guarda de Deriva do Contrato Central

> Versao do Framework: 8.7.0
> Quando usar: voce alterou o contrato central do framework, metadados de versao, core do Smart Loading ou pontos de entrada de release.

## Proposito

A guarda de deriva do contrato central mantem o contrato sempre carregado compacto e atual.

Ela protege o `AGENTS.md` contra acumulo de catalogos amplos de tecnologia, referencias antigas de protocolo ou divergencia de versao que aumentariam o custo normal de tokens por sessao.

## Comando

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-core-contract.ps1 -Root .
```

## O Que Ela Verifica

- Alinhamento de versao entre metadados centrais.
- Referencia atual ao communication bus em `AGENTS.md`.
- Registro da guarda de deriva na configuracao ativa.
- Ausencia de marcadores de catalogos tecnologicos amplos em `AGENTS.md`.
- Entradas no mapa de traducao para este guia e seu par EN.
- Integracao com o pre-release gate.

## Uso em Release

O pre-release gate executa esta validacao automaticamente. O operador tambem pode roda-la diretamente antes de release quando `AGENTS.md` ou metadados de versao forem alterados.

## Modelo de Seguranca

Esta guarda nao executa comandos de projeto, nao altera codigo do projeto e nao exige acesso de rede. Ela apenas le arquivos do framework e reporta deriva.
