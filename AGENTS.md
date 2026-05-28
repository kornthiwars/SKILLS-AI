# AGENTS.md

Universal agent entry point for **SKILLS-AI**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md) · [`vault/`](vault/README.md)

---

## Setup (once per clone)

Pass **install root** = the folder you open in Cursor (workspace root). See [scripts/README.md](scripts/README.md).

| OS | Command |
|----|---------|
| Windows | `.\scripts\setup-windows.ps1 -InstallRoot <workspace>` |
| macOS / Linux | `./scripts/setup-macos-linux.sh <workspace>` (requires `python3`) |

| Cursor workspace | From inside SKILLS-AI clone |
|------------------|-------------------------------|
| Repo root | `-InstallRoot .` |
| Parent project | `-InstallRoot ..` |

Creates under `<workspace>/.cursor/`:

- `skills` → `ai-skills/`
- `rules` → `ai-rules/`
- `vault` → `vault/`
- `ai-skills-vault.json`

Edit **`ai-skills/`**, **`ai-rules/`**, **`vault/`** in the clone — not inside `.cursor/` junctions/symlinks.

---

## Skills (`ai-skills/`)

| Skill | Use when |
|-------|----------|
| [debug](ai-skills/debug/SKILL.md) | Bugs, stack traces, systematic diagnosis |
| [scrutinize](ai-skills/scrutinize/SKILL.md) | Review plan, PR, or diff end-to-end |
| [sql](ai-skills/sql/SKILL.md) | READ / MIGRATE / WRITE database work |
| [builder-ui](ai-skills/builder-ui/SKILL.md) | UI architecture from references |
| [builder-api](ai-skills/builder-api/SKILL.md) | API contracts and backend boundaries |
| [builder-schema](ai-skills/builder-schema/SKILL.md) | Data modeling and migrations |
| [builder-infrastructure](ai-skills/builder-infrastructure/SKILL.md) | IaC, CI/CD, observability |
| [builder-feature](ai-skills/builder-feature/SKILL.md) | Cross-layer feature orchestration |
| [fix-record](ai-skills/fix-record/SKILL.md) | RCA after validated fix |
| [upgrade-ai](ai-skills/upgrade-ai/SKILL.md) | Improve skills in this repo |
| [git-push](ai-skills/git-push/SKILL.md) | Safe commit + push (sole git skill) |
| [vault-recall](ai-skills/vault-recall/SKILL.md) | **When:** `/vault-recall` or search vault · **Not:** logging (use `vault-issues.mdc`) · Search SSoT: [reference.md](ai-skills/vault-recall/reference.md) |

Authoring: [ai-skills/SKILL-AUTHORING.md](ai-skills/SKILL-AUTHORING.md) · Change-control: [docs/CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) · Smoke: [docs/SKILL-SMOKE-CHECKLIST.md](docs/SKILL-SMOKE-CHECKLIST.md)

---

## Rules (`ai-rules/`)

| Rule | Role |
|------|------|
| [change-control-manifest.mdc](ai-rules/change-control-manifest.mdc) | **Production AI** — observe→verify, patch budget, confidence gates |
| [bilingual-th-en.mdc](ai-rules/bilingual-th-en.mdc) | Thai ~60% / English ~40% replies |
| [vault-issues.mdc](ai-rules/vault-issues.mdc) | Work Q&A in `vault/issues/`; lesson cards in `vault/learnings/` |
| [clean-code.mdc](ai-rules/clean-code.mdc) | Code style for generated application code |
| `ai-rules/{core,debugging,patching,architecture,testing,risk,workflow}/` | Scoped production rules — see [CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) |

---

## Git in this repo

Ship changes with **`@git-push`** only. Commit canonical paths (`ai-skills/`, `ai-rules/`, `scripts/`, `templates/`, `docs/`) — not daily vault content (`vault/issues/*.md`, `vault/learnings/*` except README are gitignored).
