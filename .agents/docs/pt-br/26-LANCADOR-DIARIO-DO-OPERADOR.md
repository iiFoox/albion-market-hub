# 26 — Lancador Diario do Operador

> Versao do Framework: 8.7.0
> Quando usar: voce quer pontos simples para trabalho diario, validacao, preparacao de release ou primeira instalacao.

## Proposito

O lancador diario do operador transforma intencoes comuns em chamadas seguras para as ferramentas existentes do framework.

Ele preserva o modelo de seguranca: instalacao continua dry-run por padrao, release continua usando o pre-release gate, e o lancador nao esconde os scripts reais.

## Comandos Diarios

Comecar o trabalho:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode start
```

Validar antes de encerrar:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode validate
```

Preparar validacao de release:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode release -Version 8.7.0
```

## Lancador de Instalacao no Windows

Execute:

```bat
.agents\tools\install-hephaestus.bat C:\Project\Destino
```

O lancador pergunta se deve aplicar. Qualquer resposta diferente de `YES` executa dry-run.

Quando o Apply termina com sucesso, ele cria:

```text
HEPHAESTUS-FIRST-CALL.md
```

Esse arquivo contem um primeiro prompt pronto para usar no projeto destino.

## Decisao Sobre EXE

Nao vale criar `.exe` ainda. Um `.bat` e mais facil de inspecionar, empacotar, validar e atualizar. Um `.exe` so deve entrar depois se houver necessidade real de distribuicao, assinatura e politica de suporte.
