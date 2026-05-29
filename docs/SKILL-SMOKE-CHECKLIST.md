# SKILL smoke checklist

```bash
./scripts/smoke-skills.sh              # includes verify-dynamic-smoke-static.sh
./scripts/change-control-check.sh
./scripts/verify-dynamic-smoke-static.sh   # optional standalone
```

Reload Cursor after rule changes.

## Setup

- [ ] `./scripts/setup-macos-linux.sh .`
- [ ] `.cursor/rules` → `ai-rules/` (includes subfolders)
- [ ] `change-control-manifest.mdc` loads (alwaysApply)

## Change-control

- [ ] Agent does not patch before diagnosis on bugs
- [ ] Patch >5 files → justify, stop, or `[BUDGET-OVERRIDE]` in commit
- [ ] HIGH risk → asks approval
- [ ] `/debug` used for stack traces — **mantra** on first reply (or user skips)
- [ ] `./scripts/change-control-check.sh` PASS before commit (or intentional override)

## Core skills

| Skill | Check |
|-------|--------|
| debug | Mantra + vault recall + manifest |
| scrutinize | Skill PR checklist + manifest |
| git-push | Blocked without ยืนยัน |
| sql | Prod gate |
| vault-recall | ≤3 learning files |

## Docs

- [ ] `docs/th/README.md` present (Thai guides)

## CI

- [ ] `.github/workflows/skills-quality.yml` green on PR
- [ ] PR over patch budget fails CI unless `[BUDGET-OVERRIDE]` in a commit on the branch

## Dynamic

- [ ] `./scripts/verify-dynamic-smoke-static.sh` PASS (or via smoke-skills.sh)
- [ ] Run behavioral scenarios in [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) in Cursor after major rule/skill changes
