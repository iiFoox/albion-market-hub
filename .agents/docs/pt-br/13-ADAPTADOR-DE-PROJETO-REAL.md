# 13 — Adaptador de Projeto Real

> Versao do Framework: 8.0.0
> Proposito: configurar o HEPHAESTUS para entender um projeto local real com seguranca.

---

## O Que Este Modo Faz

O Adaptador de Projeto Real informa ao HEPHAESTUS como um repositorio especifico funciona antes de planejar mudancas, rodar comandos ou preparar execucao em projeto real.

A fonte da verdade e:

```text
.agents/config/project.yaml
```

## Por Que Existe

Projetos diferentes possuem comandos, stacks, arquivos protegidos, diretorios gerados, estrategias de teste e regras de seguranca diferentes.

Sem adapter, um agente pode inferir errado. Com adapter, o HEPHAESTUS opera a partir de regras locais explicitas.

## O Que Configurar

| Secao | Proposito |
|---|---|
| `project` | Identidade, root, profile, maturidade e descricao |
| `stack` | Linguagens, frameworks, runtime, bancos, package manager e plataformas |
| `commands` | Comandos permitidos de install, test, lint, build, format e dev |
| `paths.source` | Paths de codigo que o framework pode inspecionar ou modificar |
| `paths.tests` | Paths de testes |
| `paths.docs` | Paths de documentacao |
| `paths.generated` | Paths gerados que normalmente nao devem ser editados manualmente |
| `paths.protected` | Paths que exigem aprovacao explicita antes de mudancas |
| `execution` | Regras de analysis-only, dry-run ou controlled execution |
| `quality_gates` | Validacoes obrigatorias, opcionais ou manuais |

## Padrao Seguro

O modo padrao do adapter e:

```yaml
execution:
  mode: "analysis_only"
  require_plan_before_changes: true
  require_approval_before_apply: true
  backup_before_mutation: true
  allow_destructive_commands: false
```

Isso significa que o HEPHAESTUS pode inspecionar e raciocinar, mas nao deve tratar o projeto real como territorio mutavel ate que o adapter seja configurado de forma intencional.

## Prompt Recomendado

```text
HEPHAESTUS, ative o modo Real Project Adapter.

Leia .agents/config/project.yaml, valide o adapter, liste campos faltantes,
identifique paths protegidos, confirme comandos permitidos e me diga se o
projeto esta pronto para trabalho controlado.
Nao modifique arquivos do projeto ainda.
```

## Status de Prontidao

O adapter deve reportar um destes status:

| Status | Significado |
|---|---|
| `ready` | Campos obrigatorios configurados e trabalho controlado pode ser planejado |
| `partial` | Alguns campos faltando; usar analysis-only ou dry-run |
| `missing` | Adapter nao configurado |
| `unsafe` | Configuracao permite risco ou falta limites de seguranca |

## Economia de Tokens

O contexto de adapter e condicional. Ele so e carregado quando estamos trabalhando com configuracao de projeto real ou preparando execucao controlada.











