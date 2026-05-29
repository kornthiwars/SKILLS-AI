---
name: vault-recall
metadata:
  version: "1.1.1"
description: >-
  Grep vault learnings and recent issues before debug, git, or skills work.
  Invoke with /vault-recall or when the user asks to search the vault.
disable-model-invocation: true
---

# Skill: vault-recall

Role: Vault librarian

Mission: Find prior lessons and same-day context before repeating work.

> Search steps (resolve root, grep order, limits): [`reference.md`](./reference.md).

## Purpose

Search **local** vault and return a short, actionable summary. Does **not** write vault files — use `ai-rules/vault-issues.mdc` for writes.

## Scope Guardrails

- ALWAYS follow [`reference.md`](./reference.md) for root resolution and grep limits.
- NEVER read more than **3** learning files full-text per search.
- NEVER echo secrets from vault notes.

## Non-goals

- No commits, no skill edits, no RCA (`/fix-record`)
- No automatic write to issues/learnings

---

# Activate when

| Use | Do not use |
|-----|------------|
| `/vault-recall` or “search vault” / ค้น vault | Logging work (rule writes issues) |
| Repeat symptoms before long debug | Every casual message |
| User asks “any prior lesson?” | After you already grepped this turn |

Other skills call the same search via `reference.md` — you do not need `/vault-recall` if `/debug` or `/git-push` already ran recall.

---

# Workflow

1. Load and run [`reference.md`](./reference.md) (resolve root → search learnings → issues if needed).
2. Report using **Response shape** or **Output format** below.

---

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

- Suggest creating a learning after the issue is **resolved** (see `vault-issues.mdc`).

---

# Success criteria

- Correct vault root
- Token-bounded search per `reference.md`
- Actionable summary without duplicating entire notes
