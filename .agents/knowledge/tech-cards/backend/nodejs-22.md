# Node.js 22 — Tech Card

> **Category:** Backend Runtime
> **Current Version:** 22.x (LTS)
> **Type:** JavaScript/TypeScript Runtime

---

## Key Features (v22)
- **Native TypeScript support** — `--experimental-strip-types` (no transpiler needed)
- **Built-in test runner** — `node --test` (no Jest dependency for simple tests)
- **Native fetch** — globally available (no `node-fetch` needed)
- **WebSocket API** — built-in WebSocket client
- **Permission model** — `--experimental-permission` (restrict file/network access)
- **Watch mode** — `node --watch` (no `nodemon` needed)
- **Single executable** — compile Node.js app to standalone binary
- **ESM by default** — `"type": "module"` in package.json

## Top 10 Best Practices

1. **Use TypeScript** — type safety prevents entire categories of bugs
2. **Use ESM** — `import/export` is the standard; CJS is legacy
3. **Use `node:` prefix** — `import fs from 'node:fs'` for clarity
4. **Handle errors properly** — unhandled rejections crash in v22
5. **Use streams** for large files — don't load entire file into memory
6. **Use worker threads** for CPU-intensive tasks — don't block event loop
7. **Use environment variables** for config — `process.env` with validation
8. **Use connection pooling** — for database connections
9. **Implement graceful shutdown** — handle SIGTERM, close connections, drain requests
10. **Pin dependencies** — `npm ci` with lockfile in CI

## Top 10 Gotchas

1. ❌ **Blocking the event loop** — CPU-heavy sync operations block ALL requests
2. ❌ **Memory leaks from event listeners** — `removeListener` or `off` when done
3. ❌ **Not awaiting promises** — fire-and-forget loses errors silently
4. ❌ **Callback hell** — use async/await; callbacks are legacy pattern
5. ❌ **`require()` in ESM** — use `import` or `createRequire(import.meta.url)`
6. ❌ **Global error handlers only** — handle errors locally where possible
7. ❌ **Not validating environment variables** — missing vars cause runtime crashes
8. ❌ **`JSON.parse` without try/catch** — crashes on malformed input
9. ❌ **Synchronous file operations** — `readFileSync` blocks event loop; use `readFile`
10. ❌ **Not setting NODE_ENV** — many libs behave differently in development vs production

## Graceful Shutdown Pattern
```typescript
import { createServer } from 'node:http';

const server = createServer(app);

async function gracefulShutdown(signal: string) {
  console.log(`Received ${signal}. Starting graceful shutdown...`);
  
  // 1. Stop accepting new connections
  server.close(() => {
    console.log('HTTP server closed');
  });
  
  // 2. Close database connections
  await prisma.$disconnect();
  
  // 3. Close message queue connections
  await rabbitMQ.close();
  
  // 4. Exit
  console.log('Graceful shutdown complete');
  process.exit(0);
}

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Catch unhandled errors
process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});
```

## Performance Tips
- Use `cluster` module or PM2 for multi-core CPU utilization
- Use `compression` middleware for response compression
- Use `node --prof` for CPU profiling
- Use `--max-old-space-size` to adjust heap memory limit
- Use `AbortController` for request timeout management
- Monitor event loop delay with `perf_hooks.monitorEventLoopDelay()`

## Security Checklist
- [ ] Keep Node.js on latest LTS version
- [ ] Use `helmet` middleware for security headers
- [ ] Rate limit API endpoints (`express-rate-limit`)
- [ ] Validate ALL input with Zod/Joi
- [ ] Use `npm audit` in CI pipeline
- [ ] Never use `eval()` or `new Function()` with user input
- [ ] Set `NODE_ENV=production` in production
- [ ] Use HTTPS with TLS 1.3
