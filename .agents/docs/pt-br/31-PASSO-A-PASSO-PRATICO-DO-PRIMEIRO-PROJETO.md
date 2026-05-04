# Passo a Passo Pratico do Primeiro Projeto

> Versao do Framework: 8.7.0
> Idioma: Portugues (Brasil)
> Escopo: Primeiro fluxo completo de projeto depois de instalar o HEPHAESTUS

---

## Objetivo

Use este guia ao iniciar seu primeiro projeto com o HEPHAESTUS. Ele cobre tanto um projeto novo vazio quanto um projeto existente que ja tem arquivos ou historico Git.

## Caminho A — Projeto Novo

1. Crie uma pasta vazia para o projeto.
2. Rode o instalador guiado.
3. Escolha o modo de repositorio: `none`, `local`, `github`, `gitlab`, `bitbucket`, `other` ou `existing`.
4. Revise o dry-run.
5. Aplique a instalacao apenas depois de confirmar a pasta destino.
6. Abra `HEPHAESTUS-FIRST-CALL.md` ou rode `START-HEPHAESTUS.bat`.
7. Cole o prompt da primeira chamada no Antigravity, Codex, Cursor, VS Code ou outro assistente de codigo com IA.
8. Peca ao HEPHAESTUS para rodar ou revisar o `bootstrap`.
9. Revise `.agents/reports/adapters/project-adapter-draft.yaml`.
10. Rode Project Discovery para historia do produto, usuarios, casos de uso, regras, custos, legal/IP e prontidao.
11. Confirme stack, estrategia de repositorio, paths protegidos e comandos permitidos.
12. Comece a implementacao somente depois de entender o adapter e os quality gates.

## Caminho B — Projeto Existente

1. Escolha a pasta do projeto existente.
2. Rode o instalador guiado primeiro em dry-run.
3. Se existir `.git`, preserve branch, remote e historico.
4. Aplique a instalacao apenas depois de confirmar que `.agents` ainda nao existe.
5. Abra `HEPHAESTUS-FIRST-CALL.md` ou rode `START-HEPHAESTUS.bat`.
6. Cole o prompt da primeira chamada no assistente de IA.
7. Peca ao HEPHAESTUS para inspecionar o projeto organicamente antes de mudar config.
8. Rode ou revise o `bootstrap`.
9. Revise o adapter draft sem copiar ainda para a config ativa.
10. Confirme comandos locais antes de marcar qualquer `allowed: true`.
11. Confirme paths protegidos antes de qualquer execucao Apply.
12. Use execucao DryRun-first para mudancas reais.

## Uso do Prompt da Primeira Chamada

O instalador cria `HEPHAESTUS-FIRST-CALL.md`. A instalacao so fica operacionalmente completa depois que esse prompt e colado no assistente de IA.

## Setup de Repositorio

O setup de repositorio e primeiro orientativo. O instalador registra a intencao de repositorio, mas nao roda `git init`, nao adiciona remote, nao muda branch, nao commita e nao faz push.

## Primeiros Comandos Uteis

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .
```

## Checklist de Prontidao Para Implementar

- `HEPHAESTUS-FIRST-CALL.md` foi colado no assistente de IA.
- Relatorio de bootstrap foi revisado.
- Adapter draft foi revisado.
- Project Discovery foi concluido ou adiado explicitamente com motivo.
- Estrategia de repositorio esta entendida.
- Paths protegidos estao confirmados.
- Comandos permitidos estao confirmados.
- DryRun e usado antes de Apply.

