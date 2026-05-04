# OWASP Top 10 — Quick Reference Security KB

> **Category:** Security / Web Application Vulnerabilities
> **Version:** OWASP 2021
> **Usage:** Referenced by Validator (security audit) and Builder (secure coding)

---

## A01: Broken Access Control (94% of apps tested)

**What:** Users access data/actions beyond their permissions.

**Common Attacks:**
- IDOR: Change `?userId=123` to `?userId=456` to access other user's data
- Path traversal: `../../etc/passwd`
- Missing function-level access control: regular user accessing admin endpoints

**Prevention:**
```typescript
// ✅ Always verify ownership
const order = await db.order.findFirst({
  where: { id: orderId, userId: session.user.id }  // AND userId
});

// ❌ NEVER trust client-provided IDs without ownership check
const order = await db.order.findFirst({ where: { id: orderId } });
```

---

## A02: Cryptographic Failures

**What:** Sensitive data exposed due to weak or missing encryption.

**Rules:**
- Passwords: bcrypt (cost 12) or Argon2id — NEVER MD5/SHA
- Data in transit: TLS 1.3 (HTTPS everywhere)
- Data at rest: AES-256-GCM for sensitive fields
- Secrets: Environment variables or vault — NEVER in code
- Tokens: `crypto.randomBytes(32)` — NEVER `Math.random()`

---

## A03: Injection

**What:** Untrusted data is sent to an interpreter.

**Types & Prevention:**
```
SQL Injection:
✅ Use parameterized queries (Prisma, SQLAlchemy auto-parameterize)
❌ db.query(`SELECT * FROM users WHERE email = '${email}'`)

XSS:
✅ React auto-escapes JSX content
✅ Use DOMPurify for user HTML
❌ dangerouslySetInnerHTML with unvalidated content

Command Injection:
✅ Use child_process.execFile (no shell interpretation)
❌ exec(`convert ${userInput}.png output.jpg`)
```

---

## A04: Insecure Design

**What:** Fundamental design flaws that can't be fixed by implementation.

**Prevention:**
- Threat modeling during design phase
- Abuse case analysis (what could an attacker do?)
- Rate limiting on business-critical operations
- Fail-closed design (deny by default)

---

## A05: Security Misconfiguration

**Checklist:**
- [ ] Remove default credentials
- [ ] Disable directory listing
- [ ] Set security headers (CSP, HSTS, X-Frame-Options)
- [ ] Disable debug mode in production
- [ ] Remove unnecessary features/endpoints
- [ ] Keep software updated (OS, framework, libraries)
- [ ] Error messages don't expose internals

---

## A06: Vulnerable Components

**Prevention:**
```bash
# Node.js: Check for known vulnerabilities
npm audit
npm audit fix

# Python
pip-audit

# .NET
dotnet list package --vulnerable

# Automate with Dependabot or Renovate
```

---

## A07: Identification & Authentication Failures

**Checklist:**
- [ ] Rate limit login attempts (5 failures → lockout 15 min)
- [ ] Use MFA for sensitive operations
- [ ] Hash passwords with bcrypt/Argon2 (never MD5/SHA)
- [ ] Implement proper session management
- [ ] Generate strong session/token IDs
- [ ] Invalidate sessions on logout

---

## A08: Software & Data Integrity Failures

**Prevention:**
- Verify package integrity (`npm ci` with lockfile)
- Use Subresource Integrity (SRI) for CDN scripts
- Validate software updates with signatures
- CI/CD pipeline security (signed commits, protected branches)

---

## A09: Security Logging & Monitoring Failures

**What to Log:**
```typescript
// ✅ Log security events
logger.warn('AUTH_FAILURE', { email, ip, userAgent, timestamp });
logger.warn('ACCESS_DENIED', { userId, resource, action, ip });
logger.info('PERMISSION_CHANGE', { targetUser, newRole, changedBy });

// ❌ NEVER log
logger.info('Login', { email, password });  // PII + credentials!
logger.debug('SQL', { query: rawSqlQuery }); // Schema exposure!
```

---

## A10: Server-Side Request Forgery (SSRF)

**What:** App fetches URL provided by user, accessing internal resources.

**Prevention:**
```typescript
// ✅ Whitelist allowed domains
const ALLOWED_HOSTS = ['api.stripe.com', 'api.github.com'];
const url = new URL(userInput);
if (!ALLOWED_HOSTS.includes(url.hostname)) {
  throw new Error('Domain not allowed');
}

// ✅ Block internal IPs
const BLOCKED_RANGES = ['10.', '172.16.', '192.168.', '127.', '169.254.'];
if (BLOCKED_RANGES.some(range => resolvedIP.startsWith(range))) {
  throw new Error('Internal addresses blocked');
}
```
