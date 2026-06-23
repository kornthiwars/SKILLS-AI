# SKILL smoke checklist

Reload Cursor after rule changes.

## Setup

- [ ] `./scripts/setup-macos-linux.sh .` (Windows: `setup-windows.ps1`)
- [ ] `./scripts/validate-skills.sh` (Windows: `validate-skills.ps1`) — green before ship
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
| debug | Mantra + manifest; verified fix → `Vault daily:` in reply |
| scrutinize | Skill PR checklist + manifest |
| git-push | Blocked without ยืนยัน |
| builder-feature | Plan-only; no `paths` frontmatter; slice handoff |
| builder-schema | Migration + rollback plan |
| vault-recall | `grep-vault` or per-file Read; cites line range; no “empty vault” when notes exist |
| vault-capture | Infer project; session/decision → auto hub `projects/<slug>.md`, backlink, Promoted wikilinks; manifest upsert |
| vault-daily / autolog | New day: bootstrap or `append-daily` creates daily; reply has `Vault daily:` |

## Obsidian (manual)

- [ ] Open `agent-skills/vault` or `.cursor/vault` junction in Obsidian — sidebar shows `daily/`, `sessions/`, `decisions/`, `projects/`
- [ ] Daily notes hotkey creates/opens `daily/YYYY-MM-DD.md`
- [ ] `_agent/` excluded from graph (Settings or seed `app.json`)

## Docs

- [ ] `docs/th/README.md` present (Thai guides)
- [ ] [SKILL-EVAL-PROMPTS.md](./SKILL-EVAL-PROMPTS.md) scenarios still valid after skill edits

## Dynamic

- [ ] Run behavioral scenarios in [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) in Cursor after major rule/skill changes
