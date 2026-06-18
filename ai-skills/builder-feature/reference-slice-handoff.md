# builder-feature — slice backlog and handoff

## Slice backlog (required artifact)

Canonical anchor for owner skills (`/builder-ui`, `/builder-api`, …) — vertical slice rules.

From [addyosmani/incremental-implementation](https://github.com/addyosmani/agent-skills) — thin vertical slices, one at a time:

| Slice | User-visible outcome | Owner skill | Depends | Verify (command / walkthrough) |
|-------|----------------------|-------------|---------|------------------------------|
| 1 | Smallest path UI→API→data (or stub) | `/builder-ui` + … | — | … |
| 2 | … | … | 1 | … |

Rules:

- Thin vertical slices — smallest user-visible path first; verify before next slice
- One slice per specialist invocation unless user explicitly batches with approval
- `/scrutinize` before merge per slice; no unrelated layers in one slice
- Implementation: **owner skill only** — not builder-feature

## Slice brief (handoff payload)

When user approves slice N, emit the block from [`templates/template.slice-brief.md`](../../templates/template.slice-brief.md) — required fields: **Outcome**, **Non-goals**, **Verify**, **Owner**. Set **Plan ref:** to the plan file path.

Do not invent an alternate brief shape; owner skills parse this contract ([`builder-ui/reference.md`](../builder-ui/reference.md) § Slice brief intake).

---

## Plan quality checklists (phase 7)

Run before `plan_ready` — cross-layer plans; express lane may mark integration/delegation N/A.

### Delegation quality

- Responsibilities mapped to the right specialist?
- No overlap or duplicated ownership?
- Sequencing explicit and dependency-aware?

### Reuse

- Existing module reused where possible?
- Extension before new build?
- Shared contracts preserved?

### Integration risk

- Async flows and retries explicit?
- Cache invalidation defined?
- Rollback safe across layers?
- Permissions consistent end-to-end?

Map to plan Phase 7: ownership → Delegation; reuse → Reuse row; integration/rollback → Integration risk.

## Anti-rationalization table

| Rationalization | Why it fails | Required response |
|---|---|---|
| "งานเล็ก แค่ HTML ไม่ต้องวาง flow" | UX and navigation still change | workflow map + phase 0 |
| "เดี๋ยวค่อยถามทีหลัง ระหว่างเขียน" | wrong assumptions | BLOCK; plan first |
| "builder-feature ทำเองทีเดียวเร็วกว่า" | ownership violation | slice brief → specialist |
| "ข้าม verify ก่อน เดี๋ยวค่อย review" | false-ready | phase 7 plan gate |
| "user said ทำเลย — ข้าม plan" | rework cost | cross-layer: phases 0–1 + slice 1 brief; UI-only no plan: `/builder-ui`; express: finish plan first |
| " scaffold ไว้ก่อน จะได้เห็นภาพ" | plan-only skill | mermaid/table only — no repo edits |
| "แผนยาวใน chat พอแล้ว ไม่ต้องไฟล์" | plan หายข้าม session | plan file required; chat = summary + path |
| "user cancel แล้วยัง implement ต่อ" | scope revoked | `status: cancelled`; stop |
| "flow ชัดแล้ว เขียนเลย" | phase 2–7 skipped | complete plan or explicit defer with gaps listed |

---

## Plan close-out gate

**Canonical checklist:** [`template.feature-plan.md`](../../templates/template.feature-plan.md) § Close-out gate (11 rows).

Before `status: plan_ready` (STATUS **PLAN_READY**): pass all template checks; present plan path in chat (not full body); NEXT ACTIONS = user picks slice → owner skill.

**Express lane:** when `Path: ui-only-express`, close-out row 8 allows Phase 6 N/A (defer 4–6) — document reason in plan body.

Do **not** require integration test RUN at plan close-out — owner skill runs verify after implement. Callee grep per [`callee-redirect-cleanup.mdc`](../../ai-rules/patching/callee-redirect-cleanup.mdc) in **owner skill** close-out, not here.

builder-feature does not re-run for execute unless user re-invokes for **plan revision**.

---

## Legacy plan migration

Plans created before design-reasoning template (no Goal / hypothesis / recursive review) may stay `plan_ready` if slices were already approved.

| Action | When |
|--------|------|
| **Revise plan** | User asks to align with current template — add Phase 0 Goal/constraints, Phase 2 hypotheses, Phase 7 recursive review; keep slice ids |
| **Execute without revise** | Allowed — slice brief + owner skill use existing backlog; close-out gate applies only to **new** `/builder-feature` runs |
| **Re-plan from scratch** | Scope or approach changed materially — re-open hypothesis table |

Do **not** force re-execute completed slices solely because the plan body format changed.

Back: [reference.md](./reference.md)
