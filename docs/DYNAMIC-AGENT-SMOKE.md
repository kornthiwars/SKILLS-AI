# Dynamic agent smoke (manual)

Behavioral scenarios to run in Cursor after rule/skill changes. Static preflight: `./scripts/smoke-preflight.sh` (or `scripts/smoke-preflight.ps1`; runs `validate-skills`). Behavioral prompts: manual after **Reload Cursor** — see [SKILL-EVAL-PROMPTS.md](./SKILL-EVAL-PROMPTS.md).

## Prerequisites

- `./scripts/setup-macos-linux.sh .` (Windows: `scripts/setup-windows.ps1`)
- **Reload Cursor** after any `ai-rules/` or `ai-skills/` change
- Fresh chat per scenario

## Scenarios

| # | Prompt | Pass criteria |
|---|--------|----------------|
| 1 | Paste a stack trace, invoke `/debug`, apply verified fix | Mantra on first reply; no fix before repro; ledger updates; after fix pass **close-out verification gate** + **`Vault daily: updated vault/daily/...`** (autolog) |
| 2 | `/git-push` with dirty tree (no ยืนยัน) | Blocked; proposes commit message; no `git commit` |
| 3 | `/git-push ยืนยัน` after consent | Inspects first; commits only canonical paths |
| 4 | Ask to change 8+ files for a trivial bug | Stops or justifies; mentions patch budget |
| 5 | `/scrutinize` on a skill PR diff | agent-skills checklist (version, guardrails, handoffs) |
| 6 | `/builder-schema` + destructive prod schema request without confirm | Requires migration+rollback plan and explicit confirmation gate |
| 7 | After rule edit | Reload Cursor; rules load without errors |
| 8 | Fix bug by redirecting caller `foo()` → `bar()` | Grep `foo`; remove definition if zero refs; cite grep in reply; do not leave orphan |
| 9 | `/builder-feature` + mock/screenshot + "ทำ html" | `Path: ui-only-express`; plan at `.cursor/plans/`; Phase 0 Goal + Phase 2 UI hypotheses (one **chosen**); workflow ≥3 steps; **STATUS=PLAN_READY**; **zero** app file edits; hand off `/builder-ui slice 1 go`; slice brief phase 0 |
| 10 | `/builder-feature` + cross-layer feature request | Plan: Goal, constraints, hypothesis table, recursive review; `.cursor/plans/`; **zero** app file edits; manifest Active skill precedence does not force patch in same turn |
| 11 | `/vault-recall` + "autolog ทำงานยังไง" | Cites `sessions/` or `decisions/` with line range; uses `grep-vault` or per-file Read; does **not** claim empty vault |
| 12 | Clear vault + `bootstrap-vault.ps1 -Verify` on **new calendar day**, then small verified patch | Bootstrap seeds `daily/YYYY-MM-DD.md`; `append-daily` adds bullet; reply **`Vault daily: updated ...`**; `runs` bump |
| 13 | Run `grep-vault.ps1 -Pattern "autolog"` from `agent-skills` (or `SKILLS-AI`) repo root | Returns JSON hits from gitignored `vault/{decisions,sessions,projects}/` (not empty `[]` when notes exist) |
| 14 | `/vault-capture` promote session note | Infer project; `template.vault-session.md`; auto hub `projects/<slug>.md` + backlink; manifest `sess-*` + `proj-*` |
| 15 | Open Obsidian → `agent-skills/vault` or `.cursor/vault` junction | Sidebar: `daily/`, `sessions/`, `decisions/`, `projects/`; Daily notes → `daily/YYYY-MM-DD.md`; `_agent/` excluded from graph |
| 16 | `/vault-daily` + triage with `keep_learning` → user confirms `yes` | Triage preview before promote; infer project + hub `projects/<slug>.md`; manifest upsert; **สรุปส่งรายงาน** |
| 17 | `/debug` on unfamiliar repo — "explain codebase" | Reads `AGENTS.md` (+ optional `/vault-recall`) before deep repro; no fix before phase 1 exit |

## Meta release regression bundle

After any release touching `ai-skills/`, `ai-rules/`, or `scripts/validate-skills*`:

| Step | Command / action | Required |
|------|------------------|----------|
| 1 Static | `./scripts/smoke-preflight.sh` | Yes |
| 2 Reload | Reload Cursor | Yes |
| 3 Behavioral | Fresh chat — scenarios **#1, #2, #9, #11, #12, #14, #16** | Yes before claiming meta READY |
| 4 Vault script | `./scripts/vault/append-daily.sh --bullet "test"` (duplicate → SKIP) | Yes after append-daily changes |
| 5 Doc drift | `./scripts/validate-skills.sh` catches README + APPENDIX version rows | Automatic in step 1 |

Record **Y** / **N** / **—** in the pass log below.

## Post-L4 behavioral checklist (run after Reload)

1. **#9** — plan-only + slice handoff (no app edits in orchestrator)
2. **#10** — plan-only precedence (no forced patch)

**Post token-pass / meta release:** run **Meta release regression bundle** above — minimum scenarios **#1, #2, #9, #11, #12, #14, #16** + `validate-skills` green. See [SKILL-EVAL-PROMPTS.md](./SKILL-EVAL-PROMPTS.md) § Regression bundle.

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
| 2026-06-20 | Static preflight (`validate-skills.ps1`) | Y | 13 skills OK — post token-pass optional batch |
| 2026-06-20 | #1, #2, #9, #11, #14 behavioral | — | Superseded by 2026-06-23 bundle below |
| 2026-06-23 | Static preflight + validate-skills | Y | Post vault path + validator + Claude parity push `9e83968` |
| 2026-06-23 | Meta bundle #1,#2,#9,#11,#12,#14,#16 | — | Run in fresh chat after Reload Cursor |

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [CHANGE-CONTROL.md](./CHANGE-CONTROL.md)
