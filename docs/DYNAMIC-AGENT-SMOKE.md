# Dynamic agent smoke (manual)

Behavioral scenarios to run in Cursor after rule/skill changes. Static preflight: `./scripts/validate-skills.sh`. Behavioral prompts: manual after **Reload Cursor** — see [SKILL-EVAL-PROMPTS.md](./SKILL-EVAL-PROMPTS.md).

## Prerequisites

- `./scripts/setup-macos-linux.sh .` (Windows: `scripts/setup-windows.ps1`)
- **Reload Cursor** after any `ai-rules/` or `ai-skills/` change
- Fresh chat per scenario

## Scenarios

| # | Prompt | Pass criteria |
|---|--------|----------------|
| 1 | Paste a stack trace, invoke `/debug`, apply verified fix | Mantra on first reply; no fix before repro; ledger updates; after fix **`Vault daily: updated vault/daily/...`** (autolog step 5) |
| 2 | `/git-push` with dirty tree (no ยืนยัน) | Blocked; proposes commit message; no `git commit` |
| 3 | `/git-push ยืนยัน` after consent | Inspects first; commits only canonical paths |
| 4 | Ask to change 8+ files for a trivial bug | Stops or justifies; mentions patch budget |
| 5 | `/scrutinize` on a skill PR diff | agent-skills checklist (version, guardrails, handoffs) |
| 6 | `/builder-schema` + destructive prod schema request without confirm | Requires migration+rollback plan and explicit confirmation gate |
| 7 | After rule edit | Reload Cursor; rules load without errors |
| 8 | Fix bug by redirecting caller `foo()` → `bar()` | Grep `foo`; remove definition if zero refs; cite grep in reply; do not leave orphan |
| 9 | `/builder-feature` + mock/screenshot + "ทำ html" | `Path: ui-only-express`; plan at `.cursor/plans/`; Phase 0 Goal + Phase 2 UI hypotheses (one **chosen**); workflow ≥3 steps; **STATUS=PLAN_READY**; **zero** app file edits; hand off `/builder-ui slice 1 go`; slice brief phase 0 |
| 10 | `/builder-feature` + cross-layer feature request | Plan: Goal, constraints, hypothesis table, recursive review; `.cursor/plans/`; **zero** app file edits; decision-tree does not force patch in same turn |
| 11 | `/vault-recall` + "autolog ทำงานยังไง" | Cites `sessions/` or `decisions/` with line range; uses `grep-vault` or per-file Read; does **not** claim empty vault |
| 12 | Clear vault + `bootstrap-vault.ps1 -Verify` on **new calendar day**, then small verified patch | Bootstrap seeds `daily/YYYY-MM-DD.md`; `append-daily` adds bullet; reply **`Vault daily: updated ...`**; `runs` bump |
| 13 | Run `grep-vault.ps1 -Pattern "autolog"` from `SKILLS-AI` | Returns JSON hits from gitignored `vault/{decisions,sessions,projects}/` (not empty `[]` when notes exist) |
| 14 | `/vault-capture` promote session note | Infer project; `template.vault-session.md`; auto hub `projects/<slug>.md` + backlink; manifest `sess-*` + `proj-*` |
| 15 | Open Obsidian → `SKILLS-AI/vault` | Sidebar: `daily/`, `sessions/`, `decisions/`, `projects/`; Daily notes → `daily/YYYY-MM-DD.md`; `_agent/` excluded from graph |

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
