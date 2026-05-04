# Triage Examples — CRITICAL / RELEVANT / OPTIONAL / NOT_NEEDED

> **Propósito:** Exemplos detalhados de como o triagem funciona para cada tipo de request  
> **Chain-of-thought:** Mostra o raciocínio de TODOS os 10 agentes para cada request

---

## Como o Triage Funciona

```
Request chega → Orchestrator distribui para todos os agentes
             → Cada agente responde em ~100 palavras
             → Orchestrator coleta respostas
             → Monta pipeline com quem disse CRITICAL/RELEVANT
             → OPTIONAL incluído se complexidade >= DEEP
             → NOT_NEEDED nunca incluído
```

---

## REQUEST 1: "Adicionar campo de telefone no formulário de cadastro"

| Agente | Relevância | Confiança | Motivo | Modo |
|--------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Coordena pipeline | standard |
| Researcher | OPTIONAL | HIGH | Verificar validação de telefone existente | lite |
| Planner | OPTIONAL | HIGH | Simples — plano direto | skip |
| Builder | CRITICAL | HIGH | Implementar campo + validação | standard |
| **UI/UX Specialist** | **RELEVANT** | **HIGH** | **Novo campo = layout change, verificar responsive e alignment** | **lite** |
| Platform Guardian | NOT_NEEDED | HIGH | Campo de texto é cross-platform | skip |
| Validator | RELEVANT | HIGH | Testar validação de telefone | lite |
| Documentation | RELEVANT | HIGH | Changelog entry | lite |
| Project Manager | RELEVANT | HIGH | Telemetria | lite |
| Delivery | RELEVANT | HIGH | Commit feat | lite |

**Pipeline:** Builder → UI/UX (quick check) → Validator → Delivery

```
UI/UX THINKING:
→ Novo campo no form = verificar:
   1. Alinhamento com outros campos ✅ (deve seguir mesmo estilo)
   2. Teclado numérico (keyboardType: TextInputType.phone)
   3. Máscara de telefone? +55 (XX) XXXXX-XXXX
   4. Label e hint text seguem typography tokens?
   5. → RELEVANT (não CRITICAL porque é adição, não redesign)
```

---

## REQUEST 2: "Migrar de Provider para Riverpod em todo o app"

| Agente | Relevância | Confiança | Motivo | Modo |
|--------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Coordena pipeline DEEP | deep |
| **Researcher** | **CRITICAL** | **HIGH** | **Migration path, breaking changes, compatibility** | **deep** |
| **Planner** | **CRITICAL** | **HIGH** | **Faseamento da migração, rollback strategy** | **deep** |
| **Builder** | **CRITICAL** | **HIGH** | **Implementação de toda a migração** | **deep** |
| UI/UX Specialist | NOT_NEEDED | HIGH | State management é lógica, não visual | skip |
| Platform Guardian | NOT_NEEDED | HIGH | Riverpod é pure Dart — cross-platform | skip |
| **Validator** | **CRITICAL** | **HIGH** | **Testes pré e pós migração, regression check** | **deep** |
| Documentation | RELEVANT | HIGH | ADR migration, changelog | standard |
| Project Manager | RELEVANT | HIGH | Tracking e telemetria | standard |
| Delivery | RELEVANT | HIGH | Commits por fase | standard |

**Pipeline:** Researcher → Planner → Builder → Validator → Docs → PM → Delivery

```
Researcher THINKING:
→ Migração de state management é HIGH RISK:
  1. Provider → Riverpod: breaking changes em TODA a UI layer
  2. Preciso mapear: quantos providers existem? Que tipos?
  3. Riverpod 2.0 tem migration guide oficial
  4. Existe pacote flutter_riverpod para migration incremental?
  5. → CRITICAL: sem minha pesquisa, Builder pode quebrar metade do app
```

---

## REQUEST 3: "Adicionar package intl para formatação de datas"

