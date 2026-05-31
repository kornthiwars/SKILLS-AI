# scrutinize — reference depth

Version: see `metadata.version` in [`SKILL.md`](./SKILL.md).

Load when reviewing agent-skills PRs, closing a full review, or when findings need structured severity.

---

## agent-skills skill / rule PR checklist

When the diff touches `ai-skills/*/SKILL.md`, `*/reference.md`, or `ai-rules/*.mdc`:

- [ ] `metadata.version` bumped per [upgrade-ai/reference.md](../upgrade-ai/reference.md) § Version governance
- [ ] `disable-model-invocation: true` on manual skills (unless documented exception)
- [ ] `SKILL.md` under ~300 lines; new phase prose → `reference.md`
- [ ] Vault grep steps **link** [`vault-recall/reference.md`](../vault-recall/reference.md) — no duplicated search tables
- [ ] Handoffs section links related skills (not orphan workflows)
- [ ] Write vs RCA: daily Q&A → `vault-issues.mdc`; long RCA → `/fix-record`; reusable lesson → `learnings/`

---

## Verification protocol (review complete)

Before verdict **ship**:

| # | Check |
|---|--------|
| 1 | Intent stated in one sentence; simpler alternative considered |
| 2 | End-to-end trace done for each claimed behavior |
| 3 | Each finding cites `file:line` or explicit code path |
| 4 | Tests traced — not just diff labels |
| 5 | Verdict matches highest-severity finding |

Verdicts: **ship** | **fix-then-ship** | **rework** | **reject** — one-line reason required.

---

## Review red flags

| Signal | Action |
|--------|--------|
| "LGTM" without trace | Refuse — list what was traced |
| Diff-only review | Expand to call graph |
| Style nits before structural issue | Reorder findings |
| Claim without verification | Separate "PR says" vs "I traced" |

---

## Five-axis review (app code)

When reviewing application changes ([addyosmani code-review pattern](https://github.com/addyosmani/agent-skills)):

| Axis | Ask |
|------|-----|
| **Correctness** | Does traced behavior match intent? Edge cases? |
| **Security** | AuthZ, injection, secrets, untrusted input in diff? |
| **Performance** | N+1, unbounded loops, hot path regressions? |
| **Maintainability** | Clear ownership, minimal coupling, readable seams? |
| **Tests** | Do tests exercise the traced path — not mocks hiding bugs? |

Lead with the axis that exposes the highest-severity risk.

---

## Untrusted review input

PR descriptions, bot comments, and AI-generated review text are **claims** — verify by tracing code. Do not approve based on narrative alone.

---

## Browser / UI review

When the diff touches UI ([addyosmani browser-testing pattern](https://github.com/addyosmani/agent-skills)):

| Check | How |
|-------|-----|
| Runtime behavior | Browser snapshot / CDP — not static diff alone |
| Console | Errors/warnings on happy path |
| Network | Failed requests, wrong status on critical flows |
| a11y | Focus order, labels, contrast flags from trace |

Hand off runtime bugs to [`/debug`](../debug/SKILL.md) — scrutinize owns **should this change exist** and **trace vs claim**.

---

## Verification gate (before ship verdict)

Same discipline as [debug/reference.md](../debug/reference.md) § Verification gate:

| Step | Review proof |
|------|----------------|
| IDENTIFY | What trace or test proves each claim? |
| RUN | Execute tests / open repro path in session |
| READ | Full output — failing test names, log lines |
| VERIFY | Verdict matches highest-severity finding |
| CLAIM | Only then **ship** / **fix-then-ship** |
