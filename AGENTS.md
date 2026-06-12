# AGENTS.md

Universal agent entry point for **agent-skills**

Canonical: [`ai-skills/`](ai-skills/README.md) · [`ai-rules/`](ai-rules/README.md)

---

## Setup (once per clone)

Pass **install root** = the folder you open in Cursor (workspace root). See [scripts/README.md](scripts/README.md).

| OS | Command |
|----|---------|
| Windows | `.\scripts\setup-windows.ps1 -InstallRoot <workspace>` |
| macOS / Linux | `./scripts/setup-macos-linux.sh` (default = parent folder) |

Creates under `<workspace>/.cursor/`:

- `skills` → `ai-skills/`
- `rules` → `ai-rules/`
- `vault` → `vault/` (local notes + manifest; agent-only — no Python)

Edit **`ai-skills/`** and **`ai-rules/`** in the clone — not inside `.cursor/` junctions.

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
| [builder-feature](ai-skills/builder-feature/SKILL.md) | Plan-only cross-layer design — slice backlog; **no app code** |
| [fix-record](ai-skills/fix-record/SKILL.md) | RCA after validated fix |
| [upgrade-ai](ai-skills/upgrade-ai/SKILL.md) | Improve skills in this repo |
| [git-push](ai-skills/git-push/SKILL.md) | Safe commit + push (sole git skill) |
| [vault-daily](ai-skills/vault-daily/SKILL.md) | Daily task summary + triage (local vault) |
| [vault-capture](ai-skills/vault-capture/SKILL.md) | Capture session to vault |
| [vault-recall](ai-skills/vault-recall/SKILL.md) | Search vault memory + cite |

Authoring: [ai-skills/SKILL-AUTHORING.md](ai-skills/SKILL-AUTHORING.md) · Change-control: [docs/CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) · **Thai:** [docs/th/README.md](docs/th/README.md) · External catalog: [awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)

---

## Rules (`ai-rules/`)

| Rule | Role |
|------|------|
| [change-control-manifest.mdc](ai-rules/change-control-manifest.mdc) | **Production AI** — observe→verify, patch budget, confidence gates |
| [bilingual-th-en.mdc](ai-rules/bilingual-th-en.mdc) | Thai ~60% / English ~40% replies |
| [clean-code.mdc](ai-rules/clean-code.mdc) | Code style for generated application code |
| `ai-rules/{core,debugging,patching,architecture,testing,risk,workflow}/` | Scoped production rules |

---

## Git in this repo

Ship changes with **`@git-push`** only. The `vault/` folder is gitignored except `.gitkeep` — use it for local notes only.
