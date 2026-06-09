# scripts

Links under `.cursor/` (Windows: NTFS junction · macOS/Linux: symlink):

| Link | Target (in agent-skills repo) |
|------|----------------------------|
| `.cursor/skills` | `ai-skills/` |
| `.cursor/rules` | `ai-rules/` |
| `.cursor/vault` | `vault/` |

Also writes `.cursor/ai-skills-vault.json` (`issuesRelative`: `.cursor/vault/issues`).

Pass **install root** = the folder you open in Cursor (workspace root).

## Windows

**Cursor opens `agent-skills/`** — double-click [setup-windows.bat](setup-windows.bat)

```powershell
.\scripts\setup-windows.ps1 -InstallRoot C:\path\to\workspace
```

**Cursor opens parent folder** (clone agent-skills inside the project):

```powershell
cd agent-skills
.\scripts\setup-windows.ps1 -InstallRoot ..
```

## macOS / Linux

```bash
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh            # default: parent of agent-skills
./scripts/setup-macos-linux.sh .          # workspace = agent-skills only
./scripts/setup-macos-linux.sh --subprojects exat-web,exat-api-service
```

**Monorepo subprojects:** when `agent-skills/` is a child of the install root, setup also wires **vault-only** (`.cursor/vault` + `ai-skills-vault.json`) into each sibling folder (e.g. `exat-web/`). Override with `--subprojects` or disable with `--no-auto-subprojects`. Agents resolve vault via parent walk — `vault-recall/reference.md` § Resolve step 5.

Requires `python3` (for `ai-skills-vault.json`).

Edit canonical folders in the **agent-skills** repo only — not inside the target project's `.cursor/` symlinks/junctions.

## Quality scripts

```bash
chmod +x scripts/smoke-skills.sh scripts/change-control-check.sh
./scripts/smoke-skills.sh           # rules + skills structure
./scripts/change-control-check.sh   # patch budget (5 files / 120 lines)
./scripts/verify-dynamic-smoke-static.sh  # static preflight for dynamic smoke scenarios
# CI/PR: DIFF_BASE=origin/main...HEAD ./scripts/change-control-check.sh
```

See [docs/CHANGE-CONTROL.md](../docs/CHANGE-CONTROL.md) · Dynamic scenarios: [docs/DYNAMIC-AGENT-SMOKE.md](../docs/DYNAMIC-AGENT-SMOKE.md).
