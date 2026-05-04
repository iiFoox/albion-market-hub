# 📚 HEPHAESTUS Framework — Tutorial Completo

> **Versão:** 8.7.0 — Practical First Project Walkthrough  
> **Público:** Desenvolvedores usando o framework com Antigravity, Codex, ou qualquer LLM  
> **Idioma:** Português (pt-BR)

---

## Índice do Tutorial

### Fundamentos
| # | Arquivo | Conteúdo | Nível |
|---|---------|----------|-------|
| 01 | [Primeiros Passos](01-PRIMEIROS-PASSOS.md) | Setup, estrutura, primeiro uso | 🟢 Iniciante |
| 02 | [Economia de Tokens](02-ECONOMIA-DE-TOKENS.md) | Smart Loading, tiers, dicas práticas | 🟢 Iniciante |
| 03 | [Novo Chat e Retomada](03-NOVO-CHAT-RETOMADA.md) | Criar chat, retomar, salvar contexto | 🟢 Iniciante |

### Workflows por Nível
| # | Arquivo | Conteúdo | Nível |
|---|---------|----------|-------|
| 04 | [Fluxo Básico (LITE)](04-FLUXO-BASICO.md) | Quick fix, bugs simples, config | 🟢 Iniciante |
| 05 | [Fluxo Intermediário (STANDARD)](05-FLUXO-INTERMEDIARIO.md) | Features, CRUD, integrações | 🟡 Intermediário |
| 06 | [Fluxo Avançado (DEEP)](06-FLUXO-AVANCADO.md) | Arquitetura, migrações, refactors | 🟠 Avançado |
| 07 | [Fluxo Crítico (CRITICAL)](07-FLUXO-CRITICO.md) | Produção, financeiro, compliance | 🔴 Expert |
| 08 | [Fluxo UI/UX](08-FLUXO-UI-UX.md) | Telas, componentes, design system | 🟡 Intermediário |

### Operações Especiais
| # | Arquivo | Conteúdo | Nível |
|---|---------|----------|-------|
| 09 | [Correção de Erros](09-CORRECAO-DE-ERROS.md) | Debug, investigação, fix loop | 🟡 Intermediário |
| 10 | [Backup, Commits e Versionamento](10-BACKUP-COMMITS-VERSIONAMENTO.md) | Git, changelog, releases, backup | 🟢 Iniciante |
| 11 | [Evolução do Framework](11-EVOLUCAO-DO-FRAMEWORK.md) | Memory, learnings, auto-melhoria | 🟠 Avançado |
| 20 | [Wizard de Instalação e Update](20-WIZARD-DE-INSTALACAO-E-UPDATE.md) | Instalação/update seguro com dry-run, backup e validação | 🟢 Iniciante |
| 21 | [Prova Opcional de Telemetria e Memória](21-PROVA-OPCIONAL-DE-TELEMETRIA-E-MEMORIA.md) | Prova compacta de memória e retenção opcional | 🟠 Avançado |
| 22 | [Mapa de Experiência do Operador](22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md) | Mapa por intenção para escolher o guia certo | 🟢 Iniciante |
| 23 | [Barramento de Comunicação Entre Agentes](23-BARRAMENTO-DE-COMUNICACAO-ENTRE-AGENTES.md) | Mensagens compactas e auditáveis entre agentes | 🟠 Avançado |
| 24 | [CLI Unificado do Operador](24-CLI-UNIFICADO-DO-OPERADOR.md) | Comando único para operação comum do framework | 🟢 Iniciante |
| 25 | [Guarda de Deriva do Contrato Central](25-GUARDA-DE-DERIVA-DO-CONTRATO-CENTRAL.md) | Validação compacta do contrato central sempre carregado | 🟢 Iniciante |
| 26 | [Lancador Diario do Operador](26-LANCADOR-DIARIO-DO-OPERADOR.md) | Comandos por intencao e instalador Windows guiado | 🟢 Iniciante |
| 27 | [Assistente de Bootstrap de Projeto](27-ASSISTENTE-DE-BOOTSTRAP-DE-PROJETO.md) | Ponte inicial entre instalacao, Discovery e Adapter | 🟢 Iniciante |
| 28 | [Baseline de Estabilidade](28-BASELINE-DE-ESTABILIDADE.md) | Sentinela de regressao da superficie operacional estavel | 🟢 Iniciante |
| 29 | [Runbook e Recuperacao do Operador](29-RUNBOOK-E-RECUPERACAO-DO-OPERADOR.md) | Runbook compacto para operacao diaria e recuperacao depois de falhas de gate | 🟢 Iniciante |
| 30 | [Instalador Guiado e Onboarding de Repositorio](30-INSTALADOR-GUIADO-E-ONBOARDING-DE-REPOSITORIO.md) | Instalacao guiada com modo de repositorio e handoff da primeira chamada | 🟢 Iniciante |
| 31 | [Passo a Passo Pratico do Primeiro Projeto](31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md) | Uso passo a passo do primeiro projeto novo ou existente | 🟢 Iniciante |

### Exemplos de Prompts (Few-Shot)
| # | Arquivo | Conteúdo |
|---|---------|----------|
| P1 | [Self-Evaluation Examples](prompts/SELF-EVALUATION-EXAMPLES.md) | YES, NO, STANDBY com justificativas reais |
| P2 | [Handoff Examples](prompts/HANDOFF-EXAMPLES.md) | Handoffs perfeitos vs. rejeitados |
| P3 | [Conflict Resolution Examples](prompts/CONFLICT-RESOLUTION-EXAMPLES.md) | Resolução com evidência |
| P4 | [Triage Examples](prompts/TRIAGE-EXAMPLES.md) | CRITICAL, RELEVANT, OPTIONAL, NOT_NEEDED |
| P5 | [Chain-of-Thought Examples](prompts/CHAIN-OF-THOUGHT-EXAMPLES.md) | Raciocínio passo a passo |
| P6 | [Prompts Prontos para Copiar](prompts/PROMPTS-PRONTOS.md) | Templates prontos para uso imediato |

### Referência Completa
| # | Arquivo | Conteúdo |
|---|---------|----------|
| REF | [HEPHAESTUS Complete Reference](HEPHAESTUS-COMPLETE-REFERENCE.md) | Documento completo do framework |

---

## Como usar este tutorial

1. **Se vai instalar ou atualizar:** Leia `20-WIZARD-DE-INSTALACAO-E-UPDATE.md`
2. **Se é sua primeira vez:** Leia `01-PRIMEIROS-PASSOS.md` e `02-ECONOMIA-DE-TOKENS.md`
3. **Se vai fazer uma tarefa simples:** Vá direto para `04-FLUXO-BASICO.md`
4. **Se precisa do prompt pronto:** Vá para `prompts/PROMPTS-PRONTOS.md`
5. **Se quer entender o framework completo:** Leia `HEPHAESTUS-COMPLETE-REFERENCE.md`
6. **Se está debugando:** Vá para `09-CORRECAO-DE-ERROS.md`










