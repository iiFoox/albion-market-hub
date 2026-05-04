# 14 — Execucao em Projeto Real

> Versao do Framework: 8.0.0
> Proposito: usar o HEPHAESTUS para planejamento controlado de execucao em um projeto local real.

---

## O Que Este Modo Faz

A Execucao em Projeto Real permite que o HEPHAESTUS prepare trabalho em projeto real com um processo seguro:

1. ler `.agents/config/project.yaml`;
2. validar limites do adapter;
3. gerar um plano DryRun;
4. identificar arquivos planejados e conflitos com paths protegidos;
5. listar comandos permitidos e quality gates;
6. exigir aprovacao explicita antes de qualquer caminho de Apply.

## Padrao Seguro

A configuracao padrao do projeto continua segura:

```yaml
execution:
  mode: "analysis_only"
  require_plan_before_changes: true
  require_approval_before_apply: true
  backup_before_mutation: true
  allow_destructive_commands: false
```

Nesse estado, o HEPHAESTUS pode raciocinar e produzir plano, mas mutacao real fica bloqueada.

## Prompt Recomendado

```text
HEPHAESTUS, ative o modo Real Project Execution.

Use .agents/config/project.yaml como fonte da verdade.
Primeiro produza um plano DryRun com arquivos planejados, verificacao de paths
protegidos, comandos a rodar, quality gates, riscos e impacto documental.
Nao aplique mudancas ate eu aprovar explicitamente o plano atual.
```

## Requisitos Para Apply

Apply so e permitido quando:

- o adapter esta pronto;
- `execution.mode` e `controlled`;
- existe um plano;
- backup e obrigatorio;
- paths protegidos estao livres;
- quality gates estao definidos ou explicitamente manuais;
- o operador aprova o plano atual.

## Saida

O framework escreve um Real Project Execution Status com:

- status;
- request;
- status do adapter;
- modo de execucao;
- arquivos planejados;
- conflitos com paths protegidos;
- status de backup e aprovacao;
- comandos e quality gates;
- riscos;
- impacto documental;
- proxima acao.

## Economia de Tokens

Este modo e condicional. Ele so e carregado quando execucao em projeto real for solicitada.










