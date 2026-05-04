# 🎮 HEPHAESTUS GameForge — Prompt de Kickoff

> **Use este prompt para iniciar um NOVO CHAT dedicado à criação do HEPHAESTUS GameForge.**
> **Copie TUDO abaixo e cole como primeira mensagem no novo chat.**

---

```
# HEPHAESTUS GameForge — Framework Multi-Agente Especializado em Game Dev

## Contexto

Eu possuo o HEPHAESTUS Framework v3.6.0 — um sistema multi-agente de 
engenharia de software com 8 agentes, 11 protocolos, ~115 arquivos. 
Ele foi projetado para software engineering genérico (web, mobile, API, SaaS).

O framework está na pasta .agents/ deste projeto. Leia os seguintes arquivos 
para entender a arquitetura base ANTES de prosseguir:
- .agents/HEPHAESTUS-TECHNICAL-REFERENCE.md (documento completo do framework)
- .agents/config/agent-registry.yaml (registro dos 8 agentes)
- .agents/config/complexity-routing.yaml (pipeline de complexidade)
- .agents/config/maturity-profiles.yaml (perfis de maturidade)

## Objetivo

Criar o **HEPHAESTUS GameForge** — um FORK especializado do HEPHAESTUS 
100% focado em desenvolvimento de jogos. Ele deve:

1. HERDAR toda a arquitetura base (8 agentes, protocolos, memória, triage, 
   delivery, smart loading, complexity routing)
2. ADAPTAR todos os agentes para contexto de game dev
3. ADICIONAR conhecimento especializado em game dev
4. COBRIR desde Indie Solo até AAA Company

## O que precisa ser criado/adaptado:

### Agentes (adaptar os 8 existentes + criar 2 novos)
- Orchestrator → adaptar para game dev pipeline
- Researcher → adaptar para game tech evaluation (engines, rendering, networking)
- Planner → adaptar com Game Design Document, milestone planning de game dev
- Builder → adaptar com game code patterns (ECS, game loop, state machine)
- Validator → adaptar com game-specific testing (playtest, balance, performance profiling)
- Documentation → adaptar com GDD templates, technical design docs de game
- PM → adaptar com game dev milestones (pre-prod, production, alpha, beta, gold, live ops)
- Delivery → adaptar com game build pipeline (versioning de assets, build targets)
- **Game Designer (NOVO agent #9)** — game mechanics, balancing, level design, UX flow
- **Art Director (NOVO agent #10)** — art style guide, asset pipeline, UI/UX visual, branding

### Knowledge Base (nova, específica para games)
- Tech Cards: Unity, Unreal Engine 5, Godot 4, Bevy, Phaser, RPG Maker
- Architecture Patterns: ECS, Component-Based, Scene Graph, Game Loop patterns
- Networking: client-server, peer-to-peer, rollback netcode, lobby systems
- Rendering: shaders, lighting, LOD, occlusion, particle systems
- Audio: spatial audio, adaptive music, sound design pipeline
- Physics: collision, rigid body, cloth, fluid
- AI de jogos: behavior trees, state machines, pathfinding, utility AI
- Monetização: F2P, premium, DLC, battle pass, gacha, season pass
- Database Playbook: save game systems, leaderboards, player profiles, analytics

### Industry Profiles (4 perfis de estúdio)
1. **Indie Solo** — 1 pessoa, orçamento zero, foco em ship fast
2. **Indie Team** — 2-8 pessoas, budget limitado, Steam/mobile
3. **AA Studio** — 10-50 pessoas, publisher deal, multi-platform
4. **AAA Company** — 50-500+, budget alto, console certification, marketing

### Blueprints de Projeto
1. Mobile Game (casual, hypercasual, mid-core)
2. PC/Console Game (indie, AA)
3. Multiplayer Game (co-op, competitive, MMO-lite)
4. VR/AR Game

### Incident Archetypes (game dev)
- Memory leaks em game loop
- Frame rate drops por draw calls
- Desync em multiplayer
- Save corruption
- Asset loading lento
- Input lag
- Memory budget exceeded em console

### Anti-Patterns (game dev)
- God Object para game manager
- Update() hell (tudo no update loop)
- Hardcoded balancing values
- Premature optimization de shaders
- No object pooling

### Workflows adaptados
- /full-pipeline (game dev edition)
- /quick-fix (hotfix de game)
- /playtest-review (análise pós-playtest)
- /build-release (build + test + deploy para store)

## Escala do projeto

Quero o mesmo nível de qualidade e profundidade do HEPHAESTUS original.
Cada agente com system-prompt, deep-reasoning, self-evaluation.
Cada knowledge item com exemplos concretos de código.
Cada profile com regras específicas para o tipo de estúdio.

## Como proceder

1. Primeiro: analise o HEPHAESTUS base para entender a arquitetura
2. Segundo: me apresente um plano de implementação do GameForge
3. Terceiro: aguarde minha aprovação antes de começar
4. Quarto: implemente fase por fase com versionamento

Estou pronto. Comece pela análise e me apresente o plano.
```
