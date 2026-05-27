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

## Phase 2 — Commit gate

### Explicit commit consent

- User asked to commit (commit, commit and push, สร้าง commit)
- User confirmed after blocked push: **ยืนยัน**, **confirm**, **yes commit and push**, **commit แล้ว push**
- User listed files/message to include

### NOT sufficient alone

- `/git-push` only
- vague "ok" without commit context after dirty-tree block

### When committing

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
