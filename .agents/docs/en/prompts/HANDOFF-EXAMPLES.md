# Handoff Examples — Agent-to-Agent Task Transfer

> **Purpose:** Shows how agents transfer work to each other with full context  
> **Protocol:** See `protocols/collaboration-protocol.md` for full specification

---

## How Handoffs Work

```
Agent A completes their phase
→ Creates a Handoff Artifact with full context
→ Orchestrator routes to Agent B
→ Agent B reads the artifact and continues
→ No implicit knowledge — everything is explicit
```

---

## Example 1: Researcher → Planner

### Context: "Add offline support for the notes feature"

```
## Handoff: Researcher → Planner

### Task
Design the implementation plan for offline-first notes

### Objective
Create a phased plan with rollback strategy for offline notes

### Context
- Notes feature exists: lib/features/notes/ (CRUD complete, online-only)
- Database: Supabase (PostgreSQL)
- Current architecture: Repository pattern with direct API calls
- No local database exists yet

### Research Findings
- Recommended local DB: Isar (fast, cross-platform, reactive)
- Sync strategy: Optimistic local-first, periodic background sync
- Conflict resolution: Last-write-wins (simplest for notes)
- Estimated complexity: DEEP (touches data layer, sync logic, UI states)

### Risks
1. Sync conflicts with concurrent edits (MEDIUM)
2. Local storage size on web platform (LOW — notes are text)
3. Background sync on iOS is restricted (MEDIUM)

### Constraints
- Must work on: Android, Windows, Web
- Must not break existing online functionality
- Sync should be invisible to user (no manual sync button)

### Expected Output
Phased implementation plan with:
- Phase 1: Local database setup
- Phase 2: Offline read support
- Phase 3: Offline write + queue
- Phase 4: Background sync
- Rollback strategy per phase

### Memory References
- seed-flutter-platform.md: "Web has limited local storage"
- knowledge-graph/bootstrap-architecture.md: "Repository pattern in use"
```

---

## Example 2: Planner → Builder

### Context: After planning the offline notes feature

```
## Handoff: Planner → Builder

### Task
Implement Phase 1: Local database setup with Isar

### Objective
Set up Isar as the local database, create note schema, and wire repository

### Plan (Phase 1 only)
1. Add isar, isar_flutter_libs, and build_runner to pubspec.yaml
2. Create NoteSchema (mirrors existing Note model)
3. Create IsarNoteRepository implementing NoteRepository interface
4. Create SyncService skeleton (to be filled in Phase 3)
5. Wire Isar initialization in main.dart
6. Update NoteRepository to use local-first reads

### Acceptance Criteria
- [ ] Isar initializes without errors on Android, Windows, Web
- [ ] NoteSchema has: id, title, content, createdAt, updatedAt, syncStatus
- [ ] IsarNoteRepository passes existing unit tests
- [ ] App still works fully online (no regression)

### Constraints
- Do NOT implement sync yet (Phase 3)
- Do NOT change UI (Phase 2)
- Keep online API calls working as fallback
- Use dependency injection for repository swap

### Affected Areas
- pubspec.yaml (new deps)
- lib/features/notes/data/models/note_schema.dart [NEW]
- lib/features/notes/data/repositories/isar_note_repository.dart [NEW]
- lib/core/services/database_service.dart [NEW]
- lib/main.dart (Isar init)

### Done When
All acceptance criteria checked. Online functionality unaffected.
```

---

## Example 3: Builder → UI/UX Specialist

### Context: After implementing a new settings screen

```
## Handoff: Builder → UI/UX Specialist

### Task
Design review of the new SettingsScreen implementation

### What Was Built
- lib/features/settings/presentation/screens/settings_screen.dart
- lib/features/settings/presentation/widgets/settings_tile.dart
- lib/features/settings/presentation/widgets/theme_toggle.dart

### Self-Assessment
- Design tokens: ✅ Used ColorScheme and TextTheme throughout
- Responsive: ⚠️ Not tested on tablet breakpoint
- Accessibility: ✅ All toggles have Semantics labels
- States: ✅ Loading skeleton while preferences load
- Dark mode: ✅ Tested with both themes
- Platform: ⚠️ Toggle style might differ on iOS (Cupertino)

### Known Issues
- Line 45: Not sure if 16px padding is correct for section headers
- Line 78: Used Divider() — should this use a design token?

### Expected Output
Design review verdict: APPROVED / NEEDS_CHANGES with specific fixes
```

---

## Example 4: Validator → Builder (Rejection)

### Context: Validator found issues in Builder's implementation

```
## Handoff: Validator → Builder (CORRECTION NEEDED)

### Task
Fix 2 issues found during validation of the auth module

### Issue 1: Security — JWT stored in SharedPreferences (CRITICAL)
- File: lib/core/services/token_service.dart:23
- Problem: JWT stored in SharedPreferences (plain text, accessible)
- Fix: Use flutter_secure_storage for token persistence
- Reference: OWASP Mobile Top 10 — M9: Insecure Data Storage

### Issue 2: Test — Missing edge case (MAJOR)
- File: test/features/auth/auth_repository_test.dart
- Problem: No test for expired refresh token scenario
- Fix: Add test case where refresh token returns 401
- Expected behavior: Clear tokens, redirect to login

### Tests Run
- 24/26 passing
- 2 new tests added (1 failing = the missing edge case)

### Done When
- Token storage uses flutter_secure_storage
- Expired refresh token test passes
- All 26 tests green
```

---

## Example 5: Builder → Delivery (Session End)

```
## Handoff: Builder → Delivery

### Task
Commit and close session

### Changes Made
- feat(settings): add theme toggle with persistence
- 3 files modified, 1 created
- All tests passing (12/12)

### Commit Assessment
- Committable: YES
- Type: feat (new feature)
- Scope: settings
- Version bump: minor (1.2.0 → 1.3.0)

### Session Closing
- Checkpoint needs update: YES
- Learnings to save: 1 (SharedPreferences pattern for simple prefs)
- Session brief needed: YES (work continues tomorrow)
```

---

## Anti-Patterns in Handoffs

| ❌ Bad | ✅ Good |
|--------|---------|
| "Fix the thing" | "Fix JWT storage in token_service.dart:23 — use flutter_secure_storage" |
| "It should work on all platforms" | "Verified on Android ✅, Windows ⚠️ needs Isar init, Web ❌ not tested" |
| "Follow best practices" | "Use Repository pattern, inject via Riverpod, test with mock" |
| No acceptance criteria | "Done when: 12/12 tests pass, no hard-coded colors, responsive verified" |
