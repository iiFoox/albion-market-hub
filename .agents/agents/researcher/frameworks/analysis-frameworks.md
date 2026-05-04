# Researcher Analysis Frameworks

> **Category:** Researcher / Decision Frameworks
> **Usage:** Structured analysis tools for technology evaluation and risk assessment

---

## 1. Technology Evaluation Matrix

### Weighted Scoring Model
```
CRITERIA (adjust weights per project):
| Criterion            | Weight | Score (1-5) | Weighted |
|---|---|---|---|
| Community & Ecosystem | 20%   | [assess]    | [w×s]   |
| Performance           | 15%   | [assess]    | [w×s]   |
| Learning Curve        | 15%   | [assess]    | [w×s]   |
| Long-term Viability   | 15%   | [assess]    | [w×s]   |
| Developer Experience  | 10%   | [assess]    | [w×s]   |
| Security Track Record | 10%   | [assess]    | [w×s]   |
| Team Expertise        | 10%   | [assess]    | [w×s]   |
| Cost (License/Hosting)| 5%    | [assess]    | [w×s]   |
| **TOTAL**             | 100%  |             | [sum]   |

SCORING:
1 = Poor / Major concerns
2 = Below average / Some concerns
3 = Average / Acceptable
4 = Good / Minor concerns
5 = Excellent / No concerns

DECISION:
→ Score > 4.0: Strong recommendation
→ Score 3.0-4.0: Acceptable with caveats
→ Score < 3.0: Not recommended
```

---

## 2. Make vs Buy Analysis

```
EVALUATE:

BUILD (custom):
+ Full control over features and roadmap
+ No vendor lock-in
+ Exact fit for requirements
- Higher initial cost (dev time)
- Ongoing maintenance burden
- Security responsibility

BUY (third-party):
+ Faster time to market
+ Maintained by vendor
+ Battle-tested at scale
- Vendor lock-in risk
- May not fit exactly
- Recurring cost

DECISION FRAMEWORK:
→ Is this core to our business? BUILD (competitive advantage)
→ Is this commodity? BUY (auth, payments, email, monitoring)
→ Can we outperform the vendor? Probably not. BUY.
→ Is vendor lock-in acceptable? If not, BUILD or use open-source.
```

---

## 3. Technical Debt Assessment

```
DEBT CATEGORIES:
| Category | Example | Impact | Effort to Fix |
|---|---|---|---|
| Architecture | Monolith needing extraction | HIGH | HIGH |
| Code Quality | Duplicated logic, no tests | MEDIUM | MEDIUM |
| Dependencies | Outdated packages with CVEs | HIGH | LOW-MED |
| Infrastructure | Manual deployments | MEDIUM | MEDIUM |
| Documentation | No API docs, no ADRs | LOW-MED | LOW |

PRIORITIZATION (Impact × Urgency):
→ HIGH impact + HIGH urgency → Fix NOW (security, data loss risk)
→ HIGH impact + LOW urgency → Plan for next sprint
→ LOW impact + HIGH urgency → Quick fix if easy
→ LOW impact + LOW urgency → Backlog

DEBT RATIO:
debt_ratio = (time_on_debt_items / total_dev_time) × 100
→ < 10%: Healthy
→ 10-20%: Manageable
→ 20-30%: Concerning — allocate more capacity
→ > 30%: Critical — stop features, pay down debt
```

---

## 4. Dependency Health Scorecard

```
FOR EACH CRITICAL DEPENDENCY, SCORE:

| Factor | Score | How to Check |
|---|---|---|
| Last release | [1-5] | npm info <pkg> time |
| Open issues ratio | [1-5] | GitHub issues vs stars |
| Maintainer count | [1-5] | Bus factor > 1? |
| Download trend | [1-5] | npm trends comparison |
| CVE history | [1-5] | Snyk/npm audit |
| License | [1-5] | MIT/Apache = 5, GPL = 3 |
| TypeScript support | [1-5] | Native types = 5 |
| **Average** | [avg] | |

RISK LEVELS:
→ Score > 4: Low risk — safe to depend on
→ Score 3-4: Medium risk — have migration plan
→ Score < 3: High risk — find alternative
```

---

## 5. Architecture Fitness Functions

```
MEASURABLE QUALITY ATTRIBUTES:

Performance:
→ p95 response time < 200ms
→ p99 response time < 1s
→ Throughput > 1000 req/s

Availability:
→ Uptime > 99.9% (8.7h downtime/year)
→ Mean time to recovery (MTTR) < 30 min

Security:
→ 0 critical CVEs in dependencies
→ All OWASP Top 10 mitigated
→ Secret rotation < 90 days

Maintainability:
→ Test coverage > 80%
→ Cyclomatic complexity < 10 per function
→ Deployment frequency: daily or more
→ Change failure rate < 15%
```
