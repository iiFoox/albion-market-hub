# 27 — Assistente de Bootstrap de Projeto

> Versao do Framework: 8.7.0
> Quando usar: voce instalou o HEPHAESTUS em um projeto e quer a primeira passada segura de prontidao.

## Proposito

O Assistente de Bootstrap de Projeto conecta a primeira instalacao com duas camadas que ja existem:

- Project Discovery para historia, casos de uso, usuarios, regras, custos, legal/IP, MVP e prontidao de implementacao.
- Real Project Adapter para stack, comandos, paths, arquivos protegidos, modo de execucao e quality gates.

Ele cria um relatorio compacto e, opcionalmente, um rascunho de adapter. Ele nao sobrescreve config ativa.

## Comando

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
```

Ferramenta direta:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-project-bootstrap.ps1 -Root . -TargetRoot . -WriteReport -WriteAdapterDraft
```

## Saidas

- `.agents/reports/adapters/project-bootstrap-latest.md`
- `.agents/reports/adapters/project-adapter-draft.yaml` quando a geracao de rascunho for solicitada

## Seguranca

- Comeca em modo analysis-only.
- Nao habilita comandos automaticamente.
- Nao altera `.agents/config/project.yaml`.
- Usa arquivos detectados apenas como pistas.
- Mantem Discovery como fonte das decisoes de produto.
