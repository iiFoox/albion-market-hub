# SaaS Web App Blueprint

> **Category:** Planner / Project Blueprint
> **Usage:** Reference architecture and phased delivery plan for SaaS applications

---

## Reference Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         CDN (Vercel/CloudFront)             │
│                    Static assets + ISR pages                │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                    Next.js Application                       │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────┐│
│  │  Public Site  │ │   App (Auth) │ │   Admin Dashboard    ││
│  │  (Marketing)  │ │  (Customer)  │ │     (Internal)       ││
│  └──────────────┘ └──────┬───────┘ └──────────┬───────────┘│
└──────────────────────────┼────────────────────┼─────────────┘
                           │                    │
┌──────────────────────────▼────────────────────▼─────────────┐
│                       API Layer                              │
│            Route Handlers + Server Actions                    │
│  ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐ │
│  │    Auth     │ │   CRUD   │ │ Business │ │  Webhooks    │ │
│  │  (NextAuth) │ │   APIs   │ │  Logic   │ │  (Stripe..)  │ │
│  └────────────┘ └──────────┘ └──────────┘ └──────────────┘ │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                   Infrastructure                             │
│  ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐ │
│  │ PostgreSQL  │ │  Redis   │ │  S3/Blob │ │   Queue      │ │
│  │  (Prisma)   │ │ (Cache)  │ │ (Files)  │ │ (BullMQ)     │ │
│  └────────────┘ └──────────┘ └──────────┘ └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Phased Delivery

### Phase 1: Foundation (Week 1-2)
```
DELIVERABLES:
□ Project setup (Next.js 15 + TypeScript + Prisma + Tailwind)
□ Auth system (NextAuth v5 — email/password + Google OAuth)
□ Database schema (users, organizations, roles)
□ Core UI layout (sidebar, header, responsive shell)
□ Environment setup (dev, staging, prod)
□ CI/CD pipeline (GitHub Actions → Vercel)

ACCEPTANCE CRITERIA:
→ User can register, login, logout
→ Protected routes redirect to login
→ CI/CD deploys on push to main
```

### Phase 2: Core Features (Week 3-5)
```
DELIVERABLES:
□ CRUD for primary entities
□ Dashboard with key metrics
□ File upload (avatar, documents)
□ Email notifications (transactional)
□ Settings page (profile, password, preferences)
□ Role-based access control (RBAC)

ACCEPTANCE CRITERIA:
→ All CRUD operations work with validation
→ Dashboard shows real data
→ Files upload to cloud storage
→ Email sends on key events
```

### Phase 3: Business Logic (Week 6-8)
```
DELIVERABLES:
□ Payment integration (Stripe subscriptions)
□ Multi-tenant data isolation
□ Advanced search and filtering
□ Export data (CSV/PDF)
□ Audit logging
□ Webhooks (incoming and outgoing)

ACCEPTANCE CRITERIA:
→ Stripe checkout flow works end-to-end
→ Tenant data is fully isolated (RLS)
→ Search works with facets and sorting
```

### Phase 4: Polish & Scale (Week 9-10)
```
DELIVERABLES:
□ Performance optimization (< 2s LCP)
□ Error tracking (Sentry)
□ Analytics (PostHog/Mixpanel)
□ Onboarding flow (guided tour)
□ Help center / documentation
□ Accessibility audit (WCAG 2.1 AA)

ACCEPTANCE CRITERIA:
→ Lighthouse score > 90
→ Error tracking catches all unhandled errors
→ Onboarding completion rate > 70%
```

## MVP Scope Definition

```
MVP = Phase 1 + Phase 2 (Minimum Viable Product)

MVP INCLUDES:
✅ Auth (register, login, logout, forgot password)
✅ CRUD for 2-3 core entities
✅ Dashboard with basic metrics
✅ Responsive UI
✅ Deploy to production

MVP EXCLUDES:
❌ Payment (add in Phase 3)
❌ Multi-tenant (add in Phase 3)
❌ Advanced analytics (add in Phase 4)
❌ Mobile app (future phase)
❌ Admin dashboard (future phase)
```

## Tech Stack Recommendation

| Component | Recommendation | Alternative |
|---|---|---|
| **Framework** | Next.js 15 (App Router) | Remix, Nuxt 3 |
| **Language** | TypeScript (strict) | — |
| **Styling** | Tailwind CSS + shadcn/ui | Chakra UI, MUI |
| **Database** | PostgreSQL 17 + Prisma | Drizzle ORM |
| **Auth** | NextAuth v5 | Clerk, Lucia |
| **Cache** | Redis | Upstash (serverless) |
| **File Storage** | Vercel Blob / AWS S3 | Cloudinary |
| **Email** | Resend + React Email | SendGrid |
| **Payments** | Stripe | LemonSqueezy |
| **Deploy** | Vercel | Railway, AWS |
| **Monitoring** | Sentry + Vercel Analytics | Datadog |

## Scale Plan (MVP → Growth)

```
WHEN         → WHAT TO DO
100 users    → Monitor performance, fix bottlenecks
1K users     → Add Redis caching, optimize DB queries
10K users    → Add CDN, implement rate limiting, add read replicas
100K users   → Consider microservices extraction, horizontal scaling
1M users     → Dedicated DevOps, multi-region, SRE practices
```
