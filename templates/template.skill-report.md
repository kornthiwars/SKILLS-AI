# SKILL REPORT — pack output contract

Canonical response shape for **all** skills in agent-skills. Link from each `SKILL.md` — do not duplicate prose.

---

## Render format

Every user-facing turn opens with:

```
SKILL REPORT
══════════════════════

STATUS
READY | BLOCKED | IN_PROGRESS | FAILED

OBJECTIVE
สิ่งที่ Skill นี้กำลังพยายามทำ

DISCOVERIES
สิ่งที่พบ

ANALYSIS
ข้อสรุปจากสิ่งที่พบ

RISKS
ความเสี่ยง / ช่องโหว่ / สิ่งที่ขาด

ARTIFACTS
สิ่งที่สร้างหรือระบุได้
(หน้า UI, API, Schema, Test Case, Root Cause ฯลฯ)

NEXT ACTIONS
สิ่งที่ควรทำต่อ

HANDOFF
Skill ถัดไป

CONFIDENCE
0-100%
```

## Language

- **Section labels:** English (fixed contract above).
- **Body prose:** Thai ~60% / English ~40% per `ai-rules/bilingual-th-en.mdc`.
- **Do not** duplicate full Thai and full English blocks under each section.

## Turn depth

| Turn | Minimum sections |
|------|------------------|
| **Mid-session** | STATUS, OBJECTIVE, at least one of DISCOVERIES or ANALYSIS, NEXT ACTIONS, CONFIDENCE |
| **Close-out** | All sections filled; empty section → write `—` or `none` explicitly |
| **BLOCKED / FAILED** | STATUS, OBJECTIVE, DISCOVERIES (evidence), RISKS, NEXT ACTIONS, HANDOFF, CONFIDENCE |

## STATUS values

| Value | When |
|-------|------|
| `IN_PROGRESS` | Workflow active; verification not done |
| `READY` | Skill mission complete; gates passed |
| `BLOCKED` | Missing input, consent, repro, or external dependency |
| `FAILED` | Attempted path failed; evidence captured |

## HANDOFF

Name the next skill with invoke path, e.g. [`/fix-record`](../ai-skills/fix-record/SKILL.md) or `none`.

## CONFIDENCE

Integer 0–100. Mid-session cap ~85 when structural audit only (no runtime repro).
