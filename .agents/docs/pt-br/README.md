# HEPHAESTUS Framework — Documentacao em Portugues

> Versao do Framework: 8.7.0
> Idioma: Portugues (Brasil)
> Escopo: Documentacao completa de uso para usuario

---

## Comece Aqui

| # | Arquivo | Tema |
|---|---|---|
| 00 | [Visao Geral](00-OVERVIEW.md) | Indice e porta de entrada do framework |
| 00A | [Prompt de Ativacao](00-ACTIVATION-PROMPT.md) | Prompt usado para ativar o HEPHAESTUS no LLM hospedeiro |
| 01 | [Primeiros Passos](01-PRIMEIROS-PASSOS.md) | Setup, onboarding e primeiro uso |
| 02 | [Economia de Tokens](02-ECONOMIA-DE-TOKENS.md) | Smart Loading e otimizacao de contexto |
| 03 | [Novo Chat e Retomada](03-NOVO-CHAT-RETOMADA.md) | Continuidade entre sessoes |
| 04 | [Fluxo Basico](04-FLUXO-BASICO.md) | Tarefas LITE e correcoes simples |
| 05 | [Fluxo Intermediario](05-FLUXO-INTERMEDIARIO.md) | Tarefas STANDARD, features e mudancas multi-arquivo |
| 06 | [Fluxo Avancado](06-FLUXO-AVANCADO.md) | Tarefas DEEP, arquitetura e refactors |
| 07 | [Fluxo Critico](07-FLUXO-CRITICO.md) | Tarefas CRITICAL, producao, seguranca e compliance |
| 08 | [Fluxo UI/UX](08-FLUXO-UI-UX.md) | Interfaces, acessibilidade e revisao visual |
| 09 | [Correcao de Erros](09-CORRECAO-DE-ERROS.md) | Debug, investigacao e loops de correcao |
| 10 | [Backup, Commits e Versionamento](10-BACKUP-COMMITS-VERSIONAMENTO.md) | Git, changelog, releases e versionamento |
| 11 | [Evolucao do Framework](11-EVOLUCAO-DO-FRAMEWORK.md) | Memoria, aprendizado, telemetria e melhoria continua |
| 12 | [Descoberta de Projeto](12-DESCOBERTA-DE-PROJETO.md) | Maturacao de requisitos antes da implementacao |
| 13 | [Adaptador de Projeto Real](13-ADAPTADOR-DE-PROJETO-REAL.md) | Stack, comandos, paths e gates locais do projeto |
| 14 | [Execucao em Projeto Real](14-EXECUCAO-EM-PROJETO-REAL.md) | Execucao controlada DryRun-first em projeto local real |
| 15 | [Comandos e Quality Gates](15-COMANDOS-E-QUALITY-GATES.md) | Allowlist segura de comandos do adaptador e runner de quality gates |
| 16 | [Cenario de Apply em Projeto Real](16-CENARIO-DE-APPLY-EM-PROJETO-REAL.md) | Validacao isolada DryRun-to-Apply com quality gates, backup, auditoria e restore |
| 17 | [Loop de Documentacao em Runtime](17-LOOP-DE-DOCUMENTACAO-RUNTIME.md) | Loop de impacto documental por caminhos alterados com evidencia compacta |
| 18 | [Pacote de Evidencias de Release](18-PACOTE-DE-EVIDENCIAS-DE-RELEASE.md) | Indice compacto de auditoria de release para gates, pacote, docs e cenarios |
| 19 | [Revisao de Nota Operacional](19-REVISAO-DE-NOTA-OPERACIONAL.md) | Nota final, riscos residuais e revisao de economia de tokens |
| 20 | [Wizard de Instalacao e Update](20-WIZARD-DE-INSTALACAO-E-UPDATE.md) | Fluxo guiado de instalacao/update com dry-run, backup e validacao |
| 21 | [Prova Opcional de Telemetria e Memoria](21-PROVA-OPCIONAL-DE-TELEMETRIA-E-MEMORIA.md) | Prova compacta de consulta de memoria e retencao opcional de telemetria |
| 22 | [Mapa de Experiencia do Operador](22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md) | Navegacao por intencao para primeiro uso, projeto real, validacao e release |
| 23 | [Barramento de Comunicacao Entre Agentes](23-BARRAMENTO-DE-COMUNICACAO-ENTRE-AGENTES.md) | Handoffs, consultas, conflitos, decisoes e correcoes auditaveis |
| 24 | [CLI Unificado do Operador](24-CLI-UNIFICADO-DO-OPERADOR.md) | Um ponto seguro de comando para doctor, validate, gate, package, evidence, install e update |
| 25 | [Guarda de Deriva do Contrato Central](25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md) | Validacao compacta que mantem o contrato sempre carregado atual e economico em tokens |
| 26 | [Lancador Diario do Operador](26-LANCADOR-DIARIO-DO-OPERADOR.md) | Comandos diarios por intencao e um lancador Windows de primeira instalacao |
| 27 | [Assistente de Bootstrap de Projeto](27-ASSISTENTE-DE-BOOTSTRAP-DE-PROJETO.md) | Primeira ponte de prontidao entre instalacao, Discovery e Adapter |
| 28 | [Baseline de Estabilidade](28-BASELINE-DE-ESTABILIDADE.md) | Sentinela de regressao da superficie operacional estavel |
| 29 | [Runbook e Recuperacao do Operador](29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md) | Runbook compacto para operacao diaria e recuperacao depois de falhas de gate |
| 30 | [Instalador Guiado e Onboarding de Repositorio](30-INSTALADOR-GUIADO-E-ONBOARDING-DE-REPOSITORIO.md) | Instalacao guiada com modo de repositorio e handoff da primeira chamada |
| 31 | [Passo a Passo Pratico do Primeiro Projeto](31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md) | Uso passo a passo do primeiro projeto novo ou existente |
| REF | [Referencia Completa](HEPHAESTUS-COMPLETE-REFERENCE.md) | Referencia completa de capacidades e arquitetura |

## Exemplos de Prompts

| Arquivo | Uso |
|---|---|
| [Prompts Prontos](prompts/PROMPTS-PRONTOS.md) | Prompts prontos para copiar |
| [Self-Evaluation Examples](prompts/SELF-EVALUATION-EXAMPLES.md) | Calibragem de participacao dos agentes |
| [Triage Examples](prompts/TRIAGE-EXAMPLES.md) | Exemplos de classificacao e roteamento |
| [Handoff Examples](prompts/HANDOFF-EXAMPLES.md) | Exemplos de transferencia entre agentes |
| [Conflict Resolution Examples](prompts/CONFLICT-RESOLUTION-EXAMPLES.md) | Resolucao estruturada de divergencias |
| [Chain-of-Thought Examples](prompts/CHAIN-OF-THOUGHT-EXAMPLES.md) | Exemplos de raciocinio estruturado |

## Guias de Uso Diario

| Arquivo | Uso |
|---|---|
| [Guia de Uso Diario](daily-prompts/README.md) | Rotina pratica, prompts de retomada e encerramento |

## Politica de Idioma

O nucleo operacional do framework continua em ingles: definicoes tecnicas, agentes, protocolos, configuracoes, prompts internos e memoria. Esta pasta existe para uso, estudo e onboarding em portugues.





