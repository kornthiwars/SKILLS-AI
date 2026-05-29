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
./scripts/setup-macos-linux.sh .          # workspace = agent-skills
./scripts/setup-macos-linux.sh ..         # workspace = parent project
```

Requires `python3` (for `ai-skills-vault.json`).

Edit canonical folders in the **agent-skills** repo only — not inside the target project's `.cursor/` symlinks/junctions.

## Quality scripts

```bash
chmod +x scripts/smoke-skills.sh scripts/change-control-check.sh
./scripts/smoke-skills.sh           # rules + skills structure
./scripts/change-control-check.sh   # patch budget (5 files / 120 lines)
# CI/PR: DIFF_BASE=origin/main...HEAD ./scripts/change-control-check.sh
```

See [docs/CHANGE-CONTROL.md](../docs/CHANGE-CONTROL.md) · Dynamic scenarios: [docs/DYNAMIC-AGENT-SMOKE.md](../docs/DYNAMIC-AGENT-SMOKE.md).
