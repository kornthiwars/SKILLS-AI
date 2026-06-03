# workday-review — reference

WORKDAY shape: [`templates/template.workday.md`](../../templates/template.workday.md).

## Evidence mapping

Map git/code signals to `{DOMAIN}-{NNN}` task IDs:

| Signal | Maps to |
|--------|---------|
| New file under planned area | **PROGRESS** `✓ {ID}` + **EVIDENCE** files |
| Modified file, no commit | **ACTIVE TASKS** `[~]` + **EVIDENCE** files |
| Commit message / diff matches task | **PROGRESS** + **EVIDENCE** commit SHA |
| Test file added/updated | **EVIDENCE** tests |
| Docs only | **EVIDENCE** docs · often `DOCS-{NNN}` |
| Changes outside plan | **DISCOVERED TODAY** `+ UNPLANNED-…` |

## Task status → WORKDAY fields

| Status | ACTIVE TASKS | PROGRESS | EVIDENCE |
|--------|--------------|----------|----------|
| **Completed** | `[x]` | `✓ {ID} title` | required |
| **In progress** | `[~]` | optional partial note | partial paths OK |
| **Not started** | `[ ]` | — | — |
| **Blocked** | `[ ]` + title note | — | — ; detail in **PROBLEMS** |
| **Unverified claim** | `[~]` or `[ ]` | `✓ … [UNVERIFIED]` | missing or weak |

## Abandonment detection

- Task in **ACTIVE TASKS** from init/update
- No matching paths in `git diff --stat` for the day window
- No commit referencing the topic
- User did not defer in **PROBLEMS**

→ keep `[ ]`; add **NEXT** carry-over `→` line.

## Unplanned work

- Commits/diffs with no `{DOMAIN}-{NNN}` match
- Add **DISCOVERED TODAY**: `+ UNPLANNED-{DOMAIN}-{NNN} title — evidence: {SHA or paths}`

## DAY SCORE rubric

| Field | Strong / High | Partial / Medium | Weak / Low / None |
|-------|---------------|------------------|-------------------|
| **Focus** | ≤3 active priorities worked | split across many tasks | context-switching, no depth |
| **Progress** | most planned tasks `[x]` with evidence | mix `[x]` and `[~]` | few/no verified completions |
| **Risk** | clean tree, blockers resolved | dirty tree or open blockers | uncommitted critical work, false completes |

## When git is unavailable

1. STATE in **PROBLEMS**: evidence limited.
2. All **PROGRESS** lines get `[UNVERIFIED]`.
3. **EVIDENCE**: `—` with note in **PROBLEMS**.
4. Cap CONFIDENCE at ~60.

## Version governance

| Change | Bump |
|--------|------|
| Wording, examples | patch |
| New evidence rule or WORKDAY field | minor |
| Breaking template shape | major — coordinate `template.workday.md` |
