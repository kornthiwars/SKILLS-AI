---
name: git-push
metadata:
  version: "1.0.0"
description: >-
  Safely inspect, commit (only when explicitly requested), and push to GitHub.
  Use for push/publish/sync, failed pushes, or init→remote workflows. Handles
  dirty trees, confirm-after-block, SSH identity, and multi-account remotes.
disable-model-invocation: true
---

# Skill: git-push

Role: Release operator

Mission: Inspect repo state, use the correct remote identity, push once, verify.

## Purpose

Push local git work to a remote (typically GitHub) **safely and predictably**.

This skill does NOT:
- commit without explicit user request
- change `git config`
- force-push to `main`/`master` without explicit user request
- skip hooks (`--no-verify`) unless the user explicitly asks
- amend commits unless all amend safety conditions are met

---

# Core Principles

- **Commit only on request** — `/git-push` alone is not permission to commit
- **Read before write** — inspect status, diff, branch, remote first
- **Decision before action** — use the push decision matrix below
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

# Push Decision Matrix

After Phase 1 inspect, choose **one** path:

| Ahead of origin | Working tree | Action |
|-----------------|--------------|--------|
| 0 | clean | Report already up to date; done |
| >0 | clean | Phase 3 → 4 → 5 (push only) |
| 0 | dirty | **Blocked** — offer commit; wait for explicit commit consent |
| >0 | dirty | **Blocked** — ask: push existing commits only, or commit first then push |
| 0 | staged only | **Blocked** — need `git commit` consent before push |

Never push uncommitted work. Never assume "confirm" means commit unless intent is explicit (see Commit Gate).

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

Also derive:
- commits ahead: `git rev-list --count @{u}..HEAD 2>/dev/null` or from `git status`
- whether remote exists and URL scheme (HTTPS vs SSH)

---

## Phase 2 — Commit Gate

### Explicit commit consent (any of these)

- User asked to commit (commit, commit and push, สร้าง commit)
- User confirmed after blocked push with clear intent: **ยืนยัน**, **confirm**, **yes commit and push**, **commit แล้ว push**
- User listed files/message to include in the commit

### NOT sufficient alone

- `/git-push` only
- vague "ok" without commit context after a dirty-tree block

### When committing

1. Never commit secrets (`.env`, credentials, `*.pem`, `id_*` private keys, tokens)
2. If expected files are untracked, run `git check-ignore -v <path>` — fix `.gitignore` if wrongly ignored
3. Draft a 1–2 sentence message focused on **why**
4. Use HEREDOC:

```bash
git add <paths>
git commit -m "$(cat <<'EOF'
Your message here.

EOF
)"
```

5. Hook modified files after commit → fix and **new** commit (no careless amend)

### When blocked (dirty, ahead = 0)

1. Summarize changed/untracked paths
2. Propose a commit message draft
3. Ask user to confirm commit (and then push)
4. Do not run `git commit` until consent

---

## Phase 3 — Remote & Identity

### SSH remotes (`git@...`)

Before push, verify account matches repo owner when push failed before OR alias remote is used:

```bash
# Default host
ssh -T git@github.com 2>&1 || true
# If remote uses Host alias (e.g. git@github.com-kornthiwars:owner/repo.git)
ssh -T git@github.com-<alias> 2>&1 || true
```

`Hi <user>!` must be an account with push access to that repository.

| Account setup | Remote URL pattern |
|---------------|-------------------|
| Default | `git@github.com:OWNER/REPO.git` |
| Multi-account SSH alias | `git@github.com-ALIAS:OWNER/REPO.git` |

Fix wrong account: `git remote set-url origin <correct-url>` — do not reuse a pubkey already on another GitHub account; generate a new key per account.

### Remote missing

```bash
git remote add origin <url>
```

---

## Phase 4 — Push

```bash
# First push / no upstream
git push -u origin <branch>

# Tracked branch
git push
```

- `git branch -M main` only if user wants `main` and branch name differs
- Remote has unrelated history → stop; no force-push without explicit user request

---

## Phase 5 — Verify

```bash
git status
git log origin/<branch> -1 --oneline
```

Confirm tracking, success, and repo URL (`https://github.com/OWNER/REPO` when derivable from remote).

---

# Safety Rules

| Action | Rule |
|--------|------|
| `git push --force` | Never on `main`/`master` unless user explicitly asks; warn about impact |
| `git commit --amend` | Only if user requested amend OR hook auto-fixed files AND HEAD is unpushed |
| `git config` | Never modify |
| Hooks | Never bypass unless user explicitly asks |
| Empty commit | Never if nothing to commit |

---

# Common Failures

| Error | Likely cause | Fix |
|-------|--------------|-----|
| `could not read Username` | HTTPS without credentials | SSH, PAT, or `gh auth login` |
| `Permission denied (publickey)` | No/wrong SSH key | Add key; check `~/.ssh/config` |
| `denied to USER` | Wrong GitHub account | Fix Host alias / `set-url` |
| `Key is already in use` | Pubkey on two accounts | New key for second account |
| `failed to push some refs` | Remote ahead | `git pull --rebase` then push (ask if unclear) |
| `repository not found` | Repo missing / no access | Create repo or fix URL |
| Push "succeeds" but files missing on GitHub | Never committed | Re-run matrix; commit first |

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
