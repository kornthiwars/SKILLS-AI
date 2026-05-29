---
name: git-push
metadata:
  version: "1.1.6"
description: >-
  Safe inspect, commit (explicit request only), and push; dirty-tree matrix, SSH
  identity, multi-account remotes. Invoke with /git-push or ยืนยัน after blocked push.
disable-model-invocation: true
---

# Skill: git-push

Role: Release operator

Mission: Inspect repo state, use the correct remote identity, push once, verify.

> Matrix, commit gate detail, SSH, and failure table: [`reference.md`](./reference.md).

## Purpose

Push local git work to a remote (typically GitHub) **safely and predictably**.

This skill does NOT:
- commit without explicit user request
- change `git config`
- force-push to `main`/`master` without explicit user request
- skip hooks (`--no-verify`) unless the user explicitly asks
- amend commits unless all amend safety conditions are met

## agent-skills repo (this library)

When pushing **this** repository:

- Edit and commit **`ai-skills/`**, **`ai-rules/`**, **`scripts/`**, **`templates/`**, **`docs/`** — not files only under `.cursor/` junctions.
- After clone, run `./scripts/setup-macos-linux.sh .` so Cursor loads linked skills.
- `vault/issues/*.md` and `vault/learnings/*` (except README) are **gitignored** — local only.

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Change-control

Before commit: run `./scripts/change-control-check.sh` when available. Respect patch budget and [`approval-gates`](../../ai-rules/risk/approval-gates.mdc) in [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

---

# Core Principles

- **Commit only on request** — `/git-push` alone is not permission to commit
- **Read before write** — inspect status, diff, branch, remote first
- **Decision before action** — use the push decision matrix in `reference.md`
- **Correct identity** — SSH must match the account that owns the remote repo
- **Verify after push** — confirm tracking and remote HEAD

---

# Activate When

- User asks to push, publish, or sync to GitHub
- User runs init → add → commit → push sequences
- Push failed (auth, permission denied, wrong account, no upstream)
- User confirms after a blocked push (e.g. ยืนยัน, confirm, yes commit and push)

Do NOT activate for: general coding tasks unrelated to git remote sync.

---

# Workflow

## Phase 0 — Vault recall (blocked push or git friction)

When push is **blocked**, failed before, or symptoms match SSH/remote/dirty-tree: run search per [`vault-recall/reference.md`](../vault-recall/reference.md), apply documented fixes, then continue Phase 1. Optional: `/vault-recall` for a user-facing summary.

## Phase 1 — Inspect

Run in parallel when possible:

```bash
git status
git diff
git diff --staged
git branch -vv
git remote -v
git log -3 --oneline
```

Also: commits ahead (`git rev-list --count @{u}..HEAD 2>/dev/null` or status), remote URL scheme.

**Secrets / local config:** If `git diff --name-only` or `git diff --staged --name-only` matches `.env`, `.env.*`, or other local-only config — **warn** in Pre-push State; **exclude from commit** unless the user explicitly asks to include them (see [`reference.md`](./reference.md) Phase 2).

## Phase 2–5

Follow [`reference.md`](./reference.md): **Commit gate** → **Remote & identity** → **Push** → **Verify**.

Apply the **push decision matrix** after Phase 1.

---

## Response shape

Default for short turns — **section headers only**:

- **Summary** — branch, remote, result in one line
- **Details** — matrix row taken, ahead/behind count, or block cause
- **Next step** — exact user phrase or command to unblock

After a successful push or full pre-push state, use **# Output Format** below.

---

# Output Format

## Push Summary

- **Branch:**
- **Remote:**
- **Commits pushed:** (range or count)
- **Result:** success / blocked / up to date

## Pre-push State

- Uncommitted changes: yes/no
- Commits ahead of origin: N
- Path taken: (matrix row)

## If Blocked

- **Cause:**
- **Evidence:** (command snippet)
- **Proposed commit message:** (if dirty)
- **Recommended fix:** (what user should say or run)

---

# Success Criteria

- Correct branch on intended remote
- Upstream set when needed
- No unintended commits or force pushes
- User gets repo link and clear final status
