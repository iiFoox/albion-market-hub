# Security Knowledge Base — Authentication Patterns

> **Category:** Security / Auth
> **Usage:** Referenced by Validator (security audit) and Builder (implementation)

---

## Authentication Pattern Decision

```
WHICH AUTH PATTERN?
│
├── Traditional web app (server-rendered)?
│   └── Session-based auth (cookies)
│
├── SPA / Mobile app consuming API?
│   └── JWT (access + refresh tokens)
│
├── Third-party login (Google, GitHub)?
│   └── OAuth 2.0 / OIDC
│
├── Machine-to-machine API?
│   └── API Keys + HMAC
│
└── Enterprise SSO?
    └── SAML / OIDC with IdP
```

## Pattern 1: Session-Based Auth

```
Best For: Traditional web apps, server-rendered pages
Security: HIGH (session data stays on server)

Flow:
1. User sends credentials → Server validates
2. Server creates session → stores in Redis/DB
3. Server sends session ID in HttpOnly cookie
4. Browser sends cookie on every request
5. Server validates session on each request

Pros:
✅ Session data never exposed to client
✅ Easy to revoke (delete session)
✅ HttpOnly cookie prevents XSS theft
✅ CSRF protection with SameSite + CSRF token

Cons:
❌ Requires server-side storage (Redis/DB)
❌ Sticky sessions in load-balanced environments
❌ Not ideal for mobile apps
```

## Pattern 2: JWT (JSON Web Tokens)

```
Best For: SPAs, Mobile apps, Microservices
Security: MEDIUM (token is on client; needs refresh token rotation)

Flow:
1. User sends credentials → Server validates
2. Server creates JWT (access token) + Refresh token
3. Access token: short-lived (15 min), stored in memory
4. Refresh token: long-lived (7 days), stored in HttpOnly cookie
5. Client sends access token in Authorization header
6. When access token expires → use refresh token to get new one

CRITICAL RULES:
→ Access token: SHORT lived (15 min max)
→ Refresh token: HttpOnly, Secure, SameSite cookie
→ NEVER store access token in localStorage (XSS vulnerable)
→ Implement refresh token rotation (new refresh token on each use)
→ Implement reuse detection (if old refresh token used → revoke all)
```

### JWT Implementation
```typescript
// Token generation
import jwt from 'jsonwebtoken';

function generateTokens(userId: string): { accessToken: string; refreshToken: string } {
  const accessToken = jwt.sign(
    { sub: userId, type: 'access' },
    process.env.JWT_ACCESS_SECRET!,
    { expiresIn: '15m' }
  );

  const refreshToken = jwt.sign(
    { sub: userId, type: 'refresh', jti: crypto.randomUUID() },
    process.env.JWT_REFRESH_SECRET!,
    { expiresIn: '7d' }
  );

  return { accessToken, refreshToken };
}

// Refresh token rotation
async function refreshAccessToken(oldRefreshToken: string) {
  const payload = jwt.verify(oldRefreshToken, process.env.JWT_REFRESH_SECRET!);
  
  // Check if token was already used (reuse detection)
  const storedToken = await redis.get(`refresh:${payload.jti}`);
  if (!storedToken) {
    // Token reuse detected! Revoke ALL user tokens
    await redis.del(`user-tokens:${payload.sub}`);
    throw new Error('Refresh token reuse detected — all sessions revoked');
  }

  // Invalidate old refresh token
  await redis.del(`refresh:${payload.jti}`);

  // Generate new token pair
  return generateTokens(payload.sub);
}
```

## Pattern 3: OAuth 2.0 / OIDC

```
Best For: "Login with Google/GitHub/Microsoft"
Security: HIGH (delegated to trusted provider)

Flows:
→ Authorization Code + PKCE (SPAs, mobile) — RECOMMENDED
→ Authorization Code (server-side apps) — traditional
→ Client Credentials (machine-to-machine) — no user involved

CRITICAL:
→ Always use PKCE for public clients (SPAs, mobile)
→ Validate ID token signature and claims
→ Store tokens securely (HttpOnly cookies)
→ Use state parameter to prevent CSRF
```

## Pattern 4: API Keys

```
Best For: Machine-to-machine, developer APIs
Security: MEDIUM (key is a shared secret)

Rules:
→ Generate with crypto-safe randomness (32+ bytes)
→ Hash before storing (bcrypt or SHA-256)
→ Prefix for identification: "sk_live_abc123" (Stripe pattern)
→ Allow multiple keys per user (rotate without downtime)
→ Set expiration dates
→ Log all key usage
→ Rate limit per key
```

---

## Password Security

```
HASHING:
→ Use bcrypt (cost 12) or Argon2id
→ NEVER use MD5, SHA1, SHA256 for passwords
→ NEVER store plaintext passwords

POLICY:
→ Minimum 8 characters
→ Check against breached password lists (haveibeenpwned API)
→ NO complexity requirements (NIST 800-63B recommends against them)
→ Allow paste in password fields
→ Rate limit login attempts (5 failures → lockout 15 min)
```

## Security Headers
```typescript
// Essential security headers (use helmet middleware)
{
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'X-XSS-Protection': '0',  // Disabled — CSP is better
  'Content-Security-Policy': "default-src 'self'; script-src 'self'",
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'camera=(), microphone=(), geolocation=()',
}
```