| Agente | Relevância | Confiança | Motivo | Modo |
|--------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Roteamento | lite |
| Researcher | NOT_NEEDED | HIGH | intl é package bem conhecido | skip |
| Planner | NOT_NEEDED | HIGH | Instalação direta | skip |
| Builder | CRITICAL | HIGH | Adicionar e configurar | lite |
| UI/UX Specialist | NOT_NEEDED | HIGH | Package não visual | skip |
| **Platform Guardian** | **RELEVANT** | **MEDIUM** | **intl é cross-platform ✅ mas localizations config em web precisa setup** | **lite** |
| Validator | OPTIONAL | HIGH | Quick test de formatação | lite |
| Documentation | OPTIONAL | HIGH | Changelog entry | lite |
| Project Manager | NOT_NEEDED | HIGH | Muito simples para telemetria | skip |
| Delivery | RELEVANT | HIGH | Commit | lite |

```
Platform Guardian THINKING:
→ intl é pure Dart, cross-platform ✅ — normalmente NOT_NEEDED
→ MAS: se usar DateFormat com locale, web precisa:
  1. import 'package:intl/date_symbol_data_local.dart'
  2. initializeDateFormatting() antes de usar
  3. Pode dar erro silencioso se locale not initialized
→ RELEVANT (não CRITICAL): quick check, mention initialization
```

---

## REQUEST 4: "Criar sistema completo de chat real-time"

| Agente | Relevância | Confiança | Motivo | Modo |
|--------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Pipeline DEEP/CRITICAL | deep |
| **Researcher** | **CRITICAL** | **HIGH** | **WebSocket vs Firebase vs Supabase, architecture decisions** | **deep** |
| **Planner** | **CRITICAL** | **HIGH** | **Faseamento complexo: connection, messaging, UI, persistence** | **deep** |
| **Builder** | **CRITICAL** | **HIGH** | **Implementação complexa de real-time** | **deep** |
| **UI/UX Specialist** | **CRITICAL** | **HIGH** | **Chat UI é a mais complexa: messages, input, media, timestamps** | **deep** |
| **Platform Guardian** | **CRITICAL** | **HIGH** | **WebSocket behavior differs: mobile vs web vs desktop significantly** | **deep** |
| **Validator** | **CRITICAL** | **HIGH** | **Real-time testing, load testing, edge cases** | **deep** |
| Documentation | RELEVANT | HIGH | API docs, architecture docs | standard |
| Project Manager | RELEVANT | HIGH | Complex pipeline tracking | standard |
| Delivery | RELEVANT | HIGH | Multiple commits por fase | standard |

**TODOS CRITICAL** → Pipeline completo no modo DEEP

```
UI/UX THINKING:
→ Chat UI = uma das UIs mais complexas que existem:
  1. Message list (scroll infinito, performance com 1000+ msgs)
  2. Input bar (text + media + emoji)  
  3. Media preview (images, files, video)
  4. Read receipts, typing indicators
  5. Different bubble for sent vs received
  6. Timestamps (grouped by day)
  7. Reply/forward/reactions
  8. Responsive: mobile (fullscreen) vs desktop (multiple panel)
→ CRITICAL: sem minha guidance, a UI vai ser amadora
```

---

## REQUEST 5: "Remover console.log do código de produção"

| Agente | Relevância | Confiança | Motivo | Modo |
|--------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Route | lite |
| Builder | CRITICAL | HIGH | Find and remove | lite |
| **TODOS os outros** | **NOT_NEEDED** | **HIGH** | **Cleanup task, no impact** | **skip** |

**Pipeline mínimo:** Builder → Delivery (`chore: remove debug console.log statements`)

---

## Resumo: Padrões de Triage por Tipo de Request

| Tipo | Researcher | Planner | Builder | UI/UX | Platform | Validator |
|------|-----------|---------|---------|-------|----------|-----------|
| Bug fix | OPTIONAL | ❌ | ✅ | ❌ | ❌ | ✅ |
| Visual fix | ❌ | ❌ | ✅ | ✅ | ❌ | ✅ |
| New screen | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| New feature | ✅ | ✅ | ✅ | depends | depends | ✅ |
| API backend | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ |
| Refactor | depends | depends | ✅ | ❌ | ❌ | ✅ |
| Package add | ❌ | ❌ | ✅ | ❌ | ✅ | ❌ |
| Docs only | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Style/format | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Architecture | ✅ | ✅ | ✅ | ❌ | depends | ✅ |
| Auth/Security | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
