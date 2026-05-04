# Framework Health Dashboard

> **Purpose:** Quick diagnostic of the entire HEPHAESTUS installation in a project.  
> **Usage:** Run this prompt when something feels wrong or after a long break.

---

## Health Check Prompt (COPY THIS)

```
HEPHAESTUS — HEALTH CHECK completo.

Analise o estado do framework neste projeto:

1. Leia .agents/config/framework.yaml → confirme versão
2. Leia .agents/AGENTS.md → confirme agentes registrados
3. Liste .agents/protocols/ → confirme protocolos presentes
4. Liste .agents/profiles/ → confirme profile ativo
5. Liste .agents/memory/ (todos os stores) → conte entries
6. Liste .agents/telemetry/logs/ → verifique se há logs
7. Leia o session checkpoint mais recente

Gere um DASHBOARD DE SAÚDE:

┌─────────────────────────────────────────┐
│        HEPHAESTUS HEALTH DASHBOARD       │
├──────────────────┬──────────────────────┤
│ Framework        │ v?.?.? | ✅/❌       │
│ Agents           │ N/10   | ✅/❌       │
│ Protocols        │ N/14   | ✅/❌       │
│ Active Profile   │ name   | ✅/❌       │
│ Memory Authority │ .agents or legacy    │
│ Learning Store   │ N entries            │
│ Knowledge Graph  │ N entries            │
│ Evolution Log    │ N entries            │
│ Context DB       │ N entries            │
│ Telemetry Logs   │ N logs               │
│ Last Checkpoint  │ date                 │
│ Session Protocol │ enabled? ✅/❌       │
├──────────────────┴──────────────────────┤
│ OVERALL HEALTH: ✅ HEALTHY / ⚠️ / ❌    │
└─────────────────────────────────────────┘

DIAGNÓSTICO:
- [List any issues found]
- [List any missing files]
- [List any outdated entries]

RECOMENDAÇÕES:
- [What to fix, in priority order]
```

---

## Common Issues the Dashboard Catches

| Issue | Symptom | Fix |
|-------|---------|-----|
| Memory not evolving | Learning store has only bootstrap entries | Run a session with session-closing-protocol |
| Stale checkpoint | Last checkpoint > 7 days old | Update checkpoint now |
| Missing profile | No project-specific profile exists | Run onboarding wizard |
| Old framework | Version < current (5.4.0) | Update from zip backup |
| No telemetry | Logs directory is empty | Check if telemetry is enabled in framework.yaml |
| Legacy memory active | Writes going to `memory/` instead of `.agents/memory/` | Update profile memory authority |
| Missing protocols | Protocol count < 14 | Sync from framework master |
| Health score low | Score < 90 | Run `.agents/tools/framework-health.ps1 -WriteReport` |

---

## Quick Health Check (1-minute version)

```
HEPHAESTUS — health check rápido.
Versão do framework? Quantos learnings na memória? Quando foi o último checkpoint?
```

---

## Automated Health Indicators

A healthy HEPHAESTUS installation should have:

| Indicator | Healthy | Warning | Critical |
|-----------|---------|---------|----------|
| Framework version | Latest (5.5.0) | 1 minor behind | 1+ major behind |
| Learning Store entries | 5+ project-specific | 1-4 entries | Only bootstrap |
| Checkpoint freshness | < 3 days | 3-7 days | > 7 days |
| Session Brief exists | Yes, updated | Exists but stale | Missing |
| Telemetry logs | 1+ real logs | Empty but enabled | Disabled |
| Profile exists | Project-specific | Only flutter-multiplatform | None |
| Memory authority | `.agents/memory/` | Dual (transitioning) | Legacy only |
