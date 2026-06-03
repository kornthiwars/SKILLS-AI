# workday-review — reference

## Evidence mapping

Map git/code signals to plan task IDs:

| Signal | Typical meaning |
|--------|-----------------|
| New file under planned area | Strong progress on that task |
| Modified file + no commit | In progress |
| Commit message references task/topic | Completed or partial — verify diff size |
| Test file added/updated | Strong completion signal for behavior tasks |
| Docs only | Likely DOCS domain complete |
| Changes outside plan scope | Unplanned work |

## Task status rules

| Status | Criteria |
|--------|----------|
| **Completed** | Plan item done + evidence (file/commit/test) cited |
| **In progress** | Partial diff or WIP files; success criteria not fully met |
| **Blocked** | No evidence of progress + known external blocker |
| **Abandoned** | Was in plan, no evidence, no explicit deferral — flag in Carry Over |

## Abandonment detection

- Task was in morning plan (or update vN)
- No matching paths in `git diff --stat` for the day window
- No commit messages referencing the topic
- User did not explicitly defer in `/workday-update`

→ List under **Carry Over** with note "no evidence of work."

## Unplanned work detection

- Commits or diffs with no matching `{DOMAIN}-{n}` ID
- Files changed in areas not listed in plan
- Tag suggestion: `UNPLANNED-{domain}-{n}` for tomorrow's init

## When git is unavailable

1. STATE explicitly: evidence limited to user notes / conversation.
2. Cap CONFIDENCE at ~60.
3. Mark all completion claims `[UNVERIFIED]`.
4. Ask user to run git locally or grant repo access for a follow-up pass.

## Version governance

| Change | Bump |
|--------|------|
| Wording, examples | patch |
| New evidence rule or workflow step | minor |
| Breaking output shape | major |
