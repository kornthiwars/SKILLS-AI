# workday-update — reference

WORKDAY block shape: [`templates/template.workday.md`](../../templates/template.workday.md).

**Persistence** (write path, `plan_version`, load protocol): [`workday-init/reference.md`](../workday-init/reference.md) § Persistence · § Load protocol — do not duplicate here.

This file holds **update-specific** rules and close-out verification only.

---

## Update-specific protocol

| Rule | Detail |
|------|--------|
| Base plan | Load `vault/workday/YYYY-MM-DD.md` first — hand off to `/workday-init` if missing |
| Dedupe | Relate to existing `{DOMAIN}-{NNN}` before minting ID; note `duplicate of API-001` in **DISCOVERED TODAY** |
| Discovery lines | Every new item: `+ {DOMAIN}-{NNN} title — source: … — reason: …` |
| Meta line | `+ plan v{N} — {reason for this update}` |
| Progress | User-reported `✓` only — mark `[UNVERIFIED]` until `/workday-review` |
| Preserve | Do not drop **PROGRESS** / `[x]` without explicit user request |
| Non-goals | Do **not** write WORKDAY content to `vault/issues/` — use `vault/workday/` only; session Q&A may still log per [`vault-issues.mdc`](../../ai-rules/vault-issues.mdc); no app code commits |

Section ownership vs init/review: [`templates/template.workday.md`](../../templates/template.workday.md).

---

## Close-out verification gate

Before STATUS=READY ([verification-before-completion](https://github.com/obra/superpowers) pattern):

| Step | Proof |
|------|-------|
| 1 IDENTIFY | Target date file `vault/workday/YYYY-MM-DD.md` |
| 2 RUN | Read file after write — full WORKDAY block present |
| 3 READ | `plan_version` incremented; `skill: workday-update` in frontmatter if using template wrapper |
| 4 VERIFY | Every discovery has `+` line; no duplicate IDs for same work; **NEXT** re-prioritized |
| 5 CLAIM | Emit full WORKDAY in chat + report path |

Forbidden without step 2–3: "plan updated" without path or block in session.
