# Docker — Tech Card

> **Category:** Containerization / DevOps
> **Type:** Container runtime and build system

---

## Essential Commands
```bash
# Build
docker build -t myapp:1.0 .
docker build -t myapp:1.0 --target production .  # Multi-stage

# Run
docker run -d -p 3000:3000 --name myapp myapp:1.0
docker run -d -p 3000:3000 --env-file .env myapp:1.0

# Compose
docker compose up -d
docker compose down
docker compose logs -f myapp

# Debug
docker exec -it myapp sh
docker logs myapp --tail 100 -f
docker stats  # CPU/Memory usage
```

## Production Dockerfile (Node.js)
```dockerfile
# ---- Build Stage ----
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build
RUN npm prune --production

# ---- Production Stage ----
FROM node:22-alpine AS production
WORKDIR /app

# Security: non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup
    
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json ./

USER appuser
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/main.js"]
```

## Docker Compose (Full Stack)
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: production
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:secret@db:5432/mydb
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:17-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5

  cache:
    image: redis:8-alpine
    volumes:
      - redisdata:/data

volumes:
  pgdata:
  redisdata:
```

## Best Practices

1. **Multi-stage builds** — separate build and production stages
2. **Use Alpine images** — `node:22-alpine` is ~50MB vs ~300MB for full
3. **Non-root user** — never run as root in production
4. **`COPY package*.json` first** — leverages Docker layer cache for `npm ci`
5. **Use `.dockerignore`** — exclude `node_modules`, `.git`, `.env`
6. **Health checks** — Docker monitors container health
7. **Use `npm ci`** — deterministic installs from lockfile
8. **One process per container** — don't run multiple services in one container
9. **Use secrets management** — Docker secrets or env file, never bake into image
10. **Tag images explicitly** — `myapp:1.0.3`, never just `myapp:latest` in production

## .dockerignore
```
node_modules
.git
.env*
Dockerfile
docker-compose*.yml
*.md
.vscode
.idea
coverage
dist
```

## Security Checklist
- [ ] Run as non-root user
- [ ] Use specific image tags (not `latest`)
- [ ] Scan images for CVEs (`docker scout`, `trivy`)
- [ ] Don't store secrets in image layers
- [ ] Use multi-stage builds (no build tools in production)
- [ ] Set read-only filesystem where possible
- [ ] Limit container resources (`--memory`, `--cpus`)
