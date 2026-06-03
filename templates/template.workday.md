# WORKDAY — pack output contract

Canonical daily plan shape for **`/workday-init`**, **`/workday-update`**, **`/workday-review`**.

Link from each workday `SKILL.md` — do not duplicate prose.

---

## Render format

Every workday close-out emits this block **verbatim** (fill placeholders; use `—` when a section is empty):

```
WORKDAY
══════════════════════

DATE
{{YYYY-MM-DD}}

MISSION
{{one-line goal of the day}}

──────────────────────

ACTIVE TASKS

[ ] API-001 {{title}}
[ ] WEB-001 {{title}}
[ ] SKILL-001 {{title}}

──────────────────────

PROGRESS

✓ {{completed item — task ID + title}}

──────────────────────

PROBLEMS

• {{blocker, risk, or ambiguity}}

──────────────────────

DISCOVERED TODAY

+ {{new work found during the day — source + reason}}

──────────────────────

NEXT

→ {{immediate next action — task ID optional}}
→ {{second action}}
→ {{third action}}

──────────────────────

EVIDENCE

- commit: {{SHA or —}}
- files: {{paths or —}}
- tests: {{paths or —}}
- docs: {{paths or —}}

──────────────────────

DAY SCORE

Focus: {{High | Medium | Low}} — {{one line}}
Progress: {{Strong | Partial | Weak | None}} — {{one line}}
Risk: {{Low | Medium | High}} — {{one line}}
```

---

## Task ID convention

`{DOMAIN}-{NNN}` — three-digit zero-padded sequence **per domain per day**.

| Domain | Prefix | Examples |
|--------|--------|----------|
| API | `API-` | `API-001`, `API-002` |
| WEB | `WEB-` | `WEB-001` |
| SKILL | `SKILL-` | `SKILL-001` |
| DOCS | `DOCS-` | `DOCS-001` |
| OPS | `OPS-` | `OPS-001` |
| Misc | `MISC-` | only when uncategorizable |

Tags inline after title when needed: `[AMBIGUOUS]`, `[BLOCKED]`, `[UNVERIFIED]`.

Checkbox states in **ACTIVE TASKS**:

| Mark | Meaning |
|------|---------|
| `[ ]` | Not started or in progress |
| `[x]` | Done — must also appear under **PROGRESS** with `✓` |
| `[~]` | In progress — partial evidence exists |

---

## Section ownership by skill

| Section | init | update | review |
|---------|:----:|:------:|:------:|
| DATE | fill | preserve | preserve |
| MISSION | fill | preserve or refine | preserve |
| ACTIVE TASKS | fill all `[ ]` | add/merge; dedupe | update `[x]`/`[~]`/`[ ]` |
| PROGRESS | `—` | add if user reports partial | fill from git/code evidence |
| PROBLEMS | risks + ambiguities | append blockers | final blockers |
| DISCOVERED TODAY | `—` | append `+` lines | preserve + unplanned |
| NEXT | execution order | re-prioritize | tomorrow carry-over |
| EVIDENCE | all `—` | optional partial | **required** from git/code |
| DAY SCORE | planned Focus/Risk | optional refresh | evidence-based all three |

---

## Rules (all workday skills)

- Preserve user intent — do not drop goals without flagging in **PROBLEMS**.
- Never estimate completion time without evidence.
- **init / update:** no code implementation.
- **review:** never mark **PROGRESS** or `[x]` from conversation alone — cite **EVIDENCE**.
- Empty section → single line `—` (not blank).

---

## Persistence (mandatory)

Every close-out **writes a vault file** and shows the WORKDAY block in chat.

| Path | Role |
|------|------|
| `vault/workday/YYYY-MM-DD.md` | Canonical daily plan (one file; updated in place) |

Write protocol: [workday-init/reference.md](../ai-skills/workday-init/reference.md) § Persistence · file wrapper: [`template.workday-file.md`](./template.workday-file.md).
