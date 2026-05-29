# vault-recall — reference (single source of truth)

Canonical search steps for **`/vault-recall`**, **`debug`**, **`git-push` Phase 0**, and **`vault-issues.mdc`**. Do not duplicate this table elsewhere — link here.

---

## Resolve vault root

| Step | If true → vault root |
|------|----------------------|
| 1 | Read `<workspace>/.cursor/ai-skills-vault.json` → `issuesRelative` / `learningsRelative` |
| 2 | `<workspace>/.cursor/vault/issues/` exists | workspace via junction |
| 3 | `<workspace>/vault/issues/` | workspace root |
| 4 | Folder has `ai-skills/` + `scripts/setup-macos-linux.sh` | agent-skills repo clone |

Create `issues/` and `learnings/` if missing.

---

## Search order (token-efficient)

| Step | Action |
|------|--------|
| 1 | **Grep** `vault/learnings/` — user keywords, error text, `skill:`, `symptoms:`, `files:` |
| 2 | Cap ~15 matching lines · read **≤3** best `.md` files (not README) |
| 3 | If insufficient → grep `vault/issues/YYYY-MM-DD.md` for **today** and **yesterday** |

If `learnings/` is empty (README only) → skip step 1–2; optional issues-only search.

---

## When to run

| Caller | Trigger |
|--------|---------|
| **`/vault-recall`** | User asks to search vault / explicit recall |
| **`/debug`** | Before step 1 (reproduce) — fold hits into ledger |
| **`/git-push`** | Phase 0 when blocked, failed before, or SSH/remote/dirty-tree friction |
| **Rule** | Agent heading into debug or git friction without another skill |

---

## When not to run

- Casual chat turns
- Vault write operations (use `vault-issues.mdc` instead)
- After search already ran this turn (do not grep twice)

---

## Report (recall output)

- **Summary** — hit count, best paths, one-line takeaway
- **Details** — per file: `title:`, symptom, fix snippet (max 3 learnings)
- **Next step** — open note, run `/debug`, or no prior art

If empty → suggest a **learning** after the issue is **closed** (`vault-issues.mdc` criteria).
