# API Security Knowledge Base

> **Category:** Security / API Protection
> **Usage:** Referenced by Validator (security audit) and Builder (implementation)

---

## Input Validation

### Rule: NEVER TRUST USER INPUT

```typescript
// ✅ Validate with schema (Zod)
const CreateUserSchema = z.object({
  email: z.string().email().max(254),
  name: z.string().min(1).max(100).trim(),
  age: z.number().int().min(13).max(150),
});

// ✅ Use safeParse (doesn't throw)
const result = CreateUserSchema.safeParse(req.body);
if (!result.success) {
  return res.status(400).json({ error: 'Validation failed', details: result.error.flatten() });
}
const validatedData = result.data;  // Type-safe, validated

// ❌ NEVER do this
const { email, name } = req.body;  // No validation!
await db.user.create({ data: req.body });  // Mass assignment vulnerability!
```

## Rate Limiting

```typescript
// Essential rate limits
const RATE_LIMITS = {
  'login':           { window: '15m', max: 5 },    // Brute force protection
  'register':        { window: '1h',  max: 3 },    // Spam prevention
  'password-reset':  { window: '1h',  max: 3 },    // Email bombing
  'api-general':     { window: '1m',  max: 100 },  // General API protection
  'file-upload':     { window: '1h',  max: 10 },   // Storage abuse
  'search':          { window: '1m',  max: 30 },    // Expensive queries
};

// Implementation (express-rate-limit)
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: { error: 'Too many login attempts. Try again in 15 minutes.' },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip + ':' + req.body.email,  // Per IP + email
});

app.post('/api/auth/login', loginLimiter, loginHandler);
```

## CORS Configuration

```typescript
// ✅ Restrictive CORS (production)
const corsOptions = {
  origin: ['https://myapp.com', 'https://admin.myapp.com'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  maxAge: 86400,  // Cache preflight for 24h
};

// ❌ NEVER in production
const corsOptions = { origin: '*' };  // Allows ANY origin
```

## Error Handling (Security)

```typescript
// ✅ Production: Generic errors to users
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  // Log full error internally
  logger.error('Unhandled error', {
    error: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    ip: req.ip,
  });

  // Return generic error to user (no details!)
  res.status(500).json({
    error: 'Internal server error',
    requestId: req.id,  // For support tickets
  });
});

// ❌ NEVER expose internals
res.status(500).json({
  error: err.message,        // Exposes implementation details
  stack: err.stack,           // Exposes file paths and code structure
  query: sqlQuery,            // Exposes database schema
});
```

## File Upload Security

```
RULES:
1. Validate file type by CONTENT, not just extension
   → .jpg renamed to .exe still has .exe content
2. Limit file size (server-side, not just client)
3. Generate random filenames (don't use original name)
4. Store outside web root (can't be directly accessed)
5. Scan for malware if accepting documents
6. Use signed URLs for access (not public URLs)
7. Set Content-Disposition: attachment for downloads

DANGEROUS FILE TYPES:
→ .svg (can contain JavaScript!)
→ .html (XSS via file upload)
→ .exe, .bat, .sh (command execution)
→ .zip (zip bombs — 1KB → 1TB decompressed)
```

## API Key Security

```
GENERATION:
→ Use crypto.randomBytes(32).toString('base64url')
→ NEVER use Math.random() or UUID for API keys

STORAGE:
→ Hash API keys before storing (SHA-256 is sufficient)
→ Store prefix for lookup: "sk_live_" + first 8 chars (unhashed)
→ Full key shown to user ONLY once at creation

TRANSMISSION:
→ Always HTTPS
→ Send in header: Authorization: Bearer <key>
→ NEVER in URL query params (logged in server access logs)
```

## OWASP API Security Top 10 (2023) Quick Reference

| # | Risk | Prevention |
|---|---|---|
| API1 | Broken Object Level Authorization | Check ownership: `WHERE id = :id AND user_id = :userId` |
| API2 | Broken Authentication | JWT rotation, rate limiting, MFA |
| API3 | Broken Object Property Level Auth | Don't expose internal fields; use select/denylist |
| API4 | Unrestricted Resource Consumption | Rate limiting, pagination limits, file size limits |
| API5 | Broken Function Level Authorization | Middleware auth check on ALL endpoints |
| API6 | Unrestricted Access to Sensitive Flows | Rate limit business-critical operations |
| API7 | Server Side Request Forgery (SSRF) | Validate/whitelist external URLs |
| API8 | Security Misconfiguration | Security headers, disable debug, remove defaults |
| API9 | Improper Inventory Management | Document ALL APIs, deprecate old versions |
| API10 | Unsafe Consumption of APIs | Validate data from third-party APIs too |
