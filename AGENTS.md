# AGENTS.md

Universal agent entry point for **agent-skills**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md) · [`vault/`](vault/README.md)

---

## Setup (once per clone)

Pass **install root** = the folder you open in Cursor (workspace root). See [scripts/README.md](scripts/README.md).

| OS | Command |
|----|---------|
| Windows | `.\scripts\setup-windows.ps1 -InstallRoot <workspace>` |
| macOS / Linux | `./scripts/setup-macos-linux.sh` (requires `python3`; default = parent folder) |

| Cursor workspace | From inside agent-skills clone |
|------------------|-------------------------------|
| Parent project (default) | `./scripts/setup-macos-linux.sh` |
| Repo root only | `./scripts/setup-macos-linux.sh .` |

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
| [builder-ui](ai-skills/builder-ui/SKILL.md) | UI architecture from references |
| [builder-api](ai-skills/builder-api/SKILL.md) | API contracts and backend boundaries |
| [builder-schema](ai-skills/builder-schema/SKILL.md) | Data modeling and migrations |
| [builder-infrastructure](ai-skills/builder-infrastructure/SKILL.md) | IaC, CI/CD, observability |
| [builder-feature](ai-skills/builder-feature/SKILL.md) | Cross-layer feature orchestration |
| [fix-record](ai-skills/fix-record/SKILL.md) | RCA after validated fix |
| [upgrade-ai](ai-skills/upgrade-ai/SKILL.md) | Improve skills in this repo |
| [git-push](ai-skills/git-push/SKILL.md) | Safe commit + push (sole git skill) |
| [vault-recall](ai-skills/vault-recall/SKILL.md) | **When:** `/vault-recall` · Search SSoT: [reference.md](ai-skills/vault-recall/reference.md) |
| [wiki-ingest](ai-skills/wiki-ingest/SKILL.md) | Curate long-lived knowledge in `vault/wiki/` (LLM Wiki Pattern) |
| [workday-init](ai-skills/workday-init/SKILL.md) | Morning plan from raw intentions (API/WEB/SKILL/DOCS/OPS) |
| [workday-update](ai-skills/workday-update/SKILL.md) | Mid-day plan updates — bugs, scope changes, no duplicates |
| [workday-review](ai-skills/workday-review/SKILL.md) | End-of-day audit — git/code evidence vs plan |

Authoring: [ai-skills/SKILL-AUTHORING.md](ai-skills/SKILL-AUTHORING.md) · Change-control: [docs/CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) · Smoke: [docs/SKILL-SMOKE-CHECKLIST.md](docs/SKILL-SMOKE-CHECKLIST.md) · **Thai:** [docs/th/README.md](docs/th/README.md) ([APPENDIX](docs/th/APPENDIX-TH.md))

---

## Rules (`ai-rules/`)

| Rule | Role |
|------|------|
| [change-control-manifest.mdc](ai-rules/change-control-manifest.mdc) | **Production AI** — observe→verify, patch budget, confidence gates |
| [bilingual-th-en.mdc](ai-rules/bilingual-th-en.mdc) | Thai ~60% / English ~40% replies |
| [vault-issues.mdc](ai-rules/vault-issues.mdc) | Work Q&A in `vault/issues/`; wiki via `/wiki-ingest` |
| [clean-code.mdc](ai-rules/clean-code.mdc) | Code style for generated application code |
| `ai-rules/{core,debugging,patching,architecture,testing,risk,workflow}/` | Scoped production rules — see [CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) |

---

## Git in this repo

Ship changes with **`@git-push`** only. Commit canonical paths — not daily vault content (`vault/issues/*.md`, `vault/workday/*.md`, `vault/wiki/**` except README are gitignored).
