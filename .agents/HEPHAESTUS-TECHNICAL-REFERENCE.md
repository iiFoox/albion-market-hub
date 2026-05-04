# HEPHAESTUS Framework — Documento Técnico Completo

> **Status:** Legacy technical reference. This file reflects v3.5.0-era architecture and is kept for historical context.
> **Current source of truth:** `.agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md` and `.agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md`.
> **Current framework version:** 7.9.0.

> **Versão:** 3.5.0 (Operational Intelligence)
> **Total de Arquivos:** ~114
> **Total de Agentes:** 8
> **Total de Protocolos:** 10
> **Total de Workflows:** 4
> **Data:** 2026-04-05

---

# PARTE 1 — VISÃO GERAL

## O que é o HEPHAESTUS

O HEPHAESTUS é um **framework multi-agente de engenharia de software** que transforma assistentes de IA em um **sistema operacional de entrega de software**. Ele não é um simples conjunto de prompts — é uma arquitetura completa com agentes especializados, protocolos de comunicação, memória compartilhada, telemetria, knowledge base, industry profiles, e governança de projeto.

**Em vez de um assistente que improvisa, o HEPHAESTUS oferece um time virtual que opera com padrão, memória e disciplina.**

## O que ele faz na prática

Quando você envia uma solicitação (ex: "Implementar autenticação com JWT"), o HEPHAESTUS:

1. **Classifica a complexidade** da tarefa (LITE / STANDARD / DEEP / CRITICAL)
2. **Consulta todos os agentes** via triage leve — cada um diz se precisa participar
3. **Monta o pipeline** com os agentes relevantes
4. **Pesquisa** tecnologias, riscos e alternativas (Researcher)
5. **Planeja** a implementação com fases, critérios de aceite e riscos (Planner)
6. **Implementa** com padrões de código, error handling e performance (Builder)
7. **Valida** segurança, testes e qualidade (Validator)
8. **Documenta** decisões, APIs e changelogs (Documentation)
9. **Observa** métricas, escopo e evolução do pipeline (Project Manager)
10. **Persiste** o trabalho com commit padronizado, versionamento e sync (Delivery)

## Filosofia de Design

```
1. AGENTES ESPECIALIZADOS > agente generalista
2. PADRÕES CONCRETOS > conselhos genéricos
3. MEMÓRIA ACUMULATIVA > recomeçar do zero toda vez
4. PROFUNDIDADE PROPORCIONAL > mesma intensidade para tudo
5. GOVERNANÇA REAL > boa intenção sem controle
```

---

# PARTE 2 — HISTÓRIA DE EVOLUÇÃO

## v1.0.0 — Foundation (Base)

A fundação do framework. Criou a estrutura de diretórios, os 7 agentes originais, 5 protocolos base, 4 workflows, o sistema de memória e a telemetria.

**O que nasceu aqui:**
- 7 agentes com AGENT.md + capabilities.yaml + prompts básicos
- Orchestrator como coordenador central
- Memória compartilhada com 4 stores
- 5 protocolos inter-agente
- 4 workflows operacionais
- Sistema de telemetria
- ROADMAP de evolução

## v1.5.0 — Expert Prompts (49 arquivos)

Transformou cada agente de "assistente genérico" em "especialista sênior" através de prompt engineering avançado.

**O que foi adicionado a cada agente:**
- **System Prompt** com persona de Staff/Principal Engineer (10+ anos de experiência)
- **Self-Evaluation** com calibração e exemplos de diferentes níveis de participação
- **Deep Reasoning** com técnicas avançadas únicas por agente (4+ técnicas cada)
- **Few-Shot Examples** em todos os prompts (elimina respostas genéricas)

**Total:** 7 agentes × 7 prompt files = 49 arquivos de prompts especializados

## v2.0.0 — Advanced Knowledge Base (27 arquivos)

Construiu uma base de conhecimento reutilizável para que os agentes nunca "reinventem a roda".

**O que foi criado:**
- 8 padrões arquiteturais com decisão tree
- 12 Tech Cards (frontend, backend, mobile, DB, DevOps)
- Database Playbook completo
- Security Knowledge Base (4 módulos)

## v2.5.0 — Specialist Patterns (12 arquivos)

Adicionou padrões concretos de código, testing playbooks, blueprints de projeto e governance.

**O que foi criado:**
- Builder: Error handling, API design, performance patterns
- Validator: Unit testing + Integration/E2E testing guides
- Planner: SaaS, Mobile e API Platform blueprints
- Researcher: 5 analysis frameworks
- Documentation: 5 templates (README, ADR, Runbook, Postmortem, TDD)
- PM: Governance framework completo

## v3.0.0 — Enterprise Grade (10 arquivos)

Elevou o framework para nível Enterprise com multi-projeto, industry profiles, observability e benchmarks.

**O que foi criado:**
- Organization Standards (multi-project support)
- 5 Industry Profiles (Fintech, Healthcare, E-Commerce, Real-Time, AI/ML)
- Observability Guide (logging, metrics, tracing, alerting)
- Resilience Patterns (DR, backup, failover, chaos engineering)
- Agent Benchmarks Suite (20 cenários, scoring, certificação)

## v3.5.0 — Operational Intelligence (16 arquivos)

A evolução mais recente. Adicionou inteligência operacional: triage universal, delivery automatizado, complexidade adaptativa, governança de memória e experiência operacional.

