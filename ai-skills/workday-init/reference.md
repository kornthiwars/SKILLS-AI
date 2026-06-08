# workday-init — reference

WORKDAY block shape: [`templates/template.workday.md`](../../templates/template.workday.md).

All workday skills (**init · update · review**) use this file for **persistence** — do not duplicate in each `SKILL.md`.

Update-specific dedupe and discovery rules: [`workday-update/reference.md`](../workday-update/reference.md).

---

## Persistence (mandatory)

Every close-out **must** write the vault file **and** show the WORKDAY block in chat.

### Resolve workday directory

| Step | If true → workday dir |
|------|------------------------|
| 1 | Read `<workspace>/.cursor/ai-skills-vault.json` → join `vaultRoot` + `workday/` or resolve `workdayRelative` from workspace root |
| 2 | `<workspace>/.cursor/vault/workday/` exists | use via junction |
| 3 | `<workspace>/vault/workday/` or `<agent-skills>/vault/workday/` | use |
| 4 | Folder contains `ai-skills/` + `scripts/setup-macos-linux.sh` | `{clone}/vault/workday/` |

Create `workday/` if missing.

**Never** write WORKDAY plans to `vault/issues/` — use `vault/workday/` only.

**Feature plans** (orchestrator output from `/builder-feature`): optional `vault/workday/plans/{feature-slug}.md` — see [`builder-feature/reference.md`](../builder-feature/reference.md) § Plan persistence · [`templates/template.feature-plan.md`](../../templates/template.feature-plan.md).

### File path

`vault/workday/YYYY-MM-DD.md` — **one file per day**, updated in place.

Date = **DATE** field in WORKDAY block (default: today local).

### Write protocol

1. Build full **WORKDAY** block per [`template.workday.md`](../../templates/template.workday.md).
2. Load [`template.workday-file.md`](../../templates/template.workday-file.md):
   - `{{YYYY-MM-DD}}` → DATE
   - `{{STATUS}}` → `active` (init/update) or `closed` (review)
   - `{{VERSION}}` → see table below
   - `{{SKILL}}` → `workday-init` | `workday-update` | `workday-review`
   - `{{WORKDAY_BLOCK}}` → block verbatim (no extra code fence)
3. **init** — if file exists same day, overwrite (re-plan); set `plan_version: 1` unless user says "continue plan" → then treat as update.
4. **update / review** — read existing file, increment `plan_version`, overwrite same path (no copies).
5. Write UTF-8 to `vault/workday/YYYY-MM-DD.md`.
6. Tell user the **absolute or workspace-relative path** in chat.

### plan_version by skill

| Skill | Version rule |
|-------|----------------|
| init (new day or re-plan) | `1` |
| init ("continue" / amend morning) | previous + 1 |
| update | previous + 1 |
| review | previous + 1; set `status: closed` |

Plan changes are tracked in **DISCOVERED TODAY** (`+ plan v{N} — …`), not separate files.

### Load protocol (update / review)

1. Read `vault/workday/YYYY-MM-DD.md` if present.
2. Else fall back to WORKDAY block in chat (same session).
3. Else hand off to `/workday-init`.

---

## Version governance

| Change | Bump skill `metadata.version` |
|--------|------------------------------|
| Wording | patch |
| Persistence path or protocol | minor |
| Breaking WORKDAY block shape | major + `template.workday.md` |
