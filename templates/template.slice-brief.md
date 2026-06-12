# Slice brief — pack output contract

Handoff payload from **`/builder-feature`** to owner skills (`/builder-ui`, `/builder-api`, …).

Link from [`builder-feature/reference.md`](../ai-skills/builder-feature/reference.md) § Slice brief · [`builder-ui/reference.md`](../ai-skills/builder-ui/reference.md) § Slice brief intake.

---

## Render format

Emit this block in chat when user approves slice **N** (fill placeholders; remove optional sections if empty):

```markdown
## Slice {{N}} brief (from /builder-feature)

**Feature:** {{FEATURE_NAME}}
**Plan ref:** {{link to PLAN_READY block in chat — or —}}

**Outcome:** {{one sentence — user-visible result of this slice}}

**Workflow steps covered:** {{step numbers or short list}}

**Owner:** /builder-ui | /builder-api | /builder-schema | /builder-infrastructure

**Files likely touched:** {{suggestions only — owner confirms}}

**Contracts:** {{API/schema contracts this slice must honor — or —}}

**Non-goals:** {{what this slice must not change}}

**Verify:** {{command, URL, or walkthrough that proves slice done}}

**Depends on slice:** {{number or —}}
```

---

## Required fields (owner must block without)

| Field | Owner skill |
|-------|-------------|
| Outcome | all |
| Non-goals | all |
| Verify | all |
| Owner | builder-feature sets; owner confirms |

Optional: Workflow steps covered, Files likely touched, Contracts, Depends on slice.

---

## Example (UI slice 1)

```markdown
## Slice 1 brief (from /builder-feature)

**Feature:** Maxwell Plans page
**Plan ref:** PLAN_READY block in chat (Maxwell Plans feature plan)

**Outcome:** Static pricing page matching mock — nav, hero, toggle, three cards.

**Workflow steps covered:** 1–4 (view and compare plans)

**Owner:** /builder-ui

**Files likely touched:** maxwell-plans/index.html, maxwell-plans/styles.css

**Contracts:** —

**Non-goals:** backend, auth, annual price logic

**Verify:** Open index.html in browser; Enterprise card dark theme visible

**Depends on slice:** —
```
