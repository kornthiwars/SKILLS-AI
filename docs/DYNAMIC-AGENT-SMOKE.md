# Dynamic agent smoke (manual)

Static checks:

```bash
./scripts/smoke-skills.sh
./scripts/verify-dynamic-smoke-static.sh   # file content preflight for scenarios below
```

CI: `skills-quality.yml` runs `smoke-skills.sh` + `verify-dynamic-smoke-static.sh`.

This doc lists **behavioral** scenarios to run in Cursor after rule/skill changes. Full agent automation is out of scope for CI; use the static script first, then manual prompts.

## Prerequisites

- `./scripts/setup-macos-linux.sh .`
- Reload Cursor
- Fresh chat per scenario

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

## Static preflight (automated)

`./scripts/verify-dynamic-smoke-static.sh` checks that skills/rules **contain** the gates for scenarios 1–10 and 8 (smoke exists). It does **not** replace running prompts in Cursor.

## Record results

| Result | Where |
|--------|--------|
| Static preflight fail | Fix files, re-run script |
| Behavioral fail in Cursor | `vault/issues/` or `/wiki-ingest` after close |

Log repeatable gaps to issues when open; durable knowledge via `/wiki-ingest` when closed per `vault-issues.mdc`.

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md)
