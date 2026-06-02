# git-push — reference

Load for **matrix**, **commit gate detail**, **SSH identity**, **push/verify**, and **common failures**. Start with **Phase 0–1** in [`SKILL.md`](./SKILL.md).

---

## Push decision matrix

| Ahead of origin | Working tree | Action |
|-----------------|--------------|--------|
| 0 | clean | Report already up to date; done |
| >0 | clean | Phase 3 → 4 → 5 (push only) |
| 0 | dirty | **Blocked** — offer commit; wait for explicit commit consent |
| >0 | dirty | **Blocked** — ask: push existing commits only, or commit first then push |
| 0 | staged only | **Blocked** — need `git commit` consent before push |

Never push uncommitted work. Never assume "confirm" means commit unless intent is explicit.

---

## Multi-project workspace

When the Cursor workspace contains **more than one git root** (sibling folders, each with its own `.git`):

1. **Phase 1** — `cd` into the repo the user named (or infer from open files / prior task in the same thread).
2. State the **repository directory name** in Pre-push State and Push Summary — not “the workspace”.
3. Do not run `git status` only at a non-repo parent path unless that parent is itself the intended repo.
4. One `/git-push` turn = **one repo** unless the user explicitly lists several.

---

## Phase 2 — Commit gate

### Explicit commit consent

- User asked to commit (commit, commit and push, สร้าง commit)
- User confirmed after blocked push: **ยืนยัน**, **confirm**, **yes commit and push**, **commit แล้ว push**
- User listed files/message to include

### NOT sufficient alone

- `/git-push` only
- vague "ok" without commit context after dirty-tree block

### When committing

0. **Phase 1 env check** — after `git status` / `git diff`, run `git diff --name-only` and `git diff --staged --name-only`. If any path matches `.env`, `.env.*`, `credentials`, `*.pem`, or `*secret*` → list in **If Blocked** / Pre-push State and recommend `git restore <path>` or omit from `git add` unless the user explicitly includes them.
1. Never commit secrets (`.env`, credentials, `*.pem`, private keys, tokens)
2. Untracked expected files → `git check-ignore -v <path>`
3. Draft 1–2 sentence message focused on **why**
4. HEREDOC commit (see `SKILL.md` Phase 1 inspect)
5. Hook modified files after commit → fix and **new** commit (no careless amend)

### When blocked (dirty, ahead = 0)

1. Summarize changed/untracked paths
2. Propose commit message draft
3. Ask user to confirm commit (and then push)
4. Do not run `git commit` until consent

---

## Phase 3 — Remote & identity

### SSH remotes (`git@...`)

```bash
ssh -T git@github.com 2>&1 || true
ssh -T git@github.com-<alias> 2>&1 || true
```

`Hi <user>!` must have push access to the repository.

| Account setup | Remote URL pattern |
|---------------|-------------------|
| Default | `git@github.com:OWNER/REPO.git` |
| Multi-account SSH alias | `git@github.com-ALIAS:OWNER/REPO.git` |

Wrong account: `git remote set-url origin <correct-url>` — new key per GitHub account if pubkey collision.

### Remote missing

```bash
git remote add origin <url>
```

---

## Phase 4 — Push

```bash
git push -u origin <branch>   # no upstream
git push                      # tracked
```

- `git branch -M main` only if user wants `main`
- Unrelated remote history → stop; no force-push without explicit request

---

## Phase 5 — Verify

```bash
git status
git log origin/<branch> -1 --oneline
```

### Verification gate (before "push succeeded")

| Step | Action |
|------|--------|
| 1 | `git status` — clean or expected dirty only |
| 2 | `git log origin/<branch> -1` — HEAD matches pushed commit |
| 3 | If user expected files on remote — confirm they were **committed** before push |

No "push succeeded" claim without fresh command output in this session ([superpowers verification-before-completion](https://github.com/obra/superpowers) pattern).

---

## Pre-commit checklist (agent-skills repo)

Before `git commit` on this library:

| # | Check |
|---|--------|
| 1 | `./scripts/change-control-check.sh` PASS or documented `[BUDGET-OVERRIDE]` |
| 2 | Only canonical paths: `ai-skills/`, `ai-rules/`, `scripts/`, `templates/`, `docs/` |
| 3 | Each touched skill: `metadata.version` bumped |
| 4 | No secrets in diff (`.env`, keys, tokens) |
| 5 | Optional: `./scripts/smoke-skills.sh` when skill/rules content changed |

---

## Safety rules

| Action | Rule |
|--------|------|
| `git push --force` | Never on `main`/`master` unless user explicitly asks; warn |
| `git commit --amend` | Only if user requested OR hook fixed files AND HEAD unpushed |
| `git config` | Never modify |
| Hooks | Never bypass unless user explicitly asks |
| Empty commit | Never if nothing to commit |

---

## Common failures

| Error | Likely cause | Fix |
|-------|--------------|-----|
| `could not read Username` | HTTPS without credentials | SSH, PAT, or `gh auth login` |
| `Permission denied (publickey)` | No/wrong SSH key | Add key; check `~/.ssh/config` |
| `denied to USER` | Wrong GitHub account | Fix Host alias / `set-url` |
| `Key is already in use` | Pubkey on two accounts | New key for second account |
| `failed to push some refs` | Remote ahead | `git pull --rebase` then push (ask if unclear) |
| `repository not found` | Repo missing / no access | Create repo or fix URL |
| Push "succeeds" but files missing on GitHub | Never committed | Re-run matrix; commit first |
