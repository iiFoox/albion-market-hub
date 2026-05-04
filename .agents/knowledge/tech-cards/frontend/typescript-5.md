# TypeScript 5.x — Tech Card

> **Category:** Language / Type System
> **Current Version:** 5.x
> **Runtime:** Transpiles to JavaScript (Node.js, Browser)

---

## Quick Setup
```bash
npm install -D typescript @types/node
npx tsc --init
```

## tsconfig.json (Strict Modern)
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "paths": { "@/*": ["./src/*"] }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## Top 10 Best Practices

1. **Enable `strict: true`** — non-negotiable for production code
2. **Avoid `any`** — use `unknown` when type is uncertain, then narrow
3. **Use `as const`** — for literal types: `const STATUS = ['active', 'inactive'] as const`
4. **Use discriminated unions** — `type Result = { ok: true; data: T } | { ok: false; error: Error }`
5. **Use `satisfies`** — type-check without widening: `const config = {...} satisfies Config`
6. **Use template literal types** — `type Route = \`/api/\${string}\``
7. **Use `Record<K, V>`** — not `{ [key: string]: V }` for object maps
8. **Use `Readonly<T>`** — for immutable data structures
9. **Export types separately** — `export type { Config }` for type-only exports
10. **Use branded types** — `type UserId = string & { __brand: 'UserId' }` for ID safety

## Top 10 Gotchas

1. ❌ **`any` infects** — one `any` makes connected code untyped
2. ❌ **Type assertions lie** — `value as User` doesn't validate; use Zod/type guards
3. ❌ **`object` type** — means "not primitive", not "any object"; use `Record` or interface
4. ❌ **`{}` type** — means "anything except null/undefined", not "empty object"
5. ❌ **Enums at runtime** — use `as const` objects instead for smaller bundles
6. ❌ **No runtime types** — TypeScript types don't exist at runtime; use Zod for validation
7. ❌ **Missing null checks** — enable `strictNullChecks` (included in `strict`)
8. ❌ **`instanceof` doesn't work across modules** — use discriminated unions
9. ❌ **Optional chaining returns `undefined`** — not `null`; be careful with DB results
10. ❌ **Class-based overuse** — prefer interfaces + functions; classes add runtime weight

## Essential Patterns

### Type Guard (Runtime Validation)
```typescript
function isUser(value: unknown): value is User {
  return typeof value === 'object' && value !== null && 'id' in value && 'email' in value;
}
```

### Discriminated Union
```typescript
type ApiResult<T> =
  | { status: 'success'; data: T }
  | { status: 'error'; error: string }
  | { status: 'loading' };

function handle(result: ApiResult<User>) {
  switch (result.status) {
    case 'success': console.log(result.data); break;  // TypeScript knows data exists
    case 'error': console.log(result.error); break;    // TypeScript knows error exists
    case 'loading': console.log('Loading...'); break;
  }
}
```

### Utility Types Quick Reference
| Type | Effect | Example |
|---|---|---|
| `Partial<T>` | All props optional | `Partial<User>` for updates |
| `Required<T>` | All props required | `Required<Config>` |
| `Pick<T, K>` | Select specific props | `Pick<User, 'id' \| 'name'>` |
| `Omit<T, K>` | Remove specific props | `Omit<User, 'password'>` |
| `Record<K, V>` | Object type | `Record<string, number>` |
| `Readonly<T>` | Immutable | `Readonly<Config>` |
| `ReturnType<F>` | Function return type | `ReturnType<typeof fn>` |
| `Parameters<F>` | Function params tuple | `Parameters<typeof fn>` |
| `Awaited<T>` | Unwrap Promise | `Awaited<Promise<User>>` = `User` |
| `NonNullable<T>` | Remove null/undefined | `NonNullable<string \| null>` = `string` |
