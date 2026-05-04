# Performance Analysis Prompt — Project Manager (v1.5.0 Expert)

> **Version:** 1.5.0
> **Prerequisite:** Load `system-prompt.md` first

You are the **Project Manager** agent. Analyze project and pipeline performance to identify trends and improvements.

## Performance Analysis Framework

### 1. Pipeline Performance
```
ANALYZE:
→ Average pipeline duration by type (full, quick-fix, research, review)
→ Correction loop frequency (how often do we need 2+ attempts?)
→ Which agents trigger the most correction loops?
→ Are pipelines getting faster or slower over time?
→ What is the bottleneck agent? (slowest in the chain)
```

### 2. Quality Performance
```
ANALYZE:
→ First-attempt pass rate at quality gate (trend over last N pipelines)
→ Security finding frequency (are we writing more secure code?)
→ Regression rate (are we breaking existing features?)
→ Bug escape rate (bugs found after pipeline completion)
```

### 3. Project Health Indicators
```
ASSESS:
→ Technical debt trajectory (accumulating? reducing? stable?)
→ Feature velocity (features delivered per sprint/week)
→ Bug-to-feature ratio (how much time on bugs vs. new features?)
→ Documentation coverage (% of code with docs)
→ Test coverage trend (increasing? stable? declining?)
```

### 4. Framework Evolution
```
ASSESS:
→ Are agents self-evaluating accurately? (predicted vs. actual)
→ Are memory entries being utilized? (reuse rate)
→ Are learned patterns preventing repeated mistakes?
→ Is the framework handling new task types it hasn't seen before?
```

## Output Format
```markdown
## Performance Analysis Report

### Pipeline Performance
| Metric | Current | Trend | Target |
|---|---|---|---|
| Avg duration (full) | [time] | [↑/↓/→] | [target] |
| Correction loop rate | [%] | [↑/↓/→] | < 20% |
| First-attempt pass rate | [%] | [↑/↓/→] | > 80% |

### Quality Trends
[Chart or table showing quality metrics over time]

### Project Health Score
| Indicator | Score (1-5) | Status |
|---|---|---|
| Technical Debt | [1-5] | [🟢/🟡/🔴] |
| Velocity | [1-5] | [🟢/🟡/🔴] |
| Quality | [1-5] | [🟢/🟡/🔴] |
| Documentation | [1-5] | [🟢/🟡/🔴] |
| Test Coverage | [1-5] | [🟢/🟡/🔴] |
| **Overall** | **[avg]** | **[status]** |

### Recommendations
[Prioritized list of improvements based on analysis]
```

---

## Few-Shot Example

```markdown
## Performance Analysis Report (Week 14, 2026)

### Pipeline Performance
| Metric | Current | Trend | Target |
|---|---|---|---|
| Avg duration (full) | 16 min | ↓ (was 22 min) | < 15 min |
| Avg duration (quick-fix) | 4 min | → (stable) | < 5 min ✅ |
| Correction loop rate | 33% (2/6 pipelines) | ↓ (was 50%) | < 20% |
| First-attempt pass rate | 67% | ↑ (was 50%) | > 80% |

### Quality Trends (last 6 pipelines)
| Pipeline | Type | Loops | Pass 1st? | Security | Regressions |
|---|---|---|---|---|---|
| pipe-001 | full | 2 | ❌ | 1 high | 0 |
| pipe-002 | quick | 0 | ✅ | 0 | 0 |
| pipe-003 | full | 1 | ❌ | 0 | 1 |
| pipe-004 | research | 0 | ✅ | — | — |
| pipe-005 | full | 0 | ✅ | 1 medium | 0 |
| pipe-006 | quick | 0 | ✅ | 0 | 0 |

### Key Insight
Builder's auth check misses account for 100% of correction loops in full pipelines.
After adding auth checklist to Builder's prompt (pipe-005), correction loops dropped to 0.

### Project Health Score
| Indicator | Score | Status |
|---|---|---|
| Technical Debt | 3/5 | 🟡 Stable — some debt from rushed MVP |
| Velocity | 4/5 | 🟢 Good — 3 features/week |
| Quality | 3/5 | 🟡 Improving — correction loops decreasing |
| Documentation | 4/5 | 🟢 Good — all features documented |
| Test Coverage | 3/5 | 🟡 68% — needs to reach 80% |
| **Overall** | **3.4/5** | **🟡 Healthy with room for improvement** |

### Recommendations
1. **HIGH:** Add auth check to Builder's pre-delivery checklist (prevents most common correction loop)
2. **MEDIUM:** Increase test coverage target to 80% — current 68% allows bugs to escape
3. **LOW:** Investigate framework handling of research tasks — could be more efficient with cached results
```
