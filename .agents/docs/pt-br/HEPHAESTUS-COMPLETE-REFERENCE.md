# HEPHAESTUS Agent Framework — Referência Completa

> **Versão:** 8.7.0 — Practical First Project Walkthrough  
> **Criado por:** Framework auto-evolutivo  
> **Última atualização:** 2026-04-23  
> **Propósito:** Documentação exaustiva de todas as capacidades, componentes, e funcionamento do framework

---

## Sumário

1. [Visão Geral](#1-visão-geral)
2. [Arquitetura do Framework](#2-arquitetura-do-framework)
3. [Os 10 Agentes](#3-os-10-agentes)
4. [Sistema de Memória](#4-sistema-de-memória)
5. [Protocolos Operacionais](#5-protocolos-operacionais)
6. [Workflows](#6-workflows)
7. [Profiles de Indústria/Stack](#7-profiles)
8. [Knowledge Base](#8-knowledge-base)
9. [Sistema de Telemetria](#9-sistema-de-telemetria)
10. [Economia de Tokens](#10-economia-de-tokens)
11. [Evolução Contínua](#11-evolução-contínua)
12. [Tutorial Completo](#12-tutorial-completo)
13. [Histórico de Versões](#13-histórico-de-versões)
14. [Métricas e Capacidades](#14-métricas-e-capacidades)

---

## 1. Visão Geral

### O que é

O **HEPHAESTUS** é um framework de multi-agentes que transforma qualquer LLM (Antigravity, Codex, ChatGPT, Claude, Gemini) em um **time completo de engenharia de software**. Ele fornece 10 agentes especializados que operam com expertise de nível sênior/arquiteto, comunicam-se entre si, aprendem com cada interação, e evoluem continuamente.

### O que NÃO é

- ❌ Não é um chatbot genérico
- ❌ Não é uma coleção de prompts avulsos
- ❌ Não é um gerador de boilerplate
- ❌ Não substitui o desenvolvedor — amplifica

### Princípios Fundamentais

| # | Princípio | Descrição |
|---|----------|-----------|
| 1 | **Expert-Level by Default** | Cada agente opera em nivel master, com 30+ anos equivalentes de expertise cruzada |
| 2 | **Memory-Driven Evolution** | O framework aprende e melhora a cada uso |
| 3 | **Collaborative Intelligence** | Agentes consultam e debatem entre si |
| 4 | **Self-Evaluation Mandate** | Todo agente avalia se deve participar, sempre |
| 5 | **Token Efficiency** | Smart Loading garante uso mínimo de contexto |
| 6 | **Host Cooperation** | Coopera com a ferramenta hospedeira, nunca compete |
| 7 | **Continuous Documentation** | Documentação é automática e first-class |
| 8 | **Quality Non-Negotiable** | Validator é gate obrigatório, nunca pulado |

### Números do Framework

| Métrica | Valor |
|---------|-------|
| Agentes especialistas | 10 |
| Sistemas compartilhados | 1 (Memória) |
| Protocolos operacionais | 36 |
| Workflows | 12 |
| Profiles de indústria/stack | 7 |
| Prompts operacionais | 40+ |
| Idiomas de documentação | 2 (EN/PT-BR) |
| Níveis de complexidade | 4 (LITE/STANDARD/DEEP/CRITICAL) |
| Tiers de loading | 4 |
| Escalation triggers | 12 |
| Tech cards | 14 |
| Architecture patterns | 8 |
| Security knowledge bases | 4 |
| Total de arquivos | ~175 |

---

## 2. Arquitetura do Framework

### Diagrama Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    HEPHAESTUS v8.7.0                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              ORCHESTRATOR (Router)                    │  │
│  │  Classify → Triage → Route → Monitor → Deliver       │  │
│  └──────────────────────┬───────────────────────────────┘  │
│                         │                                   │
│  ┌──────────────────────▼───────────────────────────────┐  │
│  │                 AGENT PIPELINE                        │  │
│  │                                                       │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐              │  │
│  │  │Researcher│→│ Planner  │→│ Builder  │              │  │
│  │  └──────────┘ └──────────┘ └────┬─────┘              │  │
│  │                                  │                    │  │
│  │  ┌──────────┐ ┌──────────┐ ┌────▼─────┐              │  │
│  │  │  UI/UX   │←│ Platform │←│Validator │              │  │
│  │  │Specialist│ │ Guardian │ │          │              │  │
│  │  └──────────┘ └──────────┘ └──────────┘              │  │
│  │                                                       │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐              │  │
│  │  │  Docs    │ │    PM    │ │ Delivery │              │  │
│  │  └──────────┘ └──────────┘ └──────────┘              │  │
│  └──────────────────────────────────────────────────────┘  │
│                         │                                   │
│  ┌──────────────────────▼───────────────────────────────┐  │
│  │               MEMORY SYSTEM                           │  │
│  │  Knowledge Graph │ Learning Store │ Evolution │ Context│  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              PROTOCOLS (12)                           │  │
│  │  Smart Loading │ Triage │ Complexity │ Auto-Escal │..│  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              PROFILES (7)                             │  │
│  │  Flutter │ Fintech │ Healthcare │ E-comm │ ...       │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              KNOWLEDGE BASE                          │  │
│  │  Tech Cards │ Arch Patterns │ Security │ DB Playbook │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Estrutura de Diretórios

```
.agents/
├── AGENTS.md                    ← Master definition
├── ROADMAP.md                   ← Evolution roadmap
├── docs/                        ← 📚 DOCUMENTACAO OFICIAL BILINGUE
│   ├── en/                      ← Documentacao completa em ingles
│   └── pt-br/                   ← Documentacao completa em portugues
│   ├── 00-OVERVIEW.md
│   ├── 01 a 11 — Guias por nível
│   └── prompts/ — 6 arquivos de examples
├── config/
│   ├── framework.yaml           ← Global config + profiles ativos
│   ├── agent-registry.yaml      ← Registry dos 10 agentes
│   ├── complexity-routing.yaml  ← Regras LITE/STANDARD/DEEP/CRITICAL
│   ├── triage-rules.yaml        ← Critérios de triage
│   ├── maturity-profiles.yaml   ← Perfis de maturidade
│   └── framework-manifest.yaml
├── agents/                      ← 10 agentes com prompts individuais
│   ├── orchestrator/            ← 4 prompts (request-analysis, self-eval, pipeline, conflict)
│   ├── researcher/              ← 5 prompts (system, context-analysis, tech-research, deep, self-eval)
│   ├── planner/                 ← 5 prompts (system, task-decomp, arch-decision, deep, self-eval)
│   ├── builder/                 ← 7 prompts (system, code-gen, refactoring, review, platform, deep, self-eval)
│   ├── ui-ux-specialist/        ← 5 prompts + capabilities (system, design-review, deep, self-eval)
│   ├── platform-guardian/       ← 5 prompts + capabilities + known-issues DB
│   ├── validator/               ← 7 prompts + playbooks (system, test-gen, security, quality, regression, deep, self-eval)
│   ├── documentation/           ← 4 prompts (system, api-docs, changelog, self-eval)
│   ├── project-manager/         ← 5 prompts (system, sprint, evolution, deep, self-eval)
│   └── delivery/                ← 5 prompts (system, commit-assess, release, bootstrap, self-eval)
├── profiles/
│   ├── flutter-multiplatform/   ← 5 docs (arch, UI, checklist, packages, testing)
│   ├── fintech/
│   ├── healthcare/
│   ├── e-commerce/
│   ├── realtime/
│   └── ai-ml/
├── protocols/                   ← 24 protocolos
├── memory/                      ← 4 subsistemas evolutivos
├── knowledge/                   ← Base de conhecimento pré-carregada
├── telemetry/                   ← Sistema de métricas
├── workflows/                   ← 10 workflows
├── benchmarks/                  ← Suite de benchmark
├── daily-prompts/               ← Ponte legada para docs/pt-br/daily-prompts/
└── global/                      ← Standards organizacionais
```

---

## 3. Os 10 Agentes

### 3.1 Orchestrator (Router Inteligente)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Roteia requests, monta pipelines, resolve conflitos |
| **Always Active** | ✅ Sim — participa de tudo |
| **Expertise** | Architect level |
| **Capacidades** | Classificação rápida (<5s), triage coordination, **auto-escalation check**, pipeline assembly, conflict resolution, delta loading, direct help |
| **Motto** | "Menor pipeline que entrega qualidade" |
| **v4.0.0 Change** | Refatorado de "controlador central" para "router leve e cooperativo" |
| **v4.0.1 Change** | Adicionado Auto-Escalation Check com 12 triggers e delta loading |

### 3.2 Researcher (Inteligência de Contexto)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Pesquisa, análise de contexto, avaliação de risco |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior Specialist |
| **Capacidades** | Context mapping, technology research, dependency analysis, risk assessment, feasibility analysis |
| **Quando ativa** | Features novas, tech decisions, architecture, complex bugs |

### 3.3 Planner (Arquiteto Estratégico)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Decompõe tarefas, planeja execução, define critérios de aceite |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior Architect |
| **Capacidades** | Task decomposition, strategy design, acceptance criteria, trade-off analysis, rollback planning |
| **Quando ativa** | Multi-step tasks, architecture, complex features, migrations |

### 3.4 Builder (Engenheiro de Implementação)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Implementa código, refatora, gerencia versão |
| **Always Active** | ❌ Sob demanda (mas quase sempre ativo) |
| **Expertise** | Senior Engineer |
| **Capacidades** | Code generation, multi-language, cross-platform, refactoring, Git management |
| **Absorbed** | Versioning Agent |

### 3.5 UI/UX Specialist (Arquiteto Visual) — **NOVO v4.0.0**
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Design tokens, responsividade, acessibilidade, revisão visual |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior UX Architect |
| **Capacidades** | Design token enforcement, responsive/adaptive design, accessibility auditing (WCAG 2.1), component architecture, visual performance, animation guidelines |
| **Quando ativa** | Novas telas, mudanças visuais, themes, componentes, dark mode |
| **Pipeline Position** | Após Builder, antes do Platform Guardian |

### 3.6 Platform Guardian (Gate de Compatibilidade) — **NOVO v4.0.0**
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Verificar compatibilidade cross-platform |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior Platform Engineer |
| **Capacidades** | Package verification, platform API audit, conditional imports, build config check, known issues database |
| **Quando ativa** | Novos packages, dart:io/dart:html usage, build changes, platform-specific features |
| **Pipeline Position** | Após UI/UX Review, antes do Validator |

### 3.7 Validator (QA Architect)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Testa, audita segurança, verifica qualidade |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior QA Architect |
| **Capacidades** | Test generation, quality gates, security audit (OWASP), regression detection, performance validation |
| **Rule** | NUNCA pular — é o gate obrigatório |

### 3.8 Documentation (Technical Writer Architect)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Documenta automaticamente, changelog, API docs, ADR |
| **Always Active** | ✅ Sim — participa de tudo |
| **Expertise** | Technical Writer Architect |
| **Capacidades** | Auto-docs, API reference, changelog, ADR, README, diagrams, migration guides |

### 3.9 Project Manager (PM & Analyst)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Métricas, telemetria, evolução, scope management |
| **Always Active** | ✅ Sim — participa de tudo |
| **Expertise** | Senior PM & Analyst |
| **Capacidades** | Telemetry, performance metrics, evolution monitoring, tech debt tracking, growth metrics |
| **Absorbed** | Telemetry Agent, Performance Analysis Agent |

### 3.10 Delivery (Release Engineer)
| Aspecto | Detalhe |
|---------|---------|
| **Role** | Commit, versioning, release, sync |
| **Always Active** | ❌ Sob demanda |
| **Expertise** | Senior DevOps Engineer |
| **Capacidades** | Repository bootstrap, commit assessment (Commit Gate), Conventional Commits, SemVer, changelog, release tags, sync |

---

## 4. Sistema de Memória

O HEPHAESTUS possui **4 subsistemas de memória** que permitem aprendizado contínuo:

### 4.1 Knowledge Graph
- **O que armazena:** Padrões técnicos, relações entre tecnologias, compatibilidades
- **Exemplo:** "drift é a melhor opção para SQL cross-platform em Flutter"
- **Cresce com:** Cada decisão técnica tomada

### 4.2 Learning Store
- **O que armazena:** O que funcionou, o que falhou, e por quê
- **Exemplo:** "Usar sqflite para Web causou crash — mudar para drift"
- **Cresce com:** Feedback do usuário + resultados de pipelines

### 4.3 Evolution Log
- **O que armazena:** Como o framework cresceu ao longo do tempo
- **Exemplo:** "v4.0.0: adicionados UI/UX Specialist + Platform Guardian"
- **Cresce com:** Cada mudança no framework

### 4.4 Context DB
- **O que armazena:** Estado atual do projeto (o que foi feito, o que falta)
- **Exemplo:** "Tela de login: pronta. Tela de perfil: em andamento"
- **Cresce com:** Cada session checkpoint

---

## 5. Protocolos Operacionais

| # | Protocolo | Função | Quando executa |
|---|----------|--------|----------------|
| 1 | **Smart Loading** | Carrega apenas arquivos necessários por tier | ANTES de tudo |
| 2 | **Adaptive Complexity** | Classifica complexidade (LITE→CRITICAL) | Na classificação |
| 3 | **Universal Triage** | Todos agentes avaliam participação | Após classificação |
| 4 | **Auto-Escalation** | Escala nível + delta load automático | **Após triage** |
| 5 | **Self-Evaluation** | Cada agente decide se participa | Durante triage |
| 6 | **Collaboration** | Formato de cooperacao entre agentes | Durante pipeline |
| 7 | **Handoff** | Transferencia de trabalho entre agentes | Entre fases |
| 8 | **Documentation Enforcement** | Mantem documentacao alinhada via checkpoint leve | Em todo pipeline |
| 9 | **Memory Consultation** | Consulta de memoria por trigger e tier | Quando memoria for relevante |
| 10 | **Commit Gate** | Avaliar se merece commit | Antes de commitar |
| 11 | **Evolution** | Registrar aprendizados | Apos pipeline |
| 12 | **Memory Governance** | Regras de escrita/leitura na memoria | Acesso a memoria |
| 13 | **Project Discovery** | Amadurece ideia, requisitos, custos, legal/IP, Git e prontidao | Inicio de projeto ou mudanca de direcao |
| 14 | **Session Closing** | Captura estado ao encerrar sessao | Fim de sessao |
| 15 | **Session Handoff** | Retomada em novo chat | Novo chat |
| 16 | **Real Project Adapter** | Le stack, comandos, paths protegidos, modo de execucao e gates do projeto | Trabalho em repositorio real |
| 17 | **Real Project Execution** | Gera plano DryRun-first com backup, aprovacao, paths protegidos e quality gates | Execucao controlada em projeto real |
| 18 | **Real Project Execution Hardening** | Valida Apply controlado, backup, auditoria, override de path protegido e restore | Hardening de execucao real |
| 19 | **Command Allowlist and Quality Gates** | Executa apenas comandos permitidos no adaptador e bloqueia padroes destrutivos | Testes, lint, build e validacao local |
| 20 | **Real Project Apply Scenario** | Prova DryRun-to-Apply em fixture isolada com quality gates antes/depois, backup, auditoria e restore | Validacao end-to-end de Apply |
| 21 | **Documentation Runtime Loop** | Converte caminhos alterados em decisao de impacto documental e evidencia compacta | Mudancas de projeto com impacto em docs |
| 22 | **Release Evidence Bundle** | Consolida evidencias de release, pacote, docs, quality gates e cenarios em um indice compacto | Auditoria de release |
| 23 | **Operational Score Review** | Resume nota, riscos residuais, economia de tokens e prontidao de release | Revisao operacional |
| 24 | **Install and Update Wizard** | Guia instalacao/update seguro com dry-run, backup, preservacao local e validacao | Setup, instalacao ou update |
| 25 | **Optional Telemetry and Memory Proof** | Prova compacta de memoria, schema, retencao dry-run e evidencia sem expansao de sessao normal | Release, auditoria ou prova de memoria |
| 26 | **Final Operator Experience Review** | Mantem mapa por intencao, prompts prontos e pontes legadas alinhados | Revisao de experiencia do operador |
| 27 | **Inter-Agent Communication Bus** | Registra mensagens compactas e auditaveis para handoffs, consultas, conflitos, decisoes, alertas e correcoes | Coordenacao e auditoria entre agentes |
| 28 | **Unified Operator CLI** | Centraliza doctor, validate, gate, package, evidence, install e update em um comando seguro | Operacao do framework |
| 29 | **Core Contract Drift Guard** | Mantem o contrato central compacto, atual, alinhado por versao e validado em release | Antes de release e ao editar o core |
| 30 | **Operator Daily Launcher** | Oferece comandos diarios por intencao e instalador Windows com prompt inicial gerado | Inicio de trabalho, validacao, release e instalacao |
| 31 | **Project Bootstrap Assistant** | Conecta primeira instalacao com Project Discovery e Real Project Adapter sem alterar config ativa | Primeiro preparo de projeto |
| 32 | **Stability Baseline** | Verifica se a superficie operacional estavel nao regrediu entre releases | Pre-release e auditoria operacional |
| 33 | **Operator Runbook and Recovery** | Orienta operacao diaria e recuperacao depois de falhas de validacao, gate, pacote, instalacao ou update | Operacao e recuperacao |
| 34 | **Guided Installer and Repository Onboarding** | Registra intencao de repositorio e cria handoff da primeira chamada depois da instalacao guiada | Instalacao e onboarding |
| 35 | **Practical First Project Walkthrough** | Guia o operador no primeiro uso real em projeto novo ou existente | Primeiro projeto |
| 36 | **Versioning** | SemVer + Conventional Commits | No commit |

---

## 6. Workflows

| Workflow | Complexidade | Agentes | Use Case |
|----------|-------------|---------|----------|
| **Full Pipeline** | STANDARD-CRITICAL | Todos 10 | Features, arquitetura, mudanças grandes |
| **Quick Fix** | LITE | 2-3 + opcionais | Bug fix, typo, config |
| **Research Only** | STANDARD | 2-3 | Análise de tecnologia, feasibility |
| **Review Only** | STANDARD | 3-4 | Code review, audit |
| **UI Workflow** | STANDARD | 5-6 | Telas, componentes, design system |
| **Project Discovery** | DEEP | 6-8 | Maturacao de ideia, MVP, backend, custos, riscos, legal/IP, Git |
| **Real Project Adapter** | STANDARD-DEEP | 5-7 | Adapter local, comandos, paths protegidos, quality gates e modo de execucao |
| **Real Project Execution** | DEEP | 6-8 | Plano DryRun-first, backup, aprovacao, Apply controlado e validacao |

---

## 7. Profiles

### Flutter Multi-Platform (ATIVO por padrão)
| Documento | Conteúdo |
|-----------|----------|
| architecture.md | Estrutura por tamanho (S/M/L), rules, state management, DI |
| ui-standards.md | Design tokens (cores, tipografia, espaçamento, radius, elevação) |
| platform-checklist.md | 56 checks (Android 10 + Windows 12 + Web 14 + iOS 10 + Cross 10) |
| packages-compatibility.md | 40+ packages com suporte por plataforma |
| testing-strategy.md | Pirâmide de testes, golden tests, platform-specific tests |

### Industry Profiles (6)
| Profile | Foco |
|---------|------|
| Fintech | PCI-DSS, LGPD, auditoria financeira, double-entry accounting |
| Healthcare | HIPAA, HL7 FHIR, dados sensíveis, audit trails |
| E-Commerce | Pagamentos, catálogo, carrinho, fulfillment |
| Real-Time | WebSocket, streaming, presence, reconexão |
| AI/ML | Model serving, feature stores, experiment tracking |

---

## 8. Knowledge Base

### Tech Cards (14)
Fichas técnicas detalhadas de tecnologias:
- Backend: Node.js 22, Python 3.13, Go 1.23, .NET 9
- Frontend: React 19, Next.js 15, TypeScript 5
- Mobile: Flutter 3.26, React Native 0.76
- Databases: PostgreSQL 17, MongoDB 8, Redis 8
- DevOps: Docker, GitHub Actions

### Architecture Patterns (8)
Padrões arquiteturais com decision tree:
Clean, Hexagonal, DDD, CQRS/Event Sourcing, Microservices, Modular Monolith, Event-Driven, Serverless

### Security Knowledge (4)
- OWASP Top 10 com exemplos
- Auth patterns (JWT, OAuth, SAML)
- API Security
- LGPD/GDPR compliance

### Other
- Database Playbook (escolha, modelagem, performance)
- Observability Guide (logs, metrics, traces)
- Resilience Patterns (circuit breaker, retry, bulkhead)
- Anti-Pattern Registry (36 categorias)
- Incident Archetypes (padrões de incidentes conhecidos)

---

## 9. Sistema de Telemetria

Logs estruturados de toda execução:

| Event | O que registra |
|-------|---------------|
| `pipeline.started` | Início de pipeline com agents e complexity |
| `pipeline.completed` | Fim com duração, resultado, metrics |
| `triage.completed` | Respostas de triage de todos agentes |
| `escalation.applied` | Auto-escalação aplicada (de→para, trigger) |
| `escalation.delta_loaded` | Arquivos extras carregados no delta |
| `escalation.skipped` | Escalação avaliada mas não necessária |
| `conflict.detected` | Conflito entre agentes |
| `conflict.resolved` | Como foi resolvido |
| `memory.updated` | O que foi salvo na memória |
| `commit.created` | Commit com mensagem, version, hash |

---

## 10. Economia de Tokens

### Smart Loading — 4 Tiers

| Tier | Arquivos | Contexto economizado | Melhor para |
|------|----------|---------------------|-------------|
| LITE | ~8-10 | ~75-80% | Bug fix, config |
| STANDARD | ~22-28 | ~55-60% | Features |
| DEEP | ~50-55 | ~30-35% | Arquitetura |
| CRITICAL | ~90+ | ~5-10% | Produção |

### Como funciona:
1. Request chega → Orchestrator classifica nível (keywords)
2. Smart Loading carrega APENAS os arquivos daquele tier
3. Triage: todos os agentes avaliam participação (~100 palavras)
4. **Auto-Escalation Check:** 12 triggers verificados
   - Se trigger dispara → **Delta Load** (carrega SÓ os extras)
   - Se não → continua no nível atual
5. Pipeline executa com contexto otimizado
6. NUNCA carrega tudo de uma vez (exceto CRITICAL)

### Delta Loading (v4.0.1)
Quando o framework escala (ex: LITE→STANDARD), ele carrega **apenas a diferença**:

| Escalação | Delta (arquivos extras) | Total final |
|-----------|------------------------|-------------|
| LITE → STANDARD | +14-18 arquivos | ~22-28 |
| STANDARD → DEEP | +25-30 arquivos | ~50-55 |
| DEEP → CRITICAL | +35+ arquivos | ~90+ |

> Arquivos já carregados NUNCA são recarregados. Zero desperdício.

---

## 11. Evolução Contínua

### Ciclo de evolução:
```
Uso → Resultado → Feedback → Memory Update → Melhor decisão próxima vez
```

### Métricas de evolução:
- Decisões reutilizadas da memória
- Erros repetidos (meta: zero)
- Pipeline accuracy (agentes certos na 1ª tentativa)
- Fix loops (Builder↔Validator, meta: < 2)
- Cobertura de testes (meta: > 80%)

### Versões do Framework:
```
v1.0.0 Foundation → v1.5.0 Expert Prompts → v2.0.0 Advanced Knowledge
→ v2.5.0 Specialist Patterns → v3.0.0 Enterprise Grade
→ v3.5.0 Operational Intelligence → v3.6.0 Context Optimization
→ v5.x Enforcement and validation → v6.0 Kernel Stabilization
→ v6.6.0 Project Discovery and Requirements Maturation
→ v6.7.0 Real Project Adapter
→ v6.8.0 Developer Execution on Real Local Project
→ v6.9.0 Benchmark Expansion
→ v7.0.0 Real Project Execution Hardening
→ v7.1.0 Command Allowlist and Quality Gate Runner
→ v7.2.0 Real Project Apply Scenario
→ v7.3.0 Documentation Agent Runtime Loop
→ v7.4.0 Release Evidence Bundle
→ v7.5.0 Operational Polish and Score Review
→ v7.6.0 Install and Update Wizard
→ v7.7.0 Optional Telemetry and Memory Proof
→ v7.8.0 Final Operator Experience Review
→ v7.9.0 Real Inter-Agent Communication Bus
→ v8.0.0 Unified Operator CLI and Doctor
→ v8.1.0 Core Contract Alignment and Drift Guard
→ v8.2.0 Operator Daily Launcher and First-Call Installer
→ v8.3.0 Project Bootstrap Assistant
→ v8.4.0 Stability Baseline and Regression Sentinel
→ v8.5.0 Operator Runbook and Recovery Guide
→ v8.6.0 Guided Installer and Repository Onboarding
→ v8.7.0 Practical First Project Walkthrough
```

---

## 12. Tutorial Completo

O framework inclui documentação completa em `.agents/docs/`, separada por idioma:

### Guias Sequenciais (28 arquivos)
| # | Guia | Nível |
|---|------|-------|
| 01 | Primeiros Passos | 🟢 Iniciante |
| 02 | Economia de Tokens | 🟢 Iniciante |
| 03 | Novo Chat e Retomada | 🟢 Iniciante |
| 04 | Fluxo Básico (LITE) | 🟢 Iniciante |
| 05 | Fluxo Intermediário (STANDARD) | 🟡 Intermediário |
| 06 | Fluxo Avançado (DEEP) | 🟠 Avançado |
| 07 | Fluxo Crítico (CRITICAL) | 🔴 Expert |
| 08 | Fluxo UI/UX | 🟡 Intermediário |
| 09 | Correção de Erros | 🟡 Intermediário |
| 10 | Backup, Commits e Versionamento | 🟢 Iniciante |
| 11 | Evolução do Framework | 🟠 Avançado |
| 12 | Descoberta de Projeto | 🟠 Avancado |
| 13 | Adaptador de Projeto Real | 🟠 Avancado |
| 14 | Execucao em Projeto Real | 🟠 Avancado |
| 15 | Comandos e Quality Gates | 🟠 Avancado |
| 16 | Cenario de Apply em Projeto Real | 🟠 Avancado |
| 17 | Loop de Documentacao em Runtime | 🟠 Avancado |
| 18 | Pacote de Evidencias de Release | 🟠 Avancado |
| 19 | Revisao de Nota Operacional | 🟠 Avancado |
| 20 | Wizard de Instalacao e Update | 🟢 Iniciante |
| 21 | Prova Opcional de Telemetria e Memoria | 🟠 Avancado |
| 22 | Mapa de Experiencia do Operador | 🟢 Iniciante |
| 23 | Barramento de Comunicacao Entre Agentes | 🟠 Avancado |
| 24 | CLI Unificado do Operador | 🟢 Iniciante |
| 25 | Guarda de Deriva do Contrato Central | 🟢 Iniciante |
| 26 | Lancador Diario do Operador | 🟢 Iniciante |
| 27 | Assistente de Bootstrap de Projeto | 🟢 Iniciante |
| 28 | Baseline de Estabilidade | 🟢 Iniciante |

### Exemplos de Prompts (6 arquivos)
| Arquivo | Conteúdo |
|---------|----------|
| Self-Evaluation Examples | YES/NO/STANDBY com chain-of-thought de todos os 10 agentes |
| Handoff Examples | Handoffs perfeitos vs. rejeitados com justificativa |
| Conflict Resolution Examples | 4 conflitos reais com evidence e resolução |
| Triage Examples | 5 requests com avaliação completa de todos os agentes |
| Chain-of-Thought Examples | Raciocínio passo a passo de cada tipo de agente |
| Prompts Prontos | Templates prontos para copiar e usar |

---

## 13. Histórico de Versões

| Versão | Nome | Marcadores |
|--------|------|------------|
| v1.0.0 | Foundation | 8 agentes, memória básica, 4 workflows |
| v1.5.0 | Expert Prompts | 30 prompts operacionais |
| v2.0.0 | Advanced Knowledge | 14 tech cards, 8 arch patterns, security KB |
| v2.5.0 | Specialist Patterns | Anti-patterns, incident archetypes, benchmarks |
| v3.0.0 | Enterprise Grade | 6 industry profiles, governance, maturity |
| v3.5.0 | Operational Intelligence | Operational intel, daily prompts, Delivery agent |
| v3.6.0 | Context Optimization | Smart Loading, Adaptive Complexity, Universal Triage |
| **v4.0.0** | **Practical Intelligence** | **UI/UX Specialist, Platform Guardian, Flutter profile, UI workflow, Orchestrator Router Mode** |
| **v4.0.1** | **Auto-Escalation** | **Auto-Escalation Protocol (12 triggers), Delta Loading, start-lean-scale-up pattern** |
| **v5.1.0** | **Bilingual Documentation Structure** | **Documentacao oficial separada em EN/PT-BR** |
| **v5.2.0** | **Integrity and Version Alignment** | **Manifesto, validacao local, alinhamento de versao e higiene de paths** |
| **v5.3.0** | **Smart Loading Manifest** | **Tiers auditaveis, estimativa de tokens e relatorios de loading** |
| **v5.4.0** | **Memory Contract and Session State** | **Consulta de memoria por trigger, politica de memoria e templates de sessao** |
| **v5.5.0** | **Telemetry Schema and Health Score** | **Schema de telemetria, validacao de logs e score de saude** |
| **v5.6.0** | **Agent Contract Tests** | **Fixtures de roteamento e runner de contrato para requests canonicos** |
| **v5.7.0** | **Documentation Source of Truth and Reference Generation** | **Mapa de traducao e validacao de paridade documental** |
| **v5.8.0** | **Practical Enforcement Layer** | **Gate de pre-release, checklist de pacote, verificacao de ZIP e limpeza opcional de telemetria** |
| **v6.0.0** | **Framework Kernel Stabilization** | **Contrato estavel de kernel, politica de compatibilidade, guia de migracao e matriz de hosts** |
| **v6.1.0** | **Safe Install and Update Automation** | **Instalador dry-run, updater com backup, comparacao de versao e testes das ferramentas de instalacao** |
| **v6.2.0** | **Isolated Simulation Harness** | **Simulacao em workspace temporario com relatorio compacto de comportamento** |
| **v6.3.0** | **Developer Execution Mode Simulation** | **Implementacao controlada de mini projeto com testes e relatorio de entrega** |
| **v6.4.0** | **Multi-Scenario Developer Benchmark** | **Execucao repetida em cenarios de feature, docs, bug fix e validacao** |
| **v6.5.0** | **Documentation Enforcement and Mastery Calibration** | **Checkpoint obrigatorio de documentacao e calibracao master dos agentes** |
| **v6.6.0** | **Project Discovery and Requirements Maturation** | **Modo condicional de maturacao de projeto com historia do produto, casos de uso, backend, custos, legal/IP, Git e prontidao** |
| **v6.7.0** | **Real Project Adapter** | **Contrato local de projeto para stack, comandos, paths protegidos, modo de execucao e quality gates** |
| **v6.8.0** | **Developer Execution on Real Local Project** | **Planejamento DryRun-first em projeto real com backup, aprovacao, paths protegidos e quality gates** |
| **v6.9.0** | **Benchmark Expansion** | **Benchmark expandido com API, migracao fake de banco, refactor, security fix, failing tests e docs-only release** |
| **v7.0.0** | **Real Project Execution Hardening** | **Apply controlado em fixture, backup real, auditoria, override de path protegido e restore validado** |
| **v7.1.0** | **Command Allowlist and Quality Gate Runner** | **Parser de comandos do adaptador, allowlist segura, bloqueio destrutivo e relatorio compacto de quality gates** |
| **v7.2.0** | **Real Project Apply Scenario** | **Validacao isolada DryRun-to-Apply com quality gates antes/depois, backup, auditoria e restore** |
| **v7.3.0** | **Documentation Agent Runtime Loop** | **Loop de impacto documental por caminhos alterados, motivo obrigatorio para not_impacted e evidencia compacta** |
| **v7.4.0** | **Release Evidence Bundle** | **Indice compacto de auditoria de release com gates, pacote, docs e cenarios** |
| **v7.5.0** | **Operational Polish and Score Review** | **Rubrica final de nota, riscos residuais, revisao de economia de tokens e relatorio de prontidao** |
| **v7.6.0** | **Install and Update Wizard** | **Guia operacional de instalacao/update, protocolo, validacao e alinhamento do Getting Started atual** |
| **v7.7.0** | **Optional Telemetry and Memory Proof** | **Prova compacta de consulta de memoria, retencao opcional e integracao com evidencias de release** |
| **v7.8.0** | **Final Operator Experience Review** | **Mapa por intencao, limpeza de prompts antigos, pontes legadas atualizadas e gate de experiencia** |
| **v7.9.0** | **Real Inter-Agent Communication Bus** | **Contrato compacto de mensagens entre agentes, prova de comunicacao e integracao com release evidence** |
| **v8.0.0** | **Unified Operator CLI and Doctor** | **Comando unificado para diagnostico, validacao, pacote, evidencia, instalacao e update** |
| **v8.1.0** | **Core Contract Alignment and Drift Guard** | **Guarda compacta para alinhamento de versao, referencias atuais do core e economia de tokens sempre carregada** |
| **v8.2.0** | **Operator Daily Launcher and First-Call Installer** | **Comandos diarios por intencao, lancador Windows e prompt inicial gerado para projetos destino** |
| **v8.3.0** | **Project Bootstrap Assistant** | **Ponte inicial entre instalacao, Discovery e Adapter com rascunho seguro de adapter** |
| **v8.4.0** | **Stability Baseline and Regression Sentinel** | **Guarda compacta contra regressao em CLI, capacidades criticas e contagens estaveis** |
| **v8.5.0** | **Operator Runbook and Recovery Guide** | **Runbook compacto para operacao diaria e recuperacao depois de falhas de gate, pacote, instalacao ou update** |
| **v8.6.0** | **Guided Installer and Repository Onboarding** | **Instalacao guiada com modo de repositorio e handoff da primeira chamada** |
| **v8.7.0** | **Practical First Project Walkthrough** | **Passo a passo do primeiro uso real em projeto novo ou existente** |

---

## 14. Métricas e Capacidades

### Capacidades Totais

| Categoria | Quantidade | Detalhes |
|-----------|-----------|---------|
| Linguagens suportadas | 10+ | Dart, Python, JS/TS, Go, C#, Java, Kotlin, Swift, SQL, HTML/CSS |
| Frameworks | 15+ | Flutter, React, Next.js, Express, Django, FastAPI, etc. |
| Bancos de dados | 6+ | PostgreSQL, MongoDB, Redis, SQLite, Firestore, Supabase |
| Plataformas target | 6 | Android, iOS, Windows, macOS, Linux, Web |
| Padrões de segurança | 4 | OWASP, PCI-DSS, HIPAA, LGPD/GDPR |
| Padrões de arquitetura | 8 | Clean, Hex, DDD, CQRS, Micro, Modular, Event, Serverless |
| Tipos de teste | 6 | Unit, Widget, Golden, Integration, E2E, Security |

### O que o Framework Resolve

| Problema | Como resolve |
|----------|-------------|
| Código sem qualidade | Validator como gate obrigatório |
| UI inconsistente | UI/UX Specialist com design token enforcement |
| Crashs em plataforma X | Platform Guardian com known issues DB |
| Decisões perdidas | Memory system preserva tudo |
| Tokens desperdiçados | Smart Loading com 4 tiers + **Auto-Escalation com delta loading** |
| Documentação desatualizada | Documentation Agent always-active |
| Testes esquecidos | Validator gera e roda testes |
| Comandos locais arriscados | Quality Gate Runner executa apenas comandos permitidos e bloqueia padroes destrutivos |
| Instalacao/update confusos | Wizard guia dry-run, backup, preservacao local e validacao final |
| Falta de prova de consulta de memoria | Memory proof gera evidencia compacta sem carregar stores completos |
| Operador perdido entre muitos guias | Mapa de experiencia aponta o menor conjunto de documentos por intencao |
| Comunicacao entre agentes sem prova | Communication bus registra handoffs, consultas, conflitos e decisoes em evidencia compacta |
| Muitos scripts para lembrar | CLI unificado centraliza comandos comuns sem enfraquecer dry-run ou backup |
| Contrato central inchado ou desatualizado | Core contract drift guard bloqueia catalogos amplos, versoes divergentes e referencias antigas no core |
| Primeiro uso ou rotina diaria com atrito | Operator daily launcher simplifica start, validate, release e primeira instalacao |
| Projeto instalado mas ainda sem preparo | Project Bootstrap Assistant gera diagnostico inicial e rascunho seguro de adapter |
| Evolucao futura quebrando algo essencial | Stability Baseline acusa regressao antes do release |
| Commits bagunçados | Conventional Commits automático |
| Mesmo erro repetido | Learning Store previne repetição |
| Framework obsoleto | Evolution Protocol + retrospectivas |
| Nível errado escolhido | **Auto-Escalation ajusta automaticamente (12 triggers)** |

---

> **Para começar a usar:** Abra `.agents/docs/pt-br/01-PRIMEIROS-PASSOS.md`  
> **Para usar agora:** Abra `.agents/docs/pt-br/prompts/PROMPTS-PRONTOS.md`  
> **Para entender um agente:** Abra `.agents/agents/[nome]/AGENT.md`







