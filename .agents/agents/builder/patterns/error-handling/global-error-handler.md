# Global Error Handler — Pattern by Framework

> **Category:** Builder / Error Handling
> **Usage:** Reference for implementing centralized error handling

---

## Principle: Fail Gracefully, Log Thoroughly, Never Leak Details

```
ERROR HANDLING LAYERS:
1. Domain errors (business rule violations) → 400/422
2. Infrastructure errors (DB, external APIs) → 500 (generic to user, detailed in logs)
3. Validation errors (bad input) → 400 with details
4. Authentication errors → 401
5. Authorization errors → 403
6. Not found errors → 404
7. Unexpected errors → 500 (catch-all)
```

## Custom Error Classes (TypeScript)

```typescript
// Base application error
export abstract class AppError extends Error {
  abstract readonly statusCode: number;
  abstract readonly isOperational: boolean; // true = expected, false = programmer bug

  constructor(message: string, public readonly context?: Record<string, unknown>) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }

  toJSON() {
    return {
      error: this.name,
      message: this.message,
      ...(process.env.NODE_ENV === 'development' && { context: this.context }),
    };
  }
}

// Specific errors
export class NotFoundError extends AppError {
  readonly statusCode = 404;
  readonly isOperational = true;
  constructor(resource: string, id: string) {
    super(`${resource} with id '${id}' not found`, { resource, id });
  }
}

export class ValidationError extends AppError {
  readonly statusCode = 400;
  readonly isOperational = true;
  constructor(public readonly errors: Array<{ field: string; message: string }>) {
    super('Validation failed');
  }
  toJSON() {
    return { ...super.toJSON(), details: this.errors };
  }
}

export class UnauthorizedError extends AppError {
  readonly statusCode = 401;
  readonly isOperational = true;
  constructor(message = 'Authentication required') { super(message); }
}

export class ForbiddenError extends AppError {
  readonly statusCode = 403;
  readonly isOperational = true;
  constructor(message = 'Insufficient permissions') { super(message); }
}

export class ConflictError extends AppError {
  readonly statusCode = 409;
  readonly isOperational = true;
  constructor(message: string) { super(message); }
}

export class InternalError extends AppError {
  readonly statusCode = 500;
  readonly isOperational = false; // Programmer bug — needs investigation
  constructor(message: string, context?: Record<string, unknown>) {
    super(message, context);
  }
}
```

## Express.js Global Handler

```typescript
import { Request, Response, NextFunction } from 'express';
import { AppError } from './errors';
import { logger } from './logger';

export function globalErrorHandler(err: Error, req: Request, res: Response, _next: NextFunction) {
  const requestId = req.headers['x-request-id'] || crypto.randomUUID();

  if (err instanceof AppError) {
    // Operational error — expected, log as warning
    logger.warn('Operational error', {
      requestId,
      error: err.name,
      message: err.message,
      statusCode: err.statusCode,
      path: req.path,
      method: req.method,
      ip: req.ip,
    });
    return res.status(err.statusCode).json({ ...err.toJSON(), requestId });
  }

  // Unexpected error — programmer bug, log as error with stack
  logger.error('Unexpected error', {
    requestId,
    error: err.name,
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    body: req.body,
    ip: req.ip,
  });

  return res.status(500).json({
    error: 'InternalServerError',
    message: 'An unexpected error occurred',
    requestId, // User can share this for support
  });
}

// Register: app.use(globalErrorHandler) — AFTER all routes
```

## Next.js App Router (error.tsx)

```tsx
'use client';

export default function Error({ error, reset }: { error: Error; reset: () => void }) {
  useEffect(() => {
    // Log to error reporting service
    reportError(error);
  }, [error]);

  return (
    <div className="error-container">
      <h2>Something went wrong</h2>
      <p>{error.message}</p>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

## FastAPI (Python)

```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

app = FastAPI()

class AppError(Exception):
    def __init__(self, status_code: int, message: str, details: dict = None):
        self.status_code = status_code
        self.message = message
        self.details = details

@app.exception_handler(AppError)
async def app_error_handler(request: Request, exc: AppError):
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": exc.message, "details": exc.details},
    )

@app.exception_handler(Exception)
async def global_error_handler(request: Request, exc: Exception):
    logger.error(f"Unexpected error: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error"},
    )
```
