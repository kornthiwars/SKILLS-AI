# SKILL smoke checklist

Reload Cursor after rule changes.

## Setup

- [ ] `./scripts/setup-macos-linux.sh .` (Windows: `setup-windows.ps1`)
- [ ] `.cursor/rules` → `ai-rules/` (includes subfolders)
- [ ] `change-control-manifest.mdc` loads (alwaysApply)

## Change-control

- [ ] Agent does not patch before diagnosis on bugs
- [ ] Patch >5 files → justify, stop, or `[BUDGET-OVERRIDE]` in commit
- [ ] HIGH risk → asks approval
- [ ] `/debug` used for stack traces — **mantra** on first reply (or user skips)

## Core skills

| Skill | Check |
|-------|--------|
| debug | Mantra + manifest |
| scrutinize | Skill PR checklist + manifest |
| git-push | Blocked without ยืนยัน |
| builder-feature | Plan-only; no `paths` frontmatter; slice handoff |
| builder-schema | Migration + rollback plan |

## Docs

- [ ] `docs/th/README.md` present (Thai guides)

## Dynamic

- [ ] Run behavioral scenarios in [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) in Cursor after major rule/skill changes
