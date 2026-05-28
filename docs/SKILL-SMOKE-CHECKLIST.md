# SKILL smoke checklist

```bash
./scripts/smoke-skills.sh
./scripts/change-control-check.sh
```

Reload Cursor after rule changes.

## Setup

- [ ] `./scripts/setup-macos-linux.sh .`
- [ ] `.cursor/rules` → `ai-rules/` (includes subfolders)
- [ ] `change-control-manifest.mdc` loads (alwaysApply)

## Change-control

- [ ] Agent does not patch before diagnosis on bugs
- [ ] Patch >5 files → justify or stop
- [ ] HIGH risk → asks approval
- [ ] `/debug` used for stack traces

## Core skills

| Skill | Check |
|-------|--------|
| debug | Mantra + vault recall + manifest |
| scrutinize | Skill PR checklist + manifest |
| git-push | Blocked without ยืนยัน |
| sql | Prod gate |
| vault-recall | ≤3 files |

## CI

- [ ] `.github/workflows/skills-quality.yml` green on PR
