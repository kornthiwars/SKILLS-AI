---
name: vault-recall
metadata:
  version: "1.0.0"
description: >-
  Grep vault learnings and recent issues before debug, git, or skills work.
  Invoke with /vault-recall or when the user asks to search the vault.
disable-model-invocation: true
---

# Skill: vault-recall

Role: Vault librarian

Mission: Find prior lessons and same-day context before repeating work.

## Purpose

Search **local** vault (`learnings/` then `issues/`) and return a short, actionable summary. Does **not** write vault files — use `ai-rules/vault-issues.mdc` for that.

## Scope Guardrails

- ALWAYS resolve vault root before grep (same rules as `vault-issues.mdc`).
- NEVER read more than **3** learning files full-text per search.
- NEVER echo secrets from vault notes.

## Non-goals

- No commits, no skill edits, no RCA (`/fix-record`)
- No automatic write to issues/learnings

---

# Activate when

- User runs `/vault-recall` or asks to search vault / ค้น vault / มีบทเรียนไหม
- Before a long debug session when user mentions repeat symptoms
- Optional pre-step when another skill says "grep learnings first"

---

# Workflow

## 1 — Resolve root

| Step | Vault root |
|------|------------|
| 1 | `<workspace>/.cursor/ai-skills-vault.json` paths |
| 2 | `<workspace>/.cursor/vault/` exists |
| 3 | `<workspace>/vault/` |
| 4 | Folder with `ai-skills/` + `scripts/setup-macos-linux.sh` |

If `learnings/` has only `README.md` → report empty; skip to issues.

## 2 — Search learnings

Grep `vault/learnings/` for user keywords, error text, `skill:`, `symptoms:`, `files:`.

- Cap ~15 matching lines
- Read **≤3** best-matching `.md` files (not README)

## 3 — Search issues (if needed)

Grep `vault/issues/YYYY-MM-DD.md` for **today** and **yesterday** (same keywords).

## 4 — Report

## Response shape

- **Summary** — hit count, best file(s), one-line takeaway
- **Details** — bullet per note: path, `title:`, symptom, fix snippet
- **Next step** — open file, run `/debug`, or no prior art

---

# Output format (full recall)

## Recall summary

- **Query:**
- **Vault root:**
- **Learnings matched:** N (paths)
- **Issues matched:** N (paths)

## Top matches

For each file (max 3):

- **Path:**
- **Title / skill:**
- **Use when:**
- **Fix (short):**

## If empty

- Suggest creating a learning after the issue is **resolved** (see `vault-issues.mdc` criteria).

---

# Success criteria

- Correct vault root
- Token-bounded search (≤3 full files)
- Actionable summary without duplicating entire notes
