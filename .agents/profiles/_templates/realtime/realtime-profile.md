# Real-Time Application Profile

> **Category:** Profile / Architecture-Specific
> **Usage:** Applied for WebSocket, live data, collaborative apps

---

## Activation Trigger
```
ACTIVATE WHEN:
→ Project needs real-time data updates (live feeds, dashboards)
→ Project has collaborative editing (multiple users editing same data)
→ Project uses WebSockets, SSE, or long-polling
→ User mentions: real-time, chat, live, collaborative, websocket, streaming
```

## WebSocket Architecture

```
                    ┌──────────────────┐
     Clients ──────►│   Load Balancer  │ (sticky sessions or Redis pub/sub)
                    └────────┬─────────┘
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
       ┌──────────┐  ┌──────────┐  ┌──────────┐
       │ Server 1 │  │ Server 2 │  │ Server 3 │
       │ (Socket) │  │ (Socket) │  │ (Socket) │
       └────┬─────┘  └────┬─────┘  └────┬─────┘
            └──────────────┼──────────────┘
                    ┌──────┴──────┐
                    │ Redis PubSub│  (cross-server messaging)
                    └─────────────┘
```

### Socket.IO Implementation
```typescript
import { Server } from 'socket.io';
import { createAdapter } from '@socket.io/redis-adapter';

const io = new Server(httpServer, {
  cors: { origin: ALLOWED_ORIGINS },
  transports: ['websocket', 'polling'],
  pingInterval: 25000,
  pingTimeout: 20000,
});

// Redis adapter for multi-server scaling
io.adapter(createAdapter(pubClient, subClient));

// Authentication middleware
io.use(async (socket, next) => {
  const token = socket.handshake.auth.token;
  try {
    const user = await verifyToken(token);
    socket.data.user = user;
    next();
  } catch (err) {
    next(new Error('Authentication failed'));
  }
});

// Room-based messaging
io.on('connection', (socket) => {
  const userId = socket.data.user.id;
  
  // Join user's personal room
  socket.join(`user:${userId}`);
  
  // Join project rooms
  socket.on('join:project', async (projectId) => {
    const hasAccess = await checkAccess(userId, projectId);
    if (hasAccess) socket.join(`project:${projectId}`);
  });
  
  // Broadcast to room
  socket.on('message', (data) => {
    io.to(`project:${data.projectId}`).emit('message', {
      ...data,
      from: userId,
      timestamp: Date.now(),
    });
  });
});
```

## Conflict Resolution (Collaborative Editing)

### Strategies
| Strategy | Complexity | Use When |
|---|---|---|
| **Last Write Wins** | Low | Simple fields, comments |
| **Operational Transform (OT)** | High | Text editing (Google Docs style) |
| **CRDT** | Medium-High | Distributed, offline-first |
| **Locking** | Low | Single-user edit at a time |

### Optimistic Locking Pattern
```typescript
// Version-based conflict detection
async function updateDocument(id: string, data: Partial<Doc>, expectedVersion: number) {
  const result = await db.document.updateMany({
    where: { id, version: expectedVersion },  // Only update if version matches
    data: { ...data, version: { increment: 1 } },
  });

  if (result.count === 0) {
    throw new ConflictError('Document was modified by another user. Please refresh.');
  }
}
```

## Offline-First Pattern
```
SYNC STRATEGY:
1. Local changes saved to IndexedDB/SQLite immediately
2. Changes queued for sync when connection returns
3. On reconnect: push local changes → pull remote changes → resolve conflicts
4. Conflict resolution: timestamp-based LWW or user-prompted merge

IMPORTANT:
→ Every entity needs a `lastModifiedAt` timestamp (client-generated)
→ Every entity needs a `syncStatus`: 'synced' | 'pending' | 'conflict'
→ Queue operations must be idempotent (safe to replay)
```
