# Organization Standards — Multi-Project Configuration

> **Category:** Global / Multi-Project Support
> **Usage:** Centralized standards that apply across ALL projects in the organization

---

## Organization Identity

```yaml
organization:
  name: "[Organization Name]"
  default_language: "pt-BR"           # Communication language
  technical_language: "en"            # Code, docs, commits in English

coding_standards:
  language: "TypeScript"              # Default when not specified
  strict_mode: true                   # Always strict TypeScript
  linting: "eslint + prettier"
  commit_format: "conventional-commits"  # feat:, fix:, chore:, etc.
  branch_strategy: "github-flow"      # main + feature branches
  
quality_standards:
  min_test_coverage: 80               # Percentage
  max_cyclomatic_complexity: 10       # Per function
  max_file_length: 300                # Lines
  max_function_length: 50             # Lines
  required_reviews: 1                 # Minimum PR reviewers
  
security_standards:
  auth_pattern: "jwt-with-refresh"    # Default auth approach
  password_hashing: "bcrypt-12"       # Algorithm + cost
  encryption_at_rest: true
  https_only: true
  cors_restrictive: true
  rate_limiting: true
  
documentation_standards:
  readme: required
  api_docs: required                  # For any project with API
  adr: required                       # For architectural decisions
  changelog: required
  inline_comments: "why-not-what"     # Comment philosophy
```

## Shared Knowledge Protocol

```
WHEN A PROJECT LEARNS SOMETHING REUSABLE:
1. PM agent flags the learning as "cross-project"
2. Learning is tagged with:
   → Category (architecture, security, performance, debugging, etc.)
   → Technologies involved
   → Confidence level (from single project = medium, validated across projects = high)
3. Learning is stored in global/shared-knowledge/
4. ALL projects automatically benefit from new global learnings

EXAMPLES OF SHAREABLE KNOWLEDGE:
→ "Prisma connection pool default of 5 is too low for auth-heavy apps"
→ "React 19 use() hook causes hydration errors with streaming SSR when..."
→ "PostgreSQL partial indexes reduce index size by 60% for soft-deleted tables"
```

## Project Customization

```
OVERRIDE HIERARCHY (most specific wins):
1. Organization defaults (this file)
2. Profile overrides (fintech, healthcare, etc.)
3. Project-specific overrides (.agents/config/project.yaml)

EXAMPLE:
Organization says: min_test_coverage = 80%
Fintech profile says: min_test_coverage = 95%  (stricter)
Project says: min_test_coverage = 90%          (project override)
→ RESULT: 90% (project-specific wins)
```

## Multi-Project Memory Configuration

```yaml
# .agents/config/multi-project.yaml
multi_project:
  enabled: true
  
  shared_memory:
    sync_interval: "on-pipeline-complete"  # When to sync learnings
    categories:
      - architecture-decisions
      - security-learnings
      - performance-optimizations
      - debugging-solutions
      - dependency-warnings
    
  isolation:
    # These are NEVER shared between projects
    - project-specific-features
    - database-schemas
    - api-contracts
    - environment-configs
    - credentials
    
  knowledge_graph:
    cross_reference: true               # Link related knowledge across projects
    deduplication: true                  # Merge similar entries
    decay_enabled: true                 # Unused knowledge loses relevance
    decay_half_life_days: 90            # 50% relevance after 90 days unused
```
