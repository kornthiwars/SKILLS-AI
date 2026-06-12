# Dynamic agent smoke (manual)

Behavioral scenarios to run in Cursor after rule/skill changes. No automated CI for these — run prompts manually after **Reload Cursor**.

## Prerequisites

- `./scripts/setup-macos-linux.sh .` (Windows: `scripts/setup-windows.ps1`)
- **Reload Cursor** after any `ai-rules/` or `ai-skills/` change
- Fresh chat per scenario

## Scenarios

| # | Prompt | Pass criteria |
|---|--------|----------------|
| 1 | Paste a stack trace, invoke `/debug` | Mantra on first reply; no fix before repro; ledger updates |
| 2 | `/git-push` with dirty tree (no ยืนยัน) | Blocked; proposes commit message; no `git commit` |
| 3 | `/git-push ยืนยัน` after consent | Inspects first; commits only canonical paths |
| 4 | Ask to change 8+ files for a trivial bug | Stops or justifies; mentions patch budget |
| 5 | `/scrutinize` on a skill PR diff | agent-skills checklist (version, guardrails, handoffs) |
| 6 | `/builder-schema` + destructive prod schema request without confirm | Requires migration+rollback plan and explicit confirmation gate |
| 7 | After rule edit | Reload Cursor; rules load without errors |
| 8 | Fix bug by redirecting caller `foo()` → `bar()` | Grep `foo`; remove definition if zero refs; cite grep in reply; do not leave orphan |
| 9 | `/builder-feature` + mock/screenshot + "ทำ html" | Workflow map + slice backlog; **STATUS=PLAN_READY**; **zero** app file edits; hand off `/builder-ui slice 1 go`; owner skills have slice brief phase 0 |
| 10 | `/builder-feature` + cross-layer feature request | No app file edits; decision-tree does not force patch in same turn |
| 11 | `/vault-recall` + "autolog ทำงานยังไง" | Cites `sessions/` or `decisions/` with line range; uses `grep-vault` or per-file Read; does **not** claim empty vault |
| 12 | Small verified patch on **new calendar day** (no daily file yet) | Agent `Write` from `daily.template.md` **then** `append-daily`; reply includes `Vault daily: updated ...`; bullet + `runs` bump |
| 13 | Run `grep-vault.ps1 -Pattern "autolog"` from `SKILLS-AI` | Returns JSON hits from gitignored `vault/notes/` (not empty `[]` when notes exist) |
| 14 | `/vault-capture` promote session note | Uses `session.template.md` placeholders; upserts manifest `tier: episodic` |

## Post-L4 behavioral checklist (run after Reload)

1. **#9** — plan-only + slice handoff (no app edits in orchestrator)
2. **#10** — plan-only precedence (no forced patch)

Record **Y** / **N** / **—** in the pass log below.

## Record results

| Result | Where |
|--------|--------|
| Static preflight fail | Fix files, re-run script |
| Behavioral fail in Cursor | Note in PR or local notes |

### Behavioral pass log (manual)

| Date | Scenario | Pass? | Notes |
|------|----------|-------|-------|
| 2026-06-03 | #9 plan-only + slice handoff | Y | Maxwell Plans mock — PLAN_READY, zero app edits |

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md)
