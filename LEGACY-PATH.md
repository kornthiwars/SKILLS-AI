# Legacy clone path

This git repo may still live at `SKILLS-AI/` on disk when Cursor locks the folder during rename.

**Canonical name:** `agent-skills/` — use the junction at workspace root:

```
web/agent-skills  →  web/SKILLS-AI  (same repo)
```

When Cursor is closed, optionally rename the physical folder:

```powershell
Remove-Item -Recurse -Force .cursor   # from workspace root
Rename-Item SKILLS-AI agent-skills-physical
Remove-Item agent-skills              # remove junction
Rename-Item agent-skills-physical agent-skills
.\agent-skills\scripts\setup-windows.ps1 -InstallRoot (Get-Location)
```

Until then, edit files here or via `agent-skills/` — both paths are the same repo.
