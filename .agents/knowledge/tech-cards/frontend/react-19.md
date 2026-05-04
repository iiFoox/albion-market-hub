# React 19 — Tech Card

> **Category:** Frontend UI Library
> **Current Version:** 19.x
> **Runtime:** Browser + Node.js (Server Components)

---

## Quick Setup
```bash
npx -y create-vite@latest ./ --template react-ts
```

## Key Features (v19)
- **Server Components** — render on server, zero JS to client
- **Actions** — async functions for form handling (`useActionState`)
- **`use()` hook** — read promises and context in render
- **`useOptimistic`** — optimistic UI updates while async operations run
- **`useFormStatus`** — track form submission state
- **`ref` as prop** — no more `forwardRef` wrapper
- **Document Metadata** — `<title>`, `<meta>` in component JSX
- **Stylesheet support** — `<link>` precedence management
- **Improved error reporting** — better hydration error messages

## Top 10 Best Practices

1. **Use Server Components by default** — only `"use client"` for interactivity
2. **Composition over inheritance** — pass components as children/props
3. **Keep state close to where it's used** — don't lift state unnecessarily
4. **Use `key` to reset component state** — change key = fresh mount
5. **Memoize expensive computations** — `useMemo` for expensive derived state
6. **Use `useCallback` for functions passed to memoized children** — prevent re-renders
7. **Use custom hooks for reusable logic** — `useDebounce`, `useLocalStorage`, etc.
8. **Error boundaries for resilience** — catch render errors gracefully
9. **Use Suspense for loading states** — declarative loading UX
10. **Separate data fetching from UI** — container/presentation pattern

## Top 10 Gotchas

1. ❌ **State updates are batched** — `setState(x); console.log(x)` logs OLD value
2. ❌ **React.memo doesn't deep compare** — use `useMemo` for computed props
3. ❌ **useEffect runs after paint** — not equivalent to componentDidMount timing
4. ❌ **Missing dependency in useEffect** — stale closures cause bugs
5. ❌ **Inline object/array in props** — creates new reference every render → re-renders children
6. ❌ **`useState` initializer function** — `useState(expensiveFn())` runs every render; use `useState(expensiveFn)` instead
7. ❌ **Deriving state from props** — don't `useEffect` to sync state with props; compute during render
8. ❌ **Missing key on lists** — don't use array index as key if list can reorder
9. ❌ **Event handler in JSX creates function** — `onClick={() => fn(id)}` is fine for most cases; only optimize if measurable perf issue
10. ❌ **Not cleaning up effects** — subscriptions, intervals, abort controllers must be cleaned up

## Component Pattern
```tsx
// Modern React 19 component
interface UserCardProps {
  userId: string;
  onFollow?: (userId: string) => void;
}

export function UserCard({ userId, onFollow }: UserCardProps) {
  // use() hook for data fetching (v19)
  const user = use(fetchUser(userId));

  return (
    <article className="user-card">
      <title>{user.name}'s Profile</title>  {/* Document metadata in component! */}
      <img src={user.avatar} alt={user.name} />
      <h2>{user.name}</h2>
      {onFollow && (
        <button onClick={() => onFollow(userId)}>Follow</button>
      )}
    </article>
  );
}
```

## State Management Decision
| Complexity | Solution |
|---|---|
| Local component state | `useState` / `useReducer` |
| Shared between few siblings | Lift state up to parent |
| Global UI state (theme, sidebar) | `zustand` or `jotai` |
| Server state (API data) | `@tanstack/react-query` or `swr` |
| Complex form state | `react-hook-form` |
| URL state | `useSearchParams` / `nuqs` |

## Performance Checklist
- [ ] Use React DevTools Profiler to find unnecessary re-renders
- [ ] Wrap expensive components in `React.memo` if props actually change
- [ ] Use `useMemo` for expensive computations, not for everything
- [ ] Use `useCallback` for callbacks passed to memoized children
- [ ] Virtual lists for 100+ items (`@tanstack/virtual`)
- [ ] Code-split routes with `React.lazy` + `Suspense`
- [ ] Avoid context for frequently changing values (causes full tree re-render)
