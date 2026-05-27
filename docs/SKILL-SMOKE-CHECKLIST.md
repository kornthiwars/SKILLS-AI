# SKILL smoke checklist (manual)

Run after changing `ai-skills/`, `ai-rules/`, or setup scripts. Reload Cursor or restart after rule changes.

## Setup

- [ ] Fresh clone: `./scripts/setup-macos-linux.sh .` (or Windows script)
- [ ] `.cursor/skills/debug` → `ai-skills/debug`
- [ ] `ai-rules/vault-issues.mdc` linked under `.cursor/rules/`

## Core skills

| Skill | Trigger | Pass criteria |
|-------|---------|---------------|
| **debug** | `/debug` + paste error | Mantra verbatim first; greps `vault/learnings/` when folder has notes |
| **scrutinize** | `/scrutinize` on small diff | Review cites code path, not diff only |
| **sql** | `/sql` + SELECT | Classifies READ; adds LIMIT; loads `reference.md` for matrix if needed |
| **git-push** | `/git-push` dirty tree | Blocked without commit; **ยืนยัน** → commit+push |
| **upgrade-ai** | `/upgrade-ai` | Full diagnosis format when closing |
| **vault-recall** | `/vault-recall` + keyword | ≤3 files; summary + paths |

## Vault rule

- [ ] Chitchat turn → **no** vault write
- [ ] Work turn (`/git-push`, code) → issues entry `## N.` format
- [ ] Resolved lesson → `learnings/YYYY-MM-DD-HHmm.md` lesson card (not issues copy)
- [ ] Chat one-liner: `บันทึกแล้ว → path`

## Token / invocation

- [ ] `debug`, `scrutinize`, `sql`, `git-push`, `upgrade-ai`, `vault-recall` have `disable-model-invocation: true`
- [ ] Builder skills load `reference.md` only when executing phases

## Git publish (SKILLS-AI repo)

- [ ] Commit paths under `ai-skills/`, `ai-rules/`, not only `.cursor/`
- [ ] `vault/issues/*.md` not in `git status`
- [ ] `metadata.version` bumped for every touched `SKILL.md` / `reference.md`

## Regression spot-check

- [ ] `AGENTS.md` and `ai-skills/README.md` list match installed skills
- [ ] Obsidian opens `vault/` with graph colors (issues vs learnings)
