# Ready-to-Use Prompts — Copy and Paste

> **Purpose:** Ready-made templates for immediate use. Copy, fill in the [fields], and go.

---

## SETUP (First time / New chat)

### Full setup:
```
You are the HEPHAESTUS v8.0.0 framework.
Read the following files:
1. .agents/AGENTS.md
2. .agents/config/framework.yaml
3. .agents/protocols/smart-loading-protocol.md
4. .agents/protocols/adaptive-complexity-protocol.md
5. .agents/docs/en/22-OPERATOR-EXPERIENCE-MAP.md
Confirm: number of agents, active profile, loading level, and the best guide for my intent.
```

### Quick resumption:
```
HEPHAESTUS v8.0.0 — load [LITE/STANDARD] level.
Read .agents/config/framework.yaml and .agents/memory/context-db/session-brief.md.
Task: [describe the task].
```

### Install or update:
```
HEPHAESTUS v8.0.0 — guide me through install/update.
Read .agents/docs/en/20-INSTALL-UPDATE-WIZARD.md.
Start with dry-run. Do not apply changes until I approve.
```

### Operator map:
```
HEPHAESTUS v8.0.0 — read .agents/docs/en/22-OPERATOR-EXPERIENCE-MAP.md.
My intent is: [install/update/start project/real project/release/resume].
Tell me the smallest guide set to load.
```

---

## 🟢 LITE — Simple Tasks

### Bug fix:
```
LITE: Fix [bug description] in [path/file.ext].
Currently: [current behavior]
Expected: [expected behavior]
```

### Typo:
```
LITE: Fix text "[wrong text]" to "[correct text]" in [file].
```

### Config:
```
LITE: Change [setting] from [current value] to [new value] in [file].
```

### Rename:
```
LITE: Rename [old name] to [new name] across the entire project.
```

---

## 🟡 STANDARD — Features

### New screen:
```
STANDARD: Create the [name] screen with:
- [element 1]
- [element 2]
- [element N]
Stack: [your stack].
Follow design tokens from profile.
States: loading, error, empty, data.
Responsive: mobile + tablet + desktop.
```

### Full CRUD:
```
STANDARD: Implement CRUD for [entity]:
- Model: [field1, field2, field3...]
- API: [endpoints]
- Screens: List + Detail + Form (create/edit) + Delete confirm
- Full form validation
- States: loading, error, empty on all screens
```

### API Integration:
```
STANDARD: Integrate [API name]:
- Endpoint: [URL]
- Method: [GET/POST/PUT/DELETE]
- Request: [body/params]
- Response: [expected format]
- Error handling: [error types]
- I need: Model, Repository, UseCase, and update screen [X]
```

### Refactor:
```
STANDARD: Refactor [module/component]:
Current state: [description]
Desired state: [description]
Rules: don't break functionality, keep tests passing.
```

---

## 🟠 DEEP — Architecture

### Migration:
```
DEEP: Migrate [component/pattern/technology]:
From: [current state]
To: [desired state]
Rules:
- Phased approach (not all at once)
- Rollback strategy defined
- Tests at each phase
- Zero downtime if production
```

### Complex system:
```
DEEP: Implement [complex system]:
Functional requirements:
1. [req 1]
2. [req 2]

Non-functional requirements:
- Performance: [target]
- Security: [level]
- Platforms: [list]

I need:
- Research of options
- Phased plan with rollback
- Security audit
- Test coverage > [X]%
```

### Offline-first:
```
DEEP: Implement offline-first for [feature]:
- Local cache: [technology]
- Sync strategy: [when/how]
- Conflict resolution: [server wins / client wins / merge]
- Queue for offline operations
- Visual online/offline indicator
```

---

## 🔴 CRITICAL — Production

### Payment:
```
CRITICAL: Implement [payment gateway]:
- Plans: [list]
- Trial: [yes/no, duration]
- Webhook events: [list]
- PCI-DSS: tokens via SDK, never store card data
- GDPR/LGPD: [requirements]
- Test coverage > 90%
- OWASP security audit
- Rollback strategy
```

---

## 🎨 UI — Visual

### New screen:
```
UI WORKFLOW: Create the [name] screen with:
- [visual elements]
Follow design tokens. Responsive. Accessible.
States: loading, error, empty.
```

### Design review:
```
Run full design review on [file]:
□ Design tokens
□ Responsive behavior
□ Accessibility
□ States coverage
□ Dark mode parity
□ Visual performance
```

### Design system:
```
UI WORKFLOW (DEEP): Create the design system:
- Color palette (light + dark)
- Typography scale
- Spacing system (8px grid)
- Border radius
- Elevation/shadow
- Components: Button, Card, TextField, Avatar, Badge
```

---

## 🔧 DEBUG

### Simple bug:
```
LITE: Bug — [description]. File: [file]. Error: [error message].
```

### Complex bug:
```
STANDARD: Bug — [description]
Symptoms: [what happens]
When: [trigger condition]
Error: [stack trace]
Already tried: [attempts]
I need root cause and fix.
```

### Performance:
```
DEEP: Performance degradation in [component]:
- Symptom: [lag, slowness, low FPS]
- Condition: [when it happens]
- Metric: [FPS, load time]
I need: profiling, root cause, and optimization.
```

---

## 💾 SAVING

### Save state:
```
Save session state:
1. Update session checkpoint with: what was done, where we stopped, next steps
2. Update learning-store with learnings from this session
3. Generate session brief for next chat
4. Confirm everything was saved
```

### Full backup:
```
Full backup:
1. Commit everything pending
2. Push to remote
3. Confirm all is safe
```

---

## 📊 EVOLUTION

### Retrospective:
```
Run retrospective for this session:
- What went well?
- What could improve?
- New patterns to record?
- Decisions that proved right/wrong?
Record everything in memory.
```

### Feedback:
```
Feedback: [the decision about X was good/bad because Y].
Record in learning-store.
```

