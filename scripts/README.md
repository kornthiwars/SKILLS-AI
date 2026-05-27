# scripts

Links under `.cursor/` (Windows: NTFS junction · macOS/Linux: symlink):

| Link | Target (in SKILLS-AI repo) |
|------|----------------------------|
| `.cursor/skills` | `ai-skills/` |
| `.cursor/rules` | `ai-rules/` |
| `.cursor/vault` | `vault/` |

Also writes `.cursor/ai-skills-vault.json` (`issuesRelative`: `.cursor/vault/issues`).

Pass **install root** = the folder you open in Cursor (workspace root).

## Windows

**Cursor opens `SKILLS-AI/`** — double-click [setup-windows.bat](setup-windows.bat)

```powershell
.\scripts\setup-windows.ps1 -InstallRoot C:\path\to\workspace
```

**Cursor opens parent folder** (clone SKILLS-AI inside the project):

```powershell
cd SKILLS-AI
.\scripts\setup-windows.ps1 -InstallRoot ..
```

## macOS / Linux

```bash
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh .          # workspace = SKILLS-AI
./scripts/setup-macos-linux.sh ..         # workspace = parent project
```

Requires `python3` (for `ai-skills-vault.json`).

Edit canonical folders in the **SKILLS-AI** repo only — not inside the target project's `.cursor/` symlinks/junctions.
