---
name: git-push
metadata:
  version: "1.2.6"
description: >-
  Use when the user asks to push, publish, sync to GitHub, or confirms commit+push
  (ยืนยัน). Safely inspect repo state, commit only on explicit consent, push once,
  verify remote. Blocks dirty tree without consent. Invoke with /git-push.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Skill: git-push

Role: Release operator

Mission: Inspect repo state, use the correct remote identity, push once, verify.

## Quick cheat sheet

| State | Action |
|-------|--------|
| Dirty tree, no commit consent | **Blocked** — matrix row; propose message only |
| Clean, ahead of origin | Push after Phase 1 inspect |
| Wrong SSH / remote | Fix identity per reference § Remote & identity |
| After push | Verify remote HEAD + upstream |

Matrix detail: [`reference.md`](./reference.md).

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
- `vault/**` (except `.gitkeep`) is **gitignored** — local notes only.

## Scope Guardrails

- ALWAYS confirm exact target scope/files and constraints before proposing or applying changes.
- ALWAYS state explicit non-goals (what this skill will **not** change in this run).
- NEVER perform speculative rewrites when a minimal evidence-based change can solve the problem.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Review before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Skill/rule changes in commit | [`/upgrade-ai`](../upgrade-ai/SKILL.md) checklist via scrutinize |

## Change-control

Before commit: respect patch budget and [`approval-gates`](../../ai-rules/risk/approval-gates.mdc) in [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc).

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

Follow [`reference.md`](./reference.md): **Commit gate** → **Remote & identity** → **Push** → **Verify** (verification gate before success claim).

Apply the **push decision matrix** after Phase 1.

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/git-push` |
|---------|-------------|
| STATUS | READY = pushed/synced; BLOCKED = dirty tree / no consent / SSH; IN_PROGRESS = inspecting |
| OBJECTIVE | Safely inspect, commit (if consented), push, verify remote |
| DISCOVERIES | `git status`, ahead/behind, matrix row, remote URL, auth errors |
| ANALYSIS | Path taken, block cause, proposed commit message if dirty |
| RISKS | Secrets in diff, force-push, wrong remote identity, hook failures |
| ARTIFACTS | Branch, remote, commit range pushed, command output snippets |
| NEXT ACTIONS | User phrase to unblock (e.g. ยืนยัน) or exact command |
| HANDOFF | `/scrutinize` before merge · `none` |
| CONFIDENCE | 0–100; no READY without fresh push/status output |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE. Close-out: all sections.

---

# Success Criteria

- Correct branch on intended remote
- Upstream set when needed
- No unintended commits or force pushes
- User gets repo link and clear final status
