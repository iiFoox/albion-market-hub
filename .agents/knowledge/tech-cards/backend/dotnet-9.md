# .NET 9 / C# 13 — Tech Card

> **Category:** Backend Framework + Language
> **Current Version:** .NET 9 / C# 13
> **Type:** Cross-platform application platform

---

## Quick Setup
```bash
dotnet new webapi -n MyApi --use-controllers
dotnet new webapi -n MyApi  # Minimal API (default in .NET 9)
```

## Key Features (.NET 9)
- **Minimal APIs** — lightweight endpoint definitions without controllers
- **Native AOT** — compile to native code (fast startup, small binary)
- **System.Text.Json** — source generation for fast serialization
- **Built-in OpenAPI** — Swagger/OpenAPI generation without Swashbuckle
- **Hybrid Cache** — L1 (memory) + L2 (Redis) caching built-in
- **YARP** — built-in reverse proxy

## Top 10 Best Practices

1. **Use Minimal APIs** for small services, Controllers for complex APIs
2. **Use dependency injection** — built-in DI container is excellent
3. **Use `IOptions<T>`** — typed configuration binding
4. **Use `ILogger<T>`** — structured logging with scopes
5. **Use `CancellationToken`** — pass to all async methods for proper cancellation
6. **Use `FluentValidation`** — for complex validation rules
7. **Use `MediatR`** — CQRS/Mediator pattern for clean architecture
8. **Use `Entity Framework Core`** — with migrations and query optimization
9. **Use `Polly`** — resilience patterns (retry, circuit breaker, timeout)
10. **Use `HealthChecks`** — built-in health check endpoints for monitoring

## Top 10 Gotchas

1. ❌ **Blocking async code** — never `.Result` or `.Wait()` on async; use `await`
2. ❌ **Not disposing resources** — use `using` or `IAsyncDisposable`
3. ❌ **Captive dependencies** — Scoped service injected into Singleton leaks
4. ❌ **N+1 queries in EF Core** — use `.Include()` for eager loading
5. ❌ **Missing `ConfigureAwait(false)`** in libraries — prevents deadlocks
6. ❌ **String concatenation in loops** — use `StringBuilder` for performance
7. ❌ **Not using `AsNoTracking()`** — for read-only queries, skip change tracking
8. ❌ **Exception-driven control flow** — exceptions are expensive; use Result pattern
9. ❌ **Global error handler only** — handle specific exceptions where they occur
10. ❌ **Missing cancellation token** — long requests can't be cancelled without it

## Project Structure
```
src/
├── MyApi/
│   ├── Program.cs              # App configuration + middleware
│   ├── appsettings.json
│   ├── Endpoints/              # Minimal API endpoint definitions
│   │   ├── UserEndpoints.cs
│   │   └── OrderEndpoints.cs
│   ├── Services/               # Business logic
│   │   ├── IUserService.cs
│   │   └── UserService.cs
│   ├── Models/                 # Domain models
│   │   ├── User.cs
│   │   └── Order.cs
│   ├── Data/                   # EF Core
│   │   ├── AppDbContext.cs
│   │   └── Migrations/
│   ├── DTOs/                   # Request/Response objects
│   └── Middleware/             # Custom middleware
├── MyApi.Tests/
│   ├── UnitTests/
│   └── IntegrationTests/
└── MyApi.sln
```

## Security Checklist
- [ ] Use `[Authorize]` attribute on protected endpoints
- [ ] Use `AddAuthentication().AddJwtBearer()` for JWT validation
- [ ] Use parameterized queries (EF Core does this by default)
- [ ] Enable HTTPS redirection (`UseHttpsRedirection()`)
- [ ] Use `AddCors()` with explicit origins
- [ ] Use `AddRateLimiter()` (built-in in .NET 9)
- [ ] Store secrets in User Secrets / Azure Key Vault
- [ ] Use `Data Protection API` for encryption