**O que foi criado:**
- 5 novos protocolos
- 1 novo agente (Delivery — Agent #8)
- 3 novos configs (triage, complexity, maturity)
- 2 knowledge modules (incidents, anti-patterns)

---

# PARTE 3 — OS 8 AGENTES (DETALHAMENTO COMPLETO)

---

## Agent #1: Orchestrator

**Papel:** Coordenador central do pipeline multi-agente.
**Persona:** VP of Engineering com 15+ anos de experiência gerenciando equipes de 50+ engenheiros.
**Posição no pipeline:** PRIMEIRO — recebe a request e monta o pipeline.
**Status:** Sempre ativo em toda request.

### O que ele faz
- Recebe a solicitação do usuário
- Classifica a complexidade (Adaptive Complexity Protocol)
- Solicita triage de todos os agentes (Universal Triage Protocol)
- Monta o pipeline com os agentes relevantes
- Coordena a execução sequencial dos agentes
- Resolve conflitos entre agentes usando scoring baseado em evidências
- Entrega o resultado final ao usuário

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Define a persona, responsabilidades, regras de routing e exemplos de pipeline |
| `self-evaluation.md` | Calibra quando o Orchestrator deve intervir vs delegar |
| `deep-reasoning.md` | Técnicas: Complexity Decomposition, Dependency Graph Analysis, Pipeline Optimization, Conflict Arbitration |

### Regras Críticas
- Nunca executa trabalho diretamente — apenas coordena
- Se um agente marcar `CRITICAL` no triage e for excluído, deve justificar
- Em caso de conflito entre agentes, usa scoring ponderado (evidência > opinião)
- Os agentes Project Manager e Orchestrator são SEMPRE ativos

---

## Agent #2: Researcher

**Papel:** Analista de tecnologia e avaliador de risco.
**Persona:** Staff Software Architect com 15+ anos de experiência, especialista em avaliação de tecnologias e análise de risco.
**Posição no pipeline:** SEGUNDO — após Orchestrator, antes do Planner.

### O que ele faz
- Pesquisa tecnologias, bibliotecas e frameworks relevantes
- Avalia alternativas com scoring ponderado
- Mapeia dependências e riscos
- Analisa o contexto existente do código
- Faz análise de viabilidade técnica
- Aplica análise adversarial (busca falhas no plano)

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, filosofia de pesquisa, regras de avaliação |
| `context-analysis.md` | Como analisar codebase existente (arquitetura, tech stack, patterns) |
| `technology-research.md` | Framework de avaliação de tecnologias com scoring |
| `risk-assessment.md` | Matriz probabilidade × impacto, estratégias de mitigação |
| `dependency-mapping.md` | Mapeamento de dependências internas e externas |
| `self-evaluation.md` | Quando participar (CRITICAL/RELEVANT/OPTIONAL/NOT_NEEDED) |
| `deep-reasoning.md` | Técnicas: FMEA Risk Analysis, Adversarial Analysis, Technology Radar Mapping, Technical Debt Topology |

### Ferramentas de Análise (v2.5.0)
O Researcher tem acesso a 5 frameworks formais:
1. **Technology Evaluation Matrix** — scoring ponderado com 8 critérios
2. **Make vs Buy Analysis** — quando construir vs comprar
3. **Technical Debt Assessment** — categorização e priorização de dívida
4. **Dependency Health Scorecard** — saúde de cada dependência crítica
5. **Architecture Fitness Functions** — métricas de qualidade arquitetural

---

## Agent #3: Planner

**Papel:** Arquiteto de soluções e decomposição de tarefas.
**Persona:** Principal Software Architect com 12+ anos, especialista em design de sistemas e planejamento de entregas.
**Posição no pipeline:** TERCEIRO — após Researcher, antes do Builder.

### O que ele faz
- Escolhe o padrão arquitetural adequado (usando decision tree)
- Decompõe features em tarefas atômicas implementáveis
- Define critérios de aceite (GIVEN/WHEN/THEN)
- Estima complexidade e identifica riscos
- Cria plano de fases com milestones
- Planeja rollback strategy

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, filosofia de planejamento, regras de decomposição |
| `architecture-decision.md` | Decision tree para escolha de padrão arquitetural |
| `task-decomposition.md` | Como decompor features em steps atômicos |
| `acceptance-criteria.md` | Formato GIVEN/WHEN/THEN para todos os cenários |
| `self-evaluation.md` | Quando o Planner é necessário vs dispensável |
| `deep-reasoning.md` | Técnicas: Constraint Propagation, Dependency Inversion Planning, Risk-Ordered Implementation, Scope Negotiation Framework |

### Blueprints (v2.5.0)
O Planner tem blueprints pré-construídos para 3 tipos de projeto:
1. **SaaS Web App** — arquitetura referência, 4 fases, MVP scope, tech stack, scale plan
2. **Mobile App** — decision framework (native vs cross-platform), 4 fases, App Store checklist
3. **API Platform** — API governance, versioning, developer experience checklist

---

## Agent #4: Builder

**Papel:** Implementador de código de qualidade production-ready.
**Persona:** Staff Software Engineer com 12+ anos, domínio de múltiplas linguagens e patterns.
**Posição no pipeline:** QUARTO — após Planner, antes do Validator.

### O que ele faz
- Implementa código seguindo os padrões do framework
- Aplica error handling, retry logic, circuit breakers
- Segue REST best practices e performance patterns
- Usa as tech cards como referência de configuração
- Auto-revisa seu código antes de entregar (self-evaluation)
- Aplica concept mapping quando muda de stack

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, coding standards, regras de implementação |
| `implementation.md` | Padrões de implementação por contexto (API, frontend, mobile) |
| `code-review.md` | Checklist de self-review antes de entregar |
| `refactoring.md` | Padrões de refatoração com métricas before/after |
| `concept-mapping.md` | Como traduzir conceitos entre stacks diferentes |
| `self-evaluation.md` | Quando participar, o que entregar por nível de complexidade |
| `deep-reasoning.md` | Técnicas: Adversarial Code Review (3 personas: Junior Scanner, Concurrency Specialist, Perf Attacker), Concept Transfer Matrix, Implementation Tradeoff Analysis, Defensive Code Architecture |

### Patterns Library (v2.5.0)
- **Global Error Handler** — implementações para Express, Next.js e FastAPI
- **Retry & Circuit Breaker** — exponential backoff, estados do circuit breaker
- **REST Best Practices** — URL design, status codes, paginação cursor, idempotência, HATEOAS
- **Performance Patterns** — Core Web Vitals, caching multi-layer, N+1 prevention, async processing

---

## Agent #5: Validator

**Papel:** Quality assurance, segurança e testes.
**Persona:** Staff QA Engineer / Security Specialist com 12+ anos, especializado em testing strategies e security auditing.
**Posição no pipeline:** QUINTO — após Builder, antes da Documentation.

### O que ele faz
- Gera testes (unit, integration, E2E) para o código implementado
- Audita segurança (OWASP Top 10, API Security)
- Verifica regressões
- Valida qualidade gates (coverage, complexity, standards)
- Aplica adversarial testing (input malicioso, race conditions)
- Verifica compliance (PCI-DSS, HIPAA, LGPD quando aplicável)

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, filosofia de qualidade, red-team mindset |
| `test-generation.md` | Geração de testes AAA pattern com edge cases |
| `security-audit.md` | OWASP Top 10 + API Security checklist + LGPD |
| `quality-gate.md` | Métricas de qualidade (coverage, complexity, standards) |
| `regression-check.md` | Verificação de regressões e backward compatibility |
| `self-evaluation.md` | Quando participar (CRITICAL para security/payments) |
| `deep-reasoning.md` | Técnicas: Adversarial Input Generation, Auth Boundary Testing, Race Condition Probing, Business Logic Subversion |

### Testing Playbooks (v2.5.0)
1. **Unit Testing Guide** — AAA pattern, naming conventions, mocking strategies, test factories, edge cases checklist
2. **Integration & E2E Testing Guide** — Supertest API tests, database tests, Playwright E2E, test pyramid, CI strategy

---

## Agent #6: Documentation

**Papel:** Documentação técnica contínua e ADRs.
**Persona:** Principal Technical Writer com 10+ anos, especializado em developer documentation e technical communication.
**Posição no pipeline:** SEXTO — após Validator, antes do Delivery.
**Status:** Sempre ativo (observa e documenta continuamente).

### O que ele faz
- Gera README, API docs, changelogs
- Cria ADRs (Architecture Decision Records) para decisões arquiteturais
- Produz runbooks operacionais
- Documenta fluxos de erro e troubleshooting
- Mantém documentação sincronizada com código

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, filosofia "docs as code", regras de documentação |
| `api-documentation.md` | Documentação de endpoints (request, response, errors, examples) |
| `architecture-docs.md` | Documentação de decisões arquiteturais (ADR format) |
| `changelog-generation.md` | Geração de changelog no formato keepachangelog |
| `self-evaluation.md` | Quando participar (CRITICAL para APIs, OPTIONAL para bug fixes) |
| `deep-reasoning.md` | Técnicas: Audience Analysis, Information Architecture, Progressive Disclosure, Documentation Debt Detection |

### Template Library (v2.5.0)
5 templates prontos para uso:
1. **README Template** — estrutura completa com quick start, env vars, commands
2. **ADR Template** — contexto, decisão, alternativas, consequências
3. **Runbook Template** — health check, common issues, diagnosis, resolution, escalation
4. **Incident Postmortem Template** — timeline, impact, root cause, action items
5. **Technical Design Document** — problem, solution, API changes, data model, security, testing, rollback

---

## Agent #7: Project Manager

**Papel:** Observador estratégico — telemetria, performance, escopo e evolução.
**Persona:** VP of Engineering com 15+ anos, especializado em delivery metrics e operational excellence.
**Posição no pipeline:** OBSERVADOR — presente em todo pipeline, mas não executa trabalho direto.
**Status:** Sempre ativo.

### O que ele faz
- Coleta telemetria de cada pipeline (quem participou, duração, loops de correção)
- Analisa performance do framework ao longo do tempo
- Detecta scope creep e mudanças de escopo
- Rastreia evolução do framework e dos projetos
- Registra lições aprendidas na memória
- Aplica governance framework (DoD, DoR, quality gates)

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona VP of Engineering, filosofia de observação estratégica |
| `telemetry-logging.md` | Coleta de métricas: agentes ativos, duração, quality score, loops |
| `performance-analysis.md` | Análise de trends, anomalias, recomendações de melhoria |
| `scope-management.md` | Detecção de scope creep, baseline tracking, change protocol |
| `evolution-tracking.md` | Tracking dual: evolução do projeto + evolução do framework |
| `self-evaluation.md` | Sempre ativo, calibração de profundidade de observação |
| `deep-reasoning.md` | Técnicas: Trend Analysis, Anomaly Detection, Retrospective Analysis, Agent Calibration |

### Governance Framework (v2.5.0)
- **Definition of Done (DoD)** — checklist em 4 níveis: code, quality, documentation, deployment
- **Definition of Ready (DoR)** — 7 critérios para uma tarefa ser implementável
- **4 Quality Gates** — Planning → Implementation → Review → Deployment
- **Risk Scoring** — Probability × Impact matrix com 4 estratégias de resposta
- **KPI Dashboard** — Delivery KPIs (lead time, MTTR) + Quality KPIs (coverage, bug escape) + Framework KPIs
- **Escalation Matrix** — P1 (15 min) → P2 (1h) → P3 (4h) → P4 (next sprint)
- **Change Management** — 4-step process (document → assess → decide → communicate)

---

## Agent #8: Delivery (NOVO — v3.5.0)

**Papel:** Release Engineer — commit, versionamento, changelog e sync.
**Persona:** Staff Release Engineer com 12+ anos de DevOps, Git workflow e release management.
**Posição no pipeline:** ÚLTIMO — sempre o último a agir.

### O que ele faz
- **Repository Bootstrap** — na primeira execução, verifica Git/GitHub e guia setup completo (7 steps)
- **Commit Assessment** — avalia se o trabalho merece commit (Commit Gate Protocol)
- **Commit Message Generation** — Conventional Commits format (feat/fix/refactor/docs/chore)
- **Version Bump** — determina patch/minor/major baseado na mudança
- **Changelog Generation** — entries categorizadas (Added, Changed, Fixed, Security)
- **Release Checkpoint** — tags, release notes
- **Repository Sync** — push, verificação, resolução de conflitos

### Repository Bootstrap Protocol (7 passos)
Este é um diferencial único: quando o framework é usado pela primeira vez em um projeto, o Delivery Agent:
1. Verifica se Git está instalado → guia instalação se não
2. Verifica se `.git` existe → `git init` se não
3. Verifica `user.name` e `user.email` → guia configuração
4. Verifica remote origin → guia criação de repositório GitHub (3 opções: manual, existente, GitHub CLI)
5. Testa conexão → troubleshooting SSH/HTTPS
6. Faz push inicial → setup de tracking branch
7. Retoma a tarefa original → continuidade seamless

### Prompts
| Prompt | O que faz |
|---|---|
| `system-prompt.md` | Persona, Repository Bootstrap Protocol completo, commit rules, version bump rules |
| `deep-reasoning.md` | Técnicas: Release Strategy Analysis, Commit Archaeology, Repository Health Assessment, Conflict Resolution for Sync |

### Protocolos de Suporte
- **Commit Gate Protocol** — 5 portões: Completeness, Validation, Scope, Message Quality, Repository State
- **Versioning Protocol** — Decision tree semver, changelog format, tagging rules, version sync points

---

# PARTE 4 — OS 10 PROTOCOLOS

## Protocolos Originais (v1.0.0 — 5 protocolos)

### Protocol 1: Conflict Resolution
**Quando:** Dois ou mais agentes divergem sobre uma decisão.
**Como:** Scoring ponderado por evidência — cada agente apresenta argumentos, Orchestrator atribui pontuação, maior score vence. Empate → Researcher investiga mais.

### Protocol 2: Handoff Protocol
**Quando:** Um agente termina sua parte e passa para o próximo.
**Como:** Formato padronizado de handoff com: contexto, decisões tomadas, artefatos produzidos, pendências, e instruções para o próximo agente.

### Protocol 3: Self-Evaluation Protocol
**Quando:** Antes de cada agente decidir como participar.
**Como:** Cada agente avalia: "minha participação é necessária?", "qual profundidade?", "qual modo?". Calibrado com exemplos de diferentes níveis.

### Protocol 4: Inter-Agent Communication
**Quando:** Agentes precisam trocar informação durante o pipeline.
**Como:** Formato padronizado de mensagem com: remetente, destinatário, tipo (request, response, alert), conteúdo, prioridade.

### Protocol 5: Evolution Protocol
**Quando:** O framework aprende algo novo.
**Como:** PM registra lições aprendidas, promove conhecimento útil, atualiza memory e knowledge base.

## Protocolos Novos (v3.5.0 — 5 protocolos)

### Protocol 6: Adaptive Complexity Protocol
**Quando:** Toda request, ANTES de tudo.
**Como:** Classifica a tarefa em 4 níveis:

| Nível | Exemplo | Agentes | Profundidade |
|---|---|---|---|
| **LITE** | Fix typo, config change | 2-3 | Mínima |
| **STANDARD** | Nova feature, CRUD | 5-6 | Padrão |
| **DEEP** | Mudança arquitetural, migração | 7-8 | Completa |
| **CRITICAL** | Pagamento, dados de saúde, compliance | 8 (todos) | Máxima + adversarial |

**Regras de escalation:** Se qualquer agente marca CRITICAL → mínimo DEEP. Se industry profile ativo → mínimo STANDARD.

### Protocol 7: Universal Triage Protocol
**Quando:** Toda request, APÓS classificação de complexidade.
**Como:**
1. TODOS os 8 agentes fazem um scan leve (~100 palavras cada)
2. Cada um responde: `CRITICAL / RELEVANT / OPTIONAL / NOT_NEEDED` + motivo + risco se omitido
3. Orchestrator monta pipeline com base nos pareceres
4. Se agente CRITICAL foi excluído → justificativa obrigatória no telemetry

**Por que isso existe:** Resolve o problema de agentes úteis ficarem de fora porque o Orchestrator não os convocava.

### Protocol 8: Commit Gate Protocol
**Quando:** Antes de qualquer commit.
**Como:** 5 portões devem ser aprovados:
1. **Completeness** — implementação completa, sem TODOs
2. **Validation** — Validator aprovou, testes passam
3. **Scope** — mudanças correspondem ao request original
4. **Message Quality** — Conventional Commits, descrição clara
5. **Repository State** — working directory limpo, remote acessível

### Protocol 9: Versioning Protocol
**Quando:** Em cada commit com relevância de versão.
**Como:** Decision tree:
- Quebrou comportamento existente? → **MAJOR**
- Adicionou funcionalidade nova? → **MINOR**
- Bug fix ou melhoria interna? → **PATCH**

Inclui: changelog format (keepachangelog), tagging rules (annotated tags para minor/major), e sync points (package.json, pyproject.toml, etc.)

### Protocol 10: Memory Governance Protocol
**Quando:** Em toda operação de memória.
**Como:**
- **6 tipos de memória:** Rule, Lesson, Hypothesis, Exception, Temporary, Warning
- **Confidence scoring (1-5):** Disputed → Uncertain → Observed → Validated → Proven
- **Lifecycle:** Criação (score 3) → Validação (score 4, requer 2 projetos) → Promoção (score 5, vai para global)
- **Decay:** Entries não usadas por 60 dias perdem 1 ponto. 180 dias sem uso → arquivo. Rules e Warnings são exceção.
- **Conflitos:** Quando duas entries contradizem → compara evidência → downgrade a mais fraca ou marca ambas como EXCEPTION com contexto

---

# PARTE 5 — SISTEMA DE MEMÓRIA

## Arquitetura

```
.agents/memory/
├── MEMORY.md                    # Documentação do sistema de memória
├── context-db/                  # Estado atual do projeto
│   └── bootstrap-project-state.md
├── knowledge-graph/             # Conexões entre conceitos
│   └── bootstrap-architecture.md
├── learning-store/              # Lições aprendidas
│   └── bootstrap-consolidation.md
└── evolution-log/               # Histórico de evolução
    └── bootstrap-genesis.md
```

### Context DB
Armazena o **estado atual** do projeto: tech stack, arquitetura corrente, convenções, configurações, status de features. Atualizado a cada pipeline relevante.

### Knowledge Graph
Armazena **conexões entre conceitos**: "React se conecta a Next.js que usa App Router que depende de Server Components". Permite que os agentes entendam relacionamentos complexos.

### Learning Store
Armazena **lições aprendidas**: "Neste projeto, Prisma connection pool de 5 causou timeout sob carga". Cada entry tem tipo, confidence, tags.

### Evolution Log
Armazena **histórico de evolução**: mudanças no framework, decisões arquiteturais, performance over time. O PM é o principal alimentador.

## Governança (v3.5.0)

Com o Memory Governance Protocol, a memória agora tem:
- **Tipos classificados:** cada entry é rule/lesson/hypothesis/exception/temporary/warning
- **Confidence scores:** 1 (disputed) → 5 (proven)
- **Decay automático:** entries não usadas perdem relevância
- **Promoção:** local → global quando validado em 2+ projetos
- **Resolução de conflitos:** quando duas entries contradizem

---

# PARTE 6 — KNOWLEDGE BASE

## Architecture Patterns (9 arquivos)

| Padrão | Quando Usar | Quando Evitar |
|---|---|---|
| **Clean Architecture** | Aplicações complexas com regras de negócio ricas | CRUDs simples |
| **Hexagonal (Ports & Adapters)** | Sistemas que mudam de infraestrutura com frequência | Protótipos rápidos |
| **Microservices** | Equipes grandes (10+), domínios independentes | Equipes pequenas |
| **Modular Monolith** | Equipes médias querendo isolamento sem overhead de infra | Quando já precisa escalar independentemente |
| **Event-Driven** | Sistemas assíncronos, desacoplamento forte | Operações CRUD síncronas |
| **CQRS + Event Sourcing** | Audit trail obrigatório, domínios financeiros | Sistemas simples |
| **Serverless** | Workloads esporádicos, custos por uso | Workloads constantes de alto throughput |
| **DDD Tactical** | Domínios complexos com linguagem ubíqua | CRUDs sem lógica de negócio |
| **Decision Tree** | Meta-padrão: como ESCOLHER entre os acima | — |

Cada padrão inclui: Overview, Structure diagram, When to use, When to avoid, Implementation example, Trade-offs.

## Technology Reference Cards (14 arquivos)

### Frontend (3)
- **React 19** — Server Components, use() hook, Actions, form handling
- **Next.js 15** — App Router, Server Actions, ISR, middleware, route handlers
- **TypeScript 5** — strict mode config, utility types, template literals, decorators

### Backend (4)
- **Node.js 22** — native ESM, test runner, watch mode, single executable apps
- **Python 3.13** — async improvements, pattern matching, typing enhancements
- **.NET 9** — minimal APIs, ahead-of-time compilation, Blazor updates
- **Go 1.23** — generics maturity, structured logging, enhanced HTTP patterns

### Mobile (2)
- **React Native 0.76** — new architecture, Fabric renderer, Hermes engine
- **Flutter 3.26** — Impeller renderer, Material 3, platform views

### Databases (3)
- **PostgreSQL 17** — incremental backup, JSON improvements, performance
- **MongoDB 8** — queryable encryption, stream processing, Atlas search
- **Redis 8** — data types, persistence, Lua scripting, clustering

### DevOps (2)
- **Docker** — multi-stage builds, health checks, compose, security scanning
- **GitHub Actions** — workflow syntax, caching, matrix strategy, reusable workflows

Cada tech card inclui: versão, quando usar, quick start, configuração recomendada, performance tips, security checklist, gotchas.

## Database Playbook (1 arquivo)

Guia completo de padrões de banco de dados:
- **Soft Delete** — `deleted_at` pattern com filtered scopes
- **Audit Trail** — triggers para registrar quem mudou o quê
- **Multi-Tenant** — Row-Level Security (RLS) com Prisma
- **Cursor Pagination** — superior a offset para grandes volumes
- **Index Strategy** — quando usar B-tree, GIN, partial, composite
- **Migration Safety** — checklists para migrations sem downtime
- **Connection Pooling** — PgBouncer config e monitoring

## Security Knowledge Base (4 arquivos)

### Auth Patterns
JWT (access + refresh), OAuth 2.0 (authorization code flow), Session-based, API Keys — cada um com quando usar, implementação, e security considerations.

### API Security
Rate limiting, input validation, CORS config, request signing, IP whitelisting — OWASP API Security Top 10 completo.

### OWASP Top 10
Todos os 10 riscos com: descrição, exemplo de código vulnerável, código corrigido, e prevenção.

### LGPD/GDPR Compliance
Direitos do titular, base legal, consentimento, privacy by design, data processing agreement, breach notification.

---

# PARTE 7 — INDUSTRY PROFILES (5 perfis)

## Como funcionam
Quando o tipo de projeto é identificado (financeiro, saúde, etc.), o profile correspondente é ativado. Ele **sobrepõe** as configurações padrão com requisitos específicos da indústria.

## Fintech Profile
**Ativa quando:** projeto lida com dinheiro, pagamentos, transações financeiras.
**Adiciona:**
- Controles PCI-DSS obrigatórios (encryption, tokenization, audit logging)
- Classificação de dados financeiros (Restricted → Public)
- Audit trail com campos obrigatórios (quem, o que, quando, de onde)
- Regras de money handling (NUNCA usar float, usar integer cents)
- Transaction patterns (idempotency key, double-entry bookkeeping, reconciliation)

## Healthcare Profile
**Ativa quando:** projeto lida com dados de pacientes (PHI).
**Adiciona:**
- HIPAA/LGPD health data compliance (PHI classification)
- Technical safeguards (encryption at rest, audit logging, automatic logout)
- Data handling patterns com `EncryptedField<T>` e access logging obrigatório
- Interoperability standards (HL7 FHIR, DICOM, ICD-10, LOINC, SNOMED CT)
- Consent management (explicit, purpose-specific, revocable, auditable)

## E-Commerce Profile
**Ativa quando:** projeto vende produtos/serviços online.
**Adiciona:**
- Product catalog schema (flexible attributes with JSONB)
- Cart & checkout flow (merge anônimo, inventory lock, server-side price validation)
- Inventory management strategies (simple, variants, multi-warehouse, reservation)
- Performance SLAs (product page < 1.5s LCP, search < 500ms, add-to-cart < 300ms)
- SEO checklist (structured data, canonical URLs, sitemap, social meta tags)

## Real-Time Profile
**Ativa quando:** projeto precisa de dados ao vivo (chat, collaborative, streaming).
**Adiciona:**
- WebSocket architecture (Redis PubSub for multi-server, Socket.IO scaling)
- Auth middleware para WebSocket connections
- Conflict resolution strategies (Last Write Wins, OT, CRDT, Locking)
- Optimistic locking pattern (version-based conflict detection)
- Offline-first sync pattern (IndexedDB queue, reconnect sync, conflict resolution)

## AI/ML Profile
**Ativa quando:** projeto integra LLMs, ML models, ou pipelines de dados.
**Adiciona:**
- LLM client com retry e fallback entre providers
- Prompt management system (versioned prompts, template rendering)
- Cost control rules (budget limits, caching, model selection by task)
- RAG pipeline (ingest → query → generate with vector DB)
- MLOps lifecycle (data → train → evaluate → deploy → monitor)

---

# PARTE 8 — WORKFLOWS (4 fluxos)

## Full Pipeline
**Slash command:** `/full-pipeline`
**Quando:** Tarefas complexas que necessitam de todos os agentes.
**Fluxo:** Orchestrator → Researcher → Planner → Builder → Validator → Documentation → PM → Delivery

## Quick Fix
**Slash command:** `/quick-fix`
**Quando:** Correções rápidas e simples.
**Fluxo:** Orchestrator → Builder → Validator → Delivery (pipeline LITE)

## Research Only
**Slash command:** `/research-only`
**Quando:** Avaliação de tecnologia e análise de viabilidade.
**Fluxo:** Orchestrator → Researcher → Documentation (sem implementação)

## Review Only
**Slash command:** `/review-only`
**Quando:** Code review e auditoria arquitetural.
**Fluxo:** Orchestrator → Validator → Documentation (sem implementação)

---

# PARTE 9 — CONFIGURAÇÕES

## framework.yaml
Configuração global do framework: nome, versão, linguagem, logging level.

## agent-registry.yaml
Registro de todos os agentes com seus capabilities e regras de ativação.

## communication-protocol.yaml
Formato de comunicação inter-agente (mensagem padronizada).

## triage-rules.yaml (v3.5.0)
Define os sinais de relevância para cada agente (quando marcar CRITICAL, RELEVANT, OPTIONAL, NOT_NEEDED).

## complexity-routing.yaml (v3.5.0)
Define os 4 níveis de complexidade com: agentes mínimos, deep reasoning on/off, memory query depth, delivery mode.

## maturity-profiles.yaml (v3.5.0)
5 perfis de maturidade organizacional (startup, PME, enterprise, regulated, legacy) que adaptam quality gates, delivery rules, e agent behavior.

---

# PARTE 10 — OBSERVABILITY, RESILIENCE & BENCHMARKS

## Observability Guide
Os "3 pilares" completos:
- **Logs:** Structured logging com Pino, log levels, o que logar vs nunca logar
- **Metrics:** RED method (Rate, Errors, Duration) + USE method (Utilization, Saturation, Errors)
- **Tracing:** Distributed tracing com spans, trace IDs, request journey
- **Alerting:** Anti-alert-fatigue (4 severidades, regras anti-ruído, runbook links obrigatórios)

## Resilience Patterns
- **DR Strategies:** 4 tiers (Critical → Low) com RTO/RPO targets
- **Backup Strategies:** Database (full + incremental + WAL), Application (o que sim e o que não)
- **Failover Patterns:** Active-Passive vs Active-Active
- **Data Integrity:** Idempotency pattern com Redis, Feature flags para safe rollouts
- **Chaos Engineering:** 5 princípios + 5 experimentos práticos

## Benchmark Suite
- **20 cenários padronizados** — 4 per agente (O1-O4, R1-R3, P1-P3, B1-B4, V1-V3, D1-D3, M1-M3)
- **Scoring rubric:** Accuracy (40%) + Completeness (30%) + Quality (30%)
- **Self-tuning loop:** PM identifica padrões → recomenda ajustes → mede impacto
- **Memory relevance scoring:** recency × frequency × impact
- **Certification levels:** 🥉 Bronze (v1.0) → 🥈 Silver (v2.0) → 🥇 Gold (v3.0) → 💎 Platinum (futuro)

## Operational Intelligence (v3.5.0)
- **14 Incident Archetypes:** Database (pool, migration locks, N+1), Auth (JWT rotation, sessions), Deploy (no feature flag, missing env var), Performance (unbounded queries, image upload), Integration (no circuit breaker, webhook validation), Security (secrets in repo, IDOR)
- **16 Anti-Patterns:** Architecture (premature microservices, shared DB, god service), Code (stringly typed, callback hell, copy-paste, pokemon exceptions), API (chatty, internal IDs, no pagination), Database (float for money, no FK index, EAV), DevOps (snowflake server, deploy on Friday)

---

# PARTE 11 — TELEMETRIA

## O que é coletado (por pipeline)
```
pipeline_id: "pipe-20260405-001"
request_summary: "Implement JWT authentication"
complexity_level: DEEP
timestamp_start: "2026-04-05T10:00:00Z"
timestamp_end: "2026-04-05T10:45:00Z"
duration_minutes: 45
agents_activated: [orchestrator, researcher, planner, builder, validator, documentation, delivery, pm]
agents_skipped: []
triage_results: { researcher: CRITICAL, planner: CRITICAL, builder: CRITICAL, validator: CRITICAL, ... }
correction_loops: 1
quality_score: 4.2
memory_queries: 3
memory_hits: 2
version_bump: "minor"
commit_hash: "abc123"
```

## Métricas Agregadas
- Pipeline success rate
- Average correction loops
- Agent participation frequency
- Memory reuse rate
- Quality score trending
- Framework evolution velocity

---

# PARTE 12 — ESTRUTURA COMPLETA DE ARQUIVOS

```
.agents/
├── GETTING_STARTED.md
├── ROADMAP.md
│
├── agents/
│   ├── orchestrator/           # Agent #1 — Coordenador
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   └── prompts/ (3 files: system, self-eval, deep-reasoning)
│   │
│   ├── researcher/             # Agent #2 — Pesquisador
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── frameworks/analysis-frameworks.md
│   │   └── prompts/ (7 files)
│   │
│   ├── planner/                # Agent #3 — Arquiteto
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── blueprints/
│   │   │   ├── saas-web-app/blueprint.md
│   │   │   ├── mobile-app/blueprint.md
│   │   │   └── api-platform/blueprint.md
│   │   └── prompts/ (6 files)
│   │
│   ├── builder/                # Agent #4 — Implementador
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── patterns/
│   │   │   ├── error-handling/ (2 files)
│   │   │   ├── api-design/ (1 file)
│   │   │   └── performance/ (1 file)
│   │   └── prompts/ (7 files)
│   │
│   ├── validator/              # Agent #5 — QA/Security
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── playbooks/ (2 files)
│   │   └── prompts/ (7 files)
│   │
│   ├── documentation/          # Agent #6 — Documentação
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── templates/template-library.md
│   │   └── prompts/ (6 files)
│   │
│   ├── project-manager/        # Agent #7 — PM/Governance
│   │   ├── AGENT.md
│   │   ├── capabilities.yaml
│   │   ├── governance/governance-framework.md
│   │   └── prompts/ (7 files)
│   │
│   └── delivery/               # Agent #8 — Release Engineer (v3.5.0)
│       ├── AGENT.md
│       ├── capabilities.yaml
│       └── prompts/ (2 files: system-prompt, deep-reasoning)
│
├── protocols/ (10 files)
│   ├── conflict-resolution.md
│   ├── handoff-protocol.md
│   ├── self-evaluation-protocol.md
│   ├── inter-agent-communication.md
│   ├── evolution-protocol.md
│   ├── adaptive-complexity-protocol.md      (v3.5.0)
│   ├── universal-triage-protocol.md         (v3.5.0)
│   ├── commit-gate-protocol.md              (v3.5.0)
│   ├── versioning-protocol.md               (v3.5.0)
│   └── memory-governance-protocol.md        (v3.5.0)
│
├── workflows/ (4 files)
│   ├── full-pipeline.md
│   ├── quick-fix.md
│   ├── research-only.md
│   └── review-only.md
│
├── config/ (6 files)
│   ├── framework.yaml
│   ├── agent-registry.yaml
│   ├── communication-protocol.yaml
│   ├── triage-rules.yaml                    (v3.5.0)
│   ├── complexity-routing.yaml              (v3.5.0)
│   └── maturity-profiles.yaml               (v3.5.0)
│
├── memory/
│   ├── MEMORY.md
│   ├── context-db/
│   ├── knowledge-graph/
│   ├── learning-store/
│   └── evolution-log/
│
├── knowledge/
│   ├── architecture-patterns/ (9 files)
│   ├── tech-cards/ (14 files — frontend, backend, mobile, DB, DevOps)
│   ├── database-playbook/ (1 file)
│   ├── security/ (4 files — auth, API, OWASP, compliance)
│   ├── observability/ (1 file)
│   ├── resilience/ (1 file)
│   └── operational-intelligence/ (2 files — v3.5.0)
│
├── profiles/ (5 industry profiles)
│   ├── fintech/
│   ├── healthcare/
│   ├── e-commerce/
│   ├── realtime/
│   └── ai-ml/
│
├── global/
│   └── organization-standards.md
│
├── benchmarks/
│   └── benchmark-suite.md
│
└── telemetry/
    └── TELEMETRY.md
```

---

# PARTE 13 — RESUMO EXECUTIVO

## O HEPHAESTUS em Números

| Métrica | Valor |
|---|---|
| **Versão atual** | 3.5.0 |
| **Total de arquivos** | ~114 |
| **Agentes** | 8 (Orchestrator, Researcher, Planner, Builder, Validator, Documentation, PM, Delivery) |
| **Protocolos** | 10 (5 base + 5 v3.5.0) |
| **Workflows** | 4 (full-pipeline, quick-fix, research-only, review-only) |
| **Architecture Patterns** | 9 (com decision tree) |
| **Tech Cards** | 14 (frontend, backend, mobile, DB, DevOps) |
| **Industry Profiles** | 5 (fintech, healthcare, e-commerce, realtime, AI/ML) |
| **Maturity Profiles** | 5 (startup, PME, enterprise, regulated, legacy) |
| **Benchmark Scenarios** | 20 (4 por agente principal) |
| **Incident Archetypes** | 14 (conhecimento de falhas reais) |
| **Anti-Patterns** | 16 (com "DO INSTEAD") |
| **Templates** | 5 (README, ADR, Runbook, Postmortem, TDD) |
| **Complexity Levels** | 4 (LITE, STANDARD, DEEP, CRITICAL) |
| **Certification Levels** | 4 (Bronze, Silver, Gold, Platinum) |

## O Que Torna o HEPHAESTUS Diferente

1. **Não é um prompt avulso** — é um sistema interconectado com memória, protocolos e governança
2. **Não dá conselhos genéricos** — usa tech cards, patterns e playbooks concretos
3. **Não ignora o que aprendeu** — memória acumulativa com governança (confidence, decay, promoção)
4. **Não trata tudo igual** — complexidade adaptativa (LITE→CRITICAL) + maturity profiles
5. **Não esquece nenhum agente** — triage universal garante visibilidade de todos
6. **Não para na implementação** — Delivery Agent persiste, versiona e sincroniza
7. **Não é só técnico** — governance framework com DoD, DoR, quality gates, KPIs, escalation
8. **Não é ingênuo** — incident archetypes e anti-patterns trazem "experiência operacional"
9. **Não é estático** — self-tuning loop mede e melhora o framework ao longo do tempo
10. **Não é one-size-fits-all** — 5 industry profiles adaptam comportamento ao domínio

## ZIPs Versionados
```
📦 HEPHAESTUS-Framework-v1.5.0-Expert-Prompts.zip
📦 HEPHAESTUS-Framework-v2.0.0-Advanced-Knowledge.zip
📦 HEPHAESTUS-Framework-v2.5.0-Specialist-Patterns.zip
📦 HEPHAESTUS-Framework-v3.0.0-Enterprise-Grade.zip
📦 HEPHAESTUS-Framework-v3.5.0-Operational-Intelligence.zip
```





