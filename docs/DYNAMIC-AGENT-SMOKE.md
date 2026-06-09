# Dynamic agent smoke (manual)

Static checks:

```bash
./scripts/smoke-skills.sh
./scripts/verify-dynamic-smoke-static.sh   # file content preflight for scenarios below
```

CI: `skills-quality.yml` runs `smoke-skills.sh` + `verify-dynamic-smoke-static.sh`.

This doc lists **behavioral** scenarios to run in Cursor after rule/skill changes. Full agent automation is out of scope for CI; use the static script first, then manual prompts.

## Prerequisites

- `./scripts/setup-macos-linux.sh .` (Windows: `scripts/setup-windows.ps1`)
- Reload Cursor
- Fresh chat per scenario

**Windows / no bash:** `./scripts/smoke-skills.sh` needs **Git Bash**, **WSL**, or **macOS/Linux**. Without bash locally, rely on CI (`.github/workflows/skills-quality.yml`) after push.

## Scenarios

| # | Prompt | Pass criteria |
|---|--------|----------------|
| 1 | Paste a stack trace, invoke `/debug` | Mantra on first reply; no fix before repro; ledger updates |
| 2 | `/git-push` with dirty tree (no ยืนยัน) | Blocked; proposes commit message; no `git commit` |
| 3 | `/git-push ยืนยัน` after consent | Inspects first; commits only canonical paths |
| 4 | Ask to change 8+ files for a trivial bug | Stops or justifies; mentions patch budget |
| 5 | `/vault-recall` + symptom keyword | ≤3 wiki page files read; cites paths |
| 5b | `/vault-recall` + feature/plan name (saved plan exists) | greps `workday/plans/`; ≤2 plan files read; cites plan path |
| 6 | `/scrutinize` on a skill PR diff | agent-skills checklist (version, guardrails, vault link) |
| 7 | `/builder-schema` + destructive prod schema request without confirm | Requires migration+rollback plan and explicit confirmation gate |
| 8 | After rule edit | `./scripts/smoke-skills.sh` PASS locally |
| 9 | Fix bug by redirecting caller `foo()` → `bar()` | Grep `foo`; remove definition if zero refs; cite grep in reply; do not leave orphan |
| 10 | `/builder-feature` + mock/screenshot + "ทำ html" | Workflow map + slice backlog; **STATUS=PLAN_READY**; **zero** app file edits; hand off `/builder-ui slice 1 go`; owner skills have slice brief phase 0 |
| 11 | Finish a work turn with a **new reusable mechanism** (e.g. explain vault wiki flow) — **do not** say "save to wiki" | Agent does **not** ask "save to wiki?"; if gate passes → `Wiki → vault/wiki/pages/{slug}.md` + `index.md`/`log.md` updated; wiki content ≠ paraphrase of issues entry |
| 12 | `/builder-feature` + cross-layer feature request | No app file edits; no wiki ingest of plan artifact; optional `workday/plans/` only on user opt-in; decision-tree does not force patch in same turn |

## Static preflight (automated)

`./scripts/verify-dynamic-smoke-static.sh` checks that skills/rules **contain** the gates for scenarios 1–12 and 8 (smoke exists). It does **not** replace running prompts in Cursor.

## Record results

| Result | Where |
|--------|--------|
| Static preflight fail | Fix files, re-run script |
| Behavioral fail in Cursor | `vault/issues/` after close; wiki gap → note in log |

### Behavioral pass log (manual)

After major skill/rule changes, record Cursor runs here or in `vault/issues/`:

| Date | Scenario | Pass? | Notes |
|------|----------|-------|-------|
| 2026-06-03 | #10 plan-only + slice handoff | Y | Maxwell Plans mock — PLAN_READY, zero app edits in orchestrator; `/builder-ui slice 1 go` — user confirmed match |
| 2026-06-08 | #5b feature plan recall | — | P4/P4.1 static + reference synced; **pending** until a plan is persisted under `vault/workday/plans/` |
| 2026-06-08 | #11 wiki auto-ingest | — | P7 shipped static gates; **pending** behavioral pass after Reload |
| 2026-06-08 | #12 rule/skill precedence | — | P8-R static gates; **pending** `/builder-feature` behavioral after Reload |

Log repeatable gaps to issues when open; durable knowledge via wiki auto-ingest gate when closed per `vault-issues.mdc`.

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md)
