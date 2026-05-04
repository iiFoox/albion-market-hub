# Cenario de Apply em Projeto Real

> Versao do Framework: 8.0.0
> Idioma: Portugues (Brasil)
> Escopo: Guia de uso

## Objetivo

O Cenario de Apply em Projeto Real prova o fluxo controlado completo em uma fixture isolada:

1. executar um quality gate permitido pelo adaptador;
2. gerar um plano DryRun;
3. executar Apply controlado com token de aprovacao obrigatorio;
4. validar evidencias de backup e auditoria;
5. executar o quality gate novamente;
6. restaurar a partir do backup mais recente.

Isso nao torna mutacao em projeto real automatica. Ele prova que as travas de seguranca funcionam em conjunto.

## Como Rodar

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/test-real-project-apply-scenario.ps1 -Root .
```

O relatorio compacto mais recente e gravado em:

```text
.agents/reports/executions/real-project-apply-scenario-latest.md
```

## O Que Valida

- comportamento do adaptador `.agents/config/project.yaml`;
- allowlist de comandos de quality gate;
- execucao DryRun-first;
- obrigatoriedade do token de aprovacao;
- backup antes de mutacao;
- criacao de trilha de auditoria;
- disponibilidade de restore.

## Economia de Tokens

Esse cenario so deve ser carregado e executado quando a validacao de Apply em projeto real for relevante. O trabalho normal nao carrega essa camada.







