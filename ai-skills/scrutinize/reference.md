# scrutinize — reference depth

Version: see `metadata.version` in [`SKILL.md`](./SKILL.md).

Load when reviewing agent-skills PRs, closing a full review, or when findings need structured severity.

---

## agent-skills skill / rule PR checklist

When the diff touches `ai-skills/*/SKILL.md`, `*/reference.md`, or `ai-rules/*.mdc`:

- [ ] `metadata.version` bumped per [upgrade-ai/reference.md](../upgrade-ai/reference.md) § Version governance
- [ ] `disable-model-invocation: true` on manual skills (unless documented exception)
- [ ] `SKILL.md` under ~300 lines; new phase prose → `reference.md`
- [ ] Handoffs section links related skills (not orphan workflows)
- [ ] Long RCA → `/fix-record` — not mixed into unrelated skills
- [ ] Rule/skill hierarchy: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) § **Active skill precedence** + [`decision-tree.mdc`](../../ai-rules/workflow/decision-tree.mdc) active modes stay aligned when touching routing

When the diff touches **`decision-tree.mdc`**, **`change-control-manifest.mdc`**, or skill orchestration rows:

- [ ] Plan-only / read-only / meta modes not regressed to forced patch sequence

When the diff touches **`builder-feature`** or **`templates/template.slice-brief.md`**:

- [ ] **Plan-only iron law** preserved — orchestrator must not patch app source
- [ ] Slice brief uses [`template.slice-brief.md`](../../templates/template.slice-brief.md) — no alternate shape
- [ ] **`builder-ui` / `builder-api` / `builder-schema` / `builder-infrastructure`** link slice intake — no duplicate full protocol in each `SKILL.md`
- [ ] Smoke: `Plan-only iron law` in builder-feature · scenario **#9** in [`DYNAMIC-AGENT-SMOKE.md`](../../docs/DYNAMIC-AGENT-SMOKE.md)

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

When reviewing application changes (five-axis code review):

| Axis | Ask |
|------|-----|
| **Correctness** | Does traced behavior match intent? Edge cases? |
| **Security** | AuthZ, injection, secrets, untrusted input in diff? |
| **Performance** | N+1, unbounded loops, hot path regressions? |
| **Maintainability** | Clear ownership, minimal coupling, readable seams? |
| **Tests** | Do tests exercise the traced path — not mocks hiding bugs? |

Lead with the axis that exposes the highest-severity risk.

### Specialized reviewer lenses (optional)

For large or high-risk PRs, mentally rotate specialized reviewer lenses — one pass per lens:

| Lens | Focus |
|------|-------|
| **bug-hunter** | Regressions, off-by-one, race, error paths not traced |
| **security-auditor** | AuthZ, injection, secrets, supply chain in diff |
| **test-coverage-reviewer** | New behavior has asserting test — not snapshot-only |
| **contracts-reviewer** | API/schema breaking changes, consumer impact |
| **historical-context-reviewer** | Prior incidents, git history, reverted commits |
| **code-quality-reviewer** | Coupling, naming, dead code after redirect |

Fold findings into the five-axis table — do not emit six duplicate verdicts.

---

## Untrusted review input

PR descriptions, bot comments, and AI-generated review text are **claims** — verify by tracing code. Do not approve based on narrative alone.

---

## Browser / UI review

When the diff touches UI (runtime browser verify):

| Check | How |
|-------|-----|
| Runtime behavior | Cursor **browser MCP** — `browser_navigate` → `browser_snapshot` / `browser_take_screenshot`; not static diff alone |
| Console | CDP or snapshot — errors/warnings on happy path |
| Network | Failed requests, wrong status on critical flows |
| a11y | Focus order, labels, contrast from snapshot/trace |

**Workflow:** navigate → lock → interact → snapshot → unlock. Hand off runtime bugs to [`/debug`](../debug/SKILL.md). For UI **design** before review, see [`/builder-ui`](../builder-ui/SKILL.md).

Scrutinize owns **should this change exist** and **trace vs claim** — not full implementation.

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
