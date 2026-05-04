# Triage Examples — CRITICAL / RELEVANT / OPTIONAL / NOT_NEEDED

> **Purpose:** Detailed examples showing how triage works for each type of request  
> **Chain-of-thought:** Shows the reasoning of ALL 10 agents for each request

---

## How Triage Works

```
Request arrives → Orchestrator distributes to all agents
              → Each agent responds in ~100 words
              → Orchestrator collects responses
              → Assembles pipeline with CRITICAL/RELEVANT agents
              → OPTIONAL included if complexity >= DEEP
              → NOT_NEEDED never included
```

---

## REQUEST 1: "Add phone field to registration form"

| Agent | Relevance | Confidence | Reason | Mode |
|-------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Coordinates pipeline | standard |
| Researcher | OPTIONAL | HIGH | Check existing phone validation | lite |
| Planner | OPTIONAL | HIGH | Simple — direct plan | skip |
| Builder | CRITICAL | HIGH | Implement field + validation | standard |
| **UI/UX Specialist** | **RELEVANT** | **HIGH** | **New field = layout change, verify responsive and alignment** | **lite** |
| Platform Guardian | NOT_NEEDED | HIGH | Text field is cross-platform | skip |
| Validator | RELEVANT | HIGH | Test phone validation | lite |
| Documentation | RELEVANT | HIGH | Changelog entry | lite |
| Project Manager | RELEVANT | HIGH | Telemetry | lite |
| Delivery | RELEVANT | HIGH | Commit feat | lite |

**Pipeline:** Builder → UI/UX (quick check) → Validator → Delivery

```
UI/UX THINKING:
→ New form field = verify:
   1. Alignment with other fields ✅ (must follow same style)
   2. Numeric keyboard (keyboardType: TextInputType.phone)
   3. Phone mask? +1 (XXX) XXX-XXXX
   4. Label and hint text follow typography tokens?
   5. → RELEVANT (not CRITICAL because it's addition, not redesign)
```

---

## REQUEST 2: "Migrate from Provider to Riverpod across entire app"

| Agent | Relevance | Confidence | Reason | Mode |
|-------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Coordinates DEEP pipeline | deep |
| **Researcher** | **CRITICAL** | **HIGH** | **Migration path, breaking changes, compatibility** | **deep** |
| **Planner** | **CRITICAL** | **HIGH** | **Phased migration, rollback strategy** | **deep** |
| **Builder** | **CRITICAL** | **HIGH** | **Implement entire migration** | **deep** |
| UI/UX Specialist | NOT_NEEDED | HIGH | State management is logic, not visual | skip |
| Platform Guardian | NOT_NEEDED | HIGH | Riverpod is pure Dart — cross-platform | skip |
| **Validator** | **CRITICAL** | **HIGH** | **Pre and post migration tests, regression check** | **deep** |
| Documentation | RELEVANT | HIGH | ADR migration, changelog | standard |
| Project Manager | RELEVANT | HIGH | Tracking and telemetry | standard |
| Delivery | RELEVANT | HIGH | Commits per phase | standard |

**Pipeline:** Researcher → Planner → Builder → Validator → Docs → PM → Delivery

---

## REQUEST 3: "Add intl package for date formatting"

| Agent | Relevance | Confidence | Reason | Mode |
|-------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Routing | lite |
| Researcher | NOT_NEEDED | HIGH | intl is a well-known package | skip |
| Planner | NOT_NEEDED | HIGH | Direct installation | skip |
| Builder | CRITICAL | HIGH | Add and configure | lite |
| UI/UX Specialist | NOT_NEEDED | HIGH | Non-visual package | skip |
| **Platform Guardian** | **RELEVANT** | **MEDIUM** | **intl is cross-platform ✅ but localizations config on web needs setup** | **lite** |
| Validator | OPTIONAL | HIGH | Quick formatting test | lite |
| Documentation | OPTIONAL | HIGH | Changelog entry | lite |
| Project Manager | NOT_NEEDED | HIGH | Too simple for telemetry | skip |
| Delivery | RELEVANT | HIGH | Commit | lite |

```
Platform Guardian THINKING:
→ intl is pure Dart, cross-platform ✅ — normally NOT_NEEDED
→ BUT: if using DateFormat with locale, web requires:
  1. import 'package:intl/date_symbol_data_local.dart'
  2. initializeDateFormatting() before use
  3. Can silently fail if locale not initialized
→ RELEVANT (not CRITICAL): quick check, mention initialization
```

---

## REQUEST 4: "Build complete real-time chat system"

| Agent | Relevance | Confidence | Reason | Mode |
|-------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | DEEP/CRITICAL pipeline | deep |
| **Researcher** | **CRITICAL** | **HIGH** | **WebSocket vs Firebase vs Supabase, architecture decisions** | **deep** |
| **Planner** | **CRITICAL** | **HIGH** | **Complex phasing: connection, messaging, UI, persistence** | **deep** |
| **Builder** | **CRITICAL** | **HIGH** | **Complex real-time implementation** | **deep** |
| **UI/UX Specialist** | **CRITICAL** | **HIGH** | **Chat UI is most complex: messages, input, media, timestamps** | **deep** |
| **Platform Guardian** | **CRITICAL** | **HIGH** | **WebSocket behavior differs significantly across platforms** | **deep** |
| **Validator** | **CRITICAL** | **HIGH** | **Real-time testing, load testing, edge cases** | **deep** |
| Documentation | RELEVANT | HIGH | API docs, architecture docs | standard |
| Project Manager | RELEVANT | HIGH | Complex pipeline tracking | standard |
| Delivery | RELEVANT | HIGH | Multiple commits per phase | standard |

**ALL CRITICAL** → Full pipeline in DEEP mode

---

## REQUEST 5: "Remove console.log from production code"

| Agent | Relevance | Confidence | Reason | Mode |
|-------|-----------|-----------|--------|------|
| Orchestrator | CRITICAL | HIGH | Route | lite |
| Builder | CRITICAL | HIGH | Find and remove | lite |
| **All others** | **NOT_NEEDED** | **HIGH** | **Cleanup task, no impact** | **skip** |

**Minimal pipeline:** Builder → Delivery (`chore: remove debug console.log statements`)

---

## Summary: Triage Patterns by Request Type

| Type | Researcher | Planner | Builder | UI/UX | Platform | Validator |
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
