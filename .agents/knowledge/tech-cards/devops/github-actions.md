# GitHub Actions — Tech Card

> **Category:** CI/CD
> **Type:** Workflow automation platform

---

## Basic Workflow
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run test
      - run: npm run build

  deploy:
    needs: test  # Only runs after test passes
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Deploy to production"
```

## Full Production Pipeline
```yaml
name: Production Pipeline

on:
  push:
    branches: [main]

env:
  NODE_VERSION: 22
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: 'npm' }
      - run: npm ci
      - run: npm run lint
      - run: npx tsc --noEmit  # Type check

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:17
        env: { POSTGRES_PASSWORD: test, POSTGRES_DB: testdb }
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready --health-interval 10s
          --health-timeout 5s --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: 'npm' }
      - run: npm ci
      - run: npx prisma migrate deploy
        env: { DATABASE_URL: postgresql://postgres:test@localhost:5432/testdb }
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        with: { name: coverage, path: coverage/ }

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm audit --audit-level=high
      - uses: aquasecurity/trivy-action@master
        with: { scan-type: 'fs', severity: 'HIGH,CRITICAL' }

  build-and-push:
    needs: [lint, test, security]
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Best Practices

1. **Cache dependencies** — `actions/setup-node` with `cache: 'npm'`
2. **Use `npm ci`** — deterministic installs from lockfile (not `npm install`)
3. **Run jobs in parallel** — lint, test, security can all run simultaneously
4. **Use `needs`** — deploy only after test passes
5. **Use services** — spin up PostgreSQL, Redis in CI with `services:`
6. **Pin action versions** — `actions/checkout@v4` not `@latest`
7. **Use secrets** — `${{ secrets.API_KEY }}` never hardcode
8. **Use environments** — staging, production with required approvals
9. **Upload artifacts** — test coverage, build outputs for review
10. **Use matrix strategy** — test across multiple Node.js versions

## Common Triggers
```yaml
on:
  push: { branches: [main] }              # Push to main
  pull_request: { branches: [main] }      # PR to main
  schedule: [{ cron: '0 6 * * 1' }]       # Weekly Monday 6am
  workflow_dispatch:                        # Manual trigger
  release: { types: [published] }          # New release
```

## Security Checklist
- [ ] Use `${{ secrets.* }}` for ALL sensitive values
- [ ] Pin actions to specific SHA (not just tag) for critical workflows
- [ ] Use `permissions` to limit GITHUB_TOKEN scope
- [ ] Enable required status checks on `main` branch
- [ ] Run `npm audit` and container scanning in CI
- [ ] Use environments with deployment protection rules
