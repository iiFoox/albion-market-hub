# Pacote de Evidencias de Release

> Versao do Framework: 8.0.0
> Idioma: Portugues (Brasil)
> Escopo: Guia de uso

## Objetivo

O Pacote de Evidencias de Release consolida as provas da release em um relatorio compacto.

Ele referencia as validacoes existentes em vez de copiar logs completos de comando.

## Como Rodar

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-release-evidence-bundle.ps1 -Root . -Version 8.0.0 -PackagePath HEPHAESTUS-Framework-v8.0.0.zip -WriteReport
```

Relatorio mais recente:

```text
.agents/reports/releases/release-evidence-latest.md
```

## Evidencias Incluidas

- integridade do framework;
- runtime de documentacao;
- quality gates de comandos;
- execucao em projeto real;
- cenario de Apply em projeto real;
- presenca do pacote.

## Economia de Tokens

O pacote mantem evidencias orientadas por caminhos e resumos. Ele nao deve embutir a saida completa do pre-release.





