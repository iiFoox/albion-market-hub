# Next.js 15 — Tech Card

> **Category:** Frontend Framework (Full-stack React)
> **Current Version:** 15.x (App Router era)
> **Runtime:** Node.js 20+

---

## Quick Setup
```bash
npx -y create-next-app@latest ./ --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

## Key Features (v15)
- **App Router** (default) — file-system routing with layouts, loading, error boundaries
- **Server Components** (default) — components render on server, zero JS sent to client
- **Server Actions** — form handling with `"use server"` functions
- **Partial Prerendering** — static shell + dynamic streaming
- **Turbopack** — Rust-based bundler (10x faster HMR)

## Top 10 Best Practices

1. **Use Server Components by default** — only add `"use client"` when you need interactivity
2. **Colocate data fetching** — fetch data in the component that needs it, not in parent
3. **Use `loading.tsx`** — automatic Suspense boundaries per route
4. **Use `error.tsx`** — automatic error boundaries per route
5. **Validate with Zod** on server side — never trust client data
6. **Use `revalidatePath/revalidateTag`** for cache invalidation, not `no-store` everywhere
7. **Use route groups `(group)/`** — organize routes without affecting URL
8. **Use `generateMetadata`** — dynamic SEO metadata generation
9. **Use middleware** — auth checks, redirects, geolocation at edge
10. **Use Next.js Image** — automatic optimization, lazy loading, responsive sizes

## Top 10 Gotchas / Armadilhas

1. ❌ **`"use client"` doesn't mean client-only** — it's a boundary, not a ban on SSR
2. ❌ **Fetching in `useEffect` for initial data** — use Server Components instead
3. ❌ **`localStorage` in Server Component** — it's server-side, no browser APIs
4. ❌ **Importing client lib in Server Component** — use dynamic import with `ssr: false`
5. ❌ **Not handling `loading.tsx`** — users see blank page during navigation
6. ❌ **Massive `layout.tsx`** — keep layouts thin; heavy logic goes in page or components
7. ❌ **`cookies()` / `headers()` in cached routes** — makes route dynamic automatically
8. ❌ **`fetch()` caching by default in v15** — changed to `no-store` by default (unlike v14)
9. ❌ **Environment variables without `NEXT_PUBLIC_`** — won't be available on client
10. ❌ **Giant client bundles** — check `@next/bundle-analyzer` regularly

## Project Structure
```
src/
├── app/                        # App Router
│   ├── (auth)/                # Route group: auth pages
│   │   ├── login/page.tsx
│   │   └── register/page.tsx
│   ├── (dashboard)/           # Route group: authenticated area
│   │   ├── layout.tsx         # Dashboard layout with sidebar
│   │   ├── page.tsx           # Dashboard home
│   │   └── settings/page.tsx
│   ├── api/                   # API Routes (Route Handlers)
│   │   └── webhooks/route.ts
│   ├── layout.tsx             # Root layout
│   ├── page.tsx               # Home page
│   ├── loading.tsx            # Root loading UI
│   ├── error.tsx              # Root error UI
│   └── not-found.tsx          # 404 page
├── components/                # Shared components
│   ├── ui/                    # Generic UI (Button, Input, Card)
│   └── features/             # Feature-specific components
├── lib/                       # Utilities, helpers
│   ├── auth.ts               # Auth configuration
│   ├── prisma.ts             # Prisma client singleton
│   └── utils.ts
├── actions/                   # Server Actions
│   ├── auth-actions.ts
│   └── order-actions.ts
└── types/                     # TypeScript types
```

## Performance Tips
- Use `next/dynamic` for heavy client components (code splitting)
- Use `<Image>` with `priority` for above-the-fold images
- Use `generateStaticParams` for static generation of dynamic routes
- Monitor Core Web Vitals with `useReportWebVitals`
- Use `Suspense` boundaries to stream content progressively

## Security Checklist
- [ ] Server Actions validate all inputs with Zod
- [ ] API Routes check authentication
- [ ] Environment variables for secrets (not in client bundle)
- [ ] CSRF protection via Server Actions (built-in)
- [ ] Rate limiting on API routes
- [ ] CSP headers in `next.config.js`

## Common Integrations
| Integration | Package | Notes |
|---|---|---|
| Auth | `next-auth` (v5) / `clerk` / `lucia` | NextAuth v5 for App Router |
| Database | `prisma` / `drizzle` | Prisma most popular, Drizzle lighter |
| UI Kit | `shadcn/ui` | Copy-paste components (not a dependency) |
| Forms | `react-hook-form` + `zod` | Best combo for validated forms |
| State | `zustand` / `jotai` | Lightweight, React 19 compatible |
| Email | `resend` / `react-email` | JSX email templates |
| Payments | `stripe` | Official SDK |
| File Upload | `uploadthing` / `vercel-blob` | Managed file uploads |
