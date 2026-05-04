# Python 3.13 — Tech Card

> **Category:** Backend Language
> **Current Version:** 3.13.x
> **Type:** General-purpose programming language

---

## Quick Setup
```bash
python -m venv .venv && .venv/bin/activate
pip install fastapi uvicorn pydantic sqlalchemy
```

## Key Features (3.13)
- **Free-threaded mode** — no GIL experimental build (`--disable-gil`)
- **Improved error messages** — better tracebacks and suggestions
- **Type parameter syntax** — `def func[T](x: T) -> T:` (PEP 695)
- **`typing.override`** — explicit override decorator
- **Performance improvements** — faster startup, optimized specialization

## Top 10 Best Practices

1. **Use type hints everywhere** — `def process(data: dict[str, Any]) -> Result:`
2. **Use `pyproject.toml`** — modern project configuration (not setup.py)
3. **Use Pydantic for validation** — data classes with validation built-in
4. **Use virtual environments** — always `.venv` per project
5. **Use f-strings** — `f"Hello {name}"` not `"Hello {}".format(name)`
6. **Use pathlib** — `Path("dir") / "file.txt"` not `os.path.join()`
7. **Use dataclasses or Pydantic models** — not raw dicts for structured data
8. **Use logging module** — not `print()` for application logging
9. **Use `asyncio`** for I/O-bound tasks — `async def` + `await`
10. **Use `ruff`** — fastest linter + formatter (replaces flake8/black/isort)

## Top 10 Gotchas

1. ❌ **Mutable default arguments** — `def f(items=[])` shares list across calls; use `None`
2. ❌ **GIL limitations** — threads don't parallelize CPU-bound work; use `multiprocessing`
3. ❌ **Late binding closures** — `[lambda: i for i in range(5)]` all return 4; use default arg
4. ❌ **Circular imports** — restructure modules or use `TYPE_CHECKING` guard
5. ❌ **`.append()` vs `+`** — `list.append()` is in-place; `+` creates new list
6. ❌ **`is` vs `==`** — `is` checks identity, `==` checks equality; use `==` for values
7. ❌ **Not closing files** — always use `with open()` context manager
8. ❌ **Catching bare `Exception`** — catch specific exceptions; bare catch hides bugs
9. ❌ **Relative imports confusion** — use absolute imports; relative only in packages
10. ❌ **`datetime.now()`** — returns local time; use `datetime.now(UTC)` always

## FastAPI Project Structure
```
src/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI app creation
│   ├── config.py            # Pydantic Settings
│   ├── dependencies.py      # Shared dependencies (DB session, auth)
│   ├── routers/
│   │   ├── users.py
│   │   └── orders.py
│   ├── models/              # SQLAlchemy models
│   │   ├── user.py
│   │   └── order.py
│   ├── schemas/             # Pydantic request/response schemas
│   │   ├── user.py
│   │   └── order.py
│   └── services/            # Business logic
│       ├── user_service.py
│       └── order_service.py
├── tests/
│   ├── conftest.py
│   ├── test_users.py
│   └── test_orders.py
├── pyproject.toml
└── requirements.txt
```

## Security Checklist
- [ ] Use Pydantic for ALL input validation
- [ ] Parameterized queries (SQLAlchemy does this by default)
- [ ] Hash passwords with `bcrypt` or `argon2`
- [ ] Use `python-jose` for JWT token handling
- [ ] Keep dependencies updated (`pip-audit`)
- [ ] Use `secrets.token_urlsafe()` for random tokens (not `random`)
- [ ] Set CORS properly in FastAPI (`CORSMiddleware`)
