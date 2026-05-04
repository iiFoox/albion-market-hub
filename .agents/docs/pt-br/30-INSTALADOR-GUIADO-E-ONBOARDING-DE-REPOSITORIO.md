# Instalador Guiado e Onboarding de Repositorio

> Versao do Framework: 8.7.0
> Idioma: Portugues (Brasil)
> Escopo: Instalacao guiada, intencao de repositorio e handoff da primeira chamada

---

## Objetivo

O instalador guiado ajuda o operador a instalar o HEPHAESTUS em projetos novos ou existentes, registrando a intencao de repositorio e deixando a primeira chamada dificil de esquecer.

## Modos de Repositorio

Escolha um:

| Modo | Significado |
|---|---|
| `none` | Nenhuma configuracao de repositorio foi planejada ainda. |
| `local` | Repositorio Git local pretendido. |
| `github` | Remote GitHub pretendido ou ja existente. |
| `gitlab` | Remote GitLab pretendido ou ja existente. |
| `bitbucket` | Remote Bitbucket pretendido ou ja existente. |
| `other` | Outro provider remoto pretendido. |
| `existing` | O projeto ja tem estado de repositorio que deve ser preservado. |

## Fluxo de Instalacao

1. Escolher a pasta do projeto.
2. Escolher o modo de repositorio.
3. Informar a URL remota quando existir.
4. Escolher a branch padrao.
5. Rodar dry-run primeiro.
6. Aplicar somente depois de revisar o plano.
7. Abrir `HEPHAESTUS-FIRST-CALL.md`.
8. Colar o prompt no assistente de IA.

## Projetos Novos

Para projetos novos, o HEPHAESTUS pode recomendar setup Git na primeira chamada, mas o instalador nao roda `git init`, adiciona remote, commita ou faz push automaticamente.

## Projetos Existentes

Para projetos existentes, o HEPHAESTUS deve tratar o estado do repositorio como pertencente ao projeto. A primeira chamada deve inspecionar branch, remote, paths protegidos e comandos locais organicamente antes de qualquer mudanca em config ativa.

## Arquivos Gerados

Depois do Apply install:

- `HEPHAESTUS-FIRST-CALL.md`
- `START-HEPHAESTUS.bat`
- `.agents/reports/operator/repository-setup-latest.md`

## Exemplo via CLI

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\MeuApp -RepositoryMode github -RemoteUrl https://github.com/exemplo/meuapp.git -DefaultBranch main -Apply
```
