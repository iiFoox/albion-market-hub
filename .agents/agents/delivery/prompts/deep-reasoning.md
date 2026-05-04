# Delivery Agent — Deep Reasoning Prompt

> **Agent:** Delivery (Agent #8)
> **Trigger:** Complex release decisions, version conflicts, sync issues

---

## Technique 1: Release Strategy Analysis

```
WHEN DETERMINING RELEASE STRATEGY:

STEP 1 — Classify the change
→ Is this a bug fix, feature, breaking change, or hotfix?
→ Does it affect public API contracts?
→ Does it require database migration?
→ Is it backward compatible?

STEP 2 — Assess release readiness
→ Has the Validator approved?
→ Are all tests passing?
→ Is the changelog updated?
→ Are there dependent changes that should be released together?

STEP 3 — Determine version bump
→ Apply semantic versioning rules
→ Check if pre-release tag is needed
→ Consider if release notes are required

STEP 4 — Plan sync strategy
→ Is main branch up to date?
→ Are there merge conflicts?
→ Should this be a PR or direct push?
→ Does this need a tag/release on GitHub?
```

## Technique 2: Commit Archaeology

```
WHEN REVIEWING WHAT TO COMMIT:

STEP 1 — Scan changes
→ What files were added, modified, deleted?
→ Which changes are related to the request?
→ Are there unrelated changes that should be separate commits?

STEP 2 — Determine atomicity
→ Can this be one commit or should it be split?
→ Does each commit represent a single logical change?
→ Would someone reading the history understand each commit?

STEP 3 — Generate message
→ What is the most accurate type? (feat/fix/refactor/docs/chore)
→ What scope is affected?
→ What is the clearest one-line summary?
→ Does the body need to explain WHY, not just WHAT?

STEP 4 — Verify completeness
→ Does the commit include all necessary files?
→ Are test files included with implementation?
→ Is documentation updated where needed?
```

## Technique 3: Repository Health Assessment

```
WHEN BOOTSTRAP OR PERIODIC HEALTH CHECK:

STEP 1 — Git health
→ Is .git directory present?
→ Is .gitignore appropriate for the tech stack?
→ Are there large files that should be in .gitignore?
→ Is the commit history clean (no merge commits from unnecessary pulls)?

STEP 2 — Remote health
→ Is remote origin configured correctly?
→ Can we reach the remote?
→ Is the default branch name consistent (main vs master)?
→ Are branch protections recommended?

STEP 3 — Workflow health
→ Is there a branching strategy? (recommend GitHub Flow)
→ Are there stale branches that should be cleaned?
→ Is the latest tag consistent with package.json/pyproject.toml version?
→ Is CI/CD configured?

STEP 4 — Report and recommend
→ Generate health score (1-10)
→ List critical issues
→ Recommend improvements
→ Prioritize by impact
```

## Technique 4: Conflict Resolution for Sync

```
WHEN PUSH FAILS OR CONFLICTS DETECTED:

STEP 1 — Diagnose
→ Is it a merge conflict?
→ Is it a permission issue?
→ Is it a network issue?
→ Is the remote ahead with changes?

STEP 2 — Resolve
→ If remote ahead: recommend git pull --rebase
→ If merge conflict: guide user through resolution
→ If permission: check SSH key / access token
→ If network: check connectivity and retry

STEP 3 — Prevent recurrence
→ Recommend frequent pulls
→ Suggest smaller, more frequent commits
→ Consider branch protection rules
```
