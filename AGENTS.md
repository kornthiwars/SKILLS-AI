# AGENTS.md

Universal agent entry point for **agent-skills**

**Architecture spine:** [ARCHITECTURE.md](ARCHITECTURE.md) · Skills: [ai-skills/_catalog/](ai-skills/_catalog/) · Rules: [ai-rules/_index.mdc](ai-rules/_index.mdc)

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
- `vault` → `vault/` (Obsidian vault root; schemas in `templates/vault/` — see [templates/vault/README.md](templates/vault/README.md))

Cursor also discovers **`.agents/skills/`** (Agent Skills open standard) — same layout as `.cursor/skills/`. This pack installs via junction to `.cursor/skills`; optional mirror or symlink to `.agents/skills/` if your tooling expects that path.

**Entry file:** this repo uses **`AGENTS.md`** (same role as `CLAUDE.md` in Claude Code repos) — read before deep work on an unfamiliar codebase; see [`/debug` reference § Unfamiliar repo](ai-skills/debug/reference.md).

Edit **`ai-skills/`** and **`ai-rules/`** in the clone — not inside `.cursor/` junctions.

---

## Skills (`ai-skills/`)

| Domain | Catalog | Invoke examples |
|--------|---------|-----------------|
| Diagnose | [_catalog/diagnose.md](ai-skills/_catalog/diagnose.md) | `/debug` · `/scrutinize` · `/fix-record` |
| Build | [_catalog/build.md](ai-skills/_catalog/build.md) | `/builder-feature` · `/builder-ui` · `/builder-api` |
| Memory | [_catalog/memory.md](ai-skills/_catalog/memory.md) | `/vault-capture` · `/vault-recall` · `/vault-daily` |
| Meta | [_catalog/meta.md](ai-skills/_catalog/meta.md) | `/upgrade-ai` · `/git-push` |

Versions: [docs/th/APPENDIX-TH.md](docs/th/APPENDIX-TH.md) §1

Authoring: [ai-skills/SKILL-AUTHORING.md](ai-skills/SKILL-AUTHORING.md) · Change-control: [docs/CHANGE-CONTROL.md](docs/CHANGE-CONTROL.md) · **Thai:** [docs/th/README.md](docs/th/README.md) · External: [EXTERNAL-PARITY.md](docs/EXTERNAL-PARITY.md) · Catalog listing: [CATALOG-SUBMISSION.md](docs/CATALOG-SUBMISSION.md)

---

## Rules (`ai-rules/`)

Activation map: [ai-rules/_index.mdc](ai-rules/_index.mdc)

| Rule | Role |
|------|------|
| [change-control-manifest.mdc](ai-rules/change-control-manifest.mdc) | **Production AI** — observe→verify, patch budget, confidence gates |
| [bilingual-th-en.mdc](ai-rules/bilingual-th-en.mdc) | Thai ~60% / English ~40% replies |
| [clean-code.mdc](ai-rules/clean-code.mdc) | Code style for generated application code |
| `ai-rules/{core,debugging,patching,architecture,testing,risk,workflow}/` | Scoped production rules |

---

## Application code (`apps/`)

When workspace includes sibling `apps/` folder — static prototypes and UI intake manifests live there. Shared design tokens: `apps/_shared/tokens.css`. See [ARCHITECTURE.md](ARCHITECTURE.md) § Design tokens.

---

## Git in this repo

Ship changes with **`@git-push`** only. The `vault/` folder is gitignored except `.gitkeep` — notes from [templates/vault/README.md](templates/vault/README.md); bootstrap creates dirs + Obsidian seed + today's daily if missing.
