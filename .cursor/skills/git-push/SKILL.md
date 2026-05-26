---
name: git-push
description: >-
  Safely stage, commit (only when explicitly requested), and push to GitHub.
  Use when the user asks to push, publish a branch, sync with origin, or run
  git init/remote/push workflows. Handles SSH account mismatches and pre-push checks.
disable-model-invocation: true
---

# Skill: git-push

## Purpose

Push local git work to a remote (typically GitHub) **safely and predictably**.

This skill does NOT:
- commit without explicit user request
- change `git config`
- force-push to `main`/`master` without explicit user request
- skip hooks (`--no-verify`) unless the user explicitly asks
- amend commits unless all amend safety conditions are met

---

# Primary Role

Role: Release operator

Mission: Verify repo state, use the correct remote identity, push once, confirm success.

---

# Activate When

- User asks to push, publish, or sync to GitHub
- User runs init → add → commit → push sequences
- Push failed (auth, permission denied, wrong account, no upstream)
- User wants a new repo on GitHub wired up

---

# Core Principles

- **Commit only on request** — staging/pushing ≠ permission to commit
- **Read before write** — always inspect status, diff, and branch first
- **Minimal commands** — no destructive git unless explicitly requested
- **Correct identity** — SSH must map to the account that owns the remote repo
- **Verify after push** — confirm remote branch and tracking

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

Determine:
- clean vs dirty working tree
- staged vs unstaged changes
- current branch and upstream
- whether commits exist that are not on remote

---

## Phase 2 — Commit Gate

**If the user did not explicitly ask to commit:**

- Do NOT run `git commit`
- If there are uncommitted changes needed for push, stop and ask what to commit

**If the user asked to commit:**

1. Never commit secrets (`.env`, credentials, keys, tokens)
2. Draft a 1–2 sentence message focused on **why**
3. Use HEREDOC for the message:

```bash
git add <paths>
git commit -m "$(cat <<'EOF'
Your message here.

EOF
)"
```

4. If commit fails due to a hook that modified files, fix and make a **new** commit (do not amend unless amend rules are satisfied)

---

## Phase 3 — Remote & Identity

### Remote missing

```bash
git remote add origin <url>
```

Prefer SSH when the user uses SSH keys. Example patterns:

| Account setup | Remote URL pattern |
|---------------|-------------------|
| Default `github.com` host | `git@github.com:OWNER/REPO.git` |
| Multi-account SSH alias | `git@github.com-ALIAS:OWNER/REPO.git` |

### Wrong GitHub account on push

Symptoms: `Permission denied`, `denied to <other-user>`

1. Test identity:
   ```bash
   ssh -T git@github.com
   ssh -T git@github.com-<alias>   # if using ~/.ssh/config Host alias
   ```
2. Fix: use the SSH key / Host alias for the account that owns the repo
3. Update remote: `git remote set-url origin <correct-url>`

Do not reuse a public key already registered on another GitHub account — generate a new key for the second account.

---

## Phase 4 — Push

### First push (no upstream)

```bash
git branch -M main   # only if user wants main and branch differs
git push -u origin <branch>
```

### Subsequent pushes

```bash
git push
```

### If remote has unrelated history

Stop. Do not force-push unless the user explicitly requests it. Explain options (pull/rebase, merge, or force with consent).

---

## Phase 5 — Verify

```bash
git status
git log origin/<branch> -1 --oneline
```

Confirm:
- branch tracks `origin/<branch>`
- push reported success
- provide repo URL if known (`https://github.com/OWNER/REPO`)

---

# GitHub CLI (optional)

If `gh` is available and user needs PR/issue work:

```bash
gh auth status
gh pr create ...
```

Use `gh` for GitHub tasks; use `git` for local repo operations.

---

# Safety Rules

| Action | Rule |
|--------|------|
| `git push --force` | Never on `main`/`master` unless user explicitly asks; warn about impact |
| `git commit --amend` | Only if user requested amend OR hook auto-fixed files AND HEAD commit is yours unpushed |
| `git config` | Never modify |
| Hooks | Never bypass unless user explicitly asks |
| Empty commit | Never if nothing to commit |

---

# Output Format

## Push Summary

- **Branch:**
- **Remote:**
- **Commits pushed:** (range or count)
- **Result:** success / blocked

## Pre-push State

- Uncommitted changes: yes/no
- Commits ahead of origin: N

## If Blocked

- **Cause:**
- **Evidence:** (command output snippet)
- **Recommended fix:** (concrete next command or user action)

---

# Common Failures

| Error | Likely cause | Fix |
|-------|--------------|-----|
| `could not read Username` | HTTPS without credentials | Use SSH, PAT, or `gh auth login` |
| `Permission denied (publickey)` | No SSH key or wrong key | Add key to GitHub; check `~/.ssh/config` |
| `denied to USER` | Wrong GitHub account for repo | Switch SSH Host / key or add collaborator |
| `Key is already in use` | Same pubkey on two accounts | New key for second account |
| `failed to push some refs` | Remote ahead | `git pull --rebase` then push (ask user if unclear) |
| `repository not found` | Repo missing or no access | Create repo on GitHub or fix remote URL |

---

# Success Criteria

- Correct branch pushed to intended remote
- Upstream tracking set when needed
- No unintended commits or force pushes
- User receives repo link and clear status
