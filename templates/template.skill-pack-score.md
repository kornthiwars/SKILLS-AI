---
audit_date: {{YYYY-MM-DD}}
scope: agent-skills pack
baseline_label: "before audit"
current_label: "after audit"
auditor: ""
related_upgrade: ""
tags: [skill-pack, audit, upgrade-ai]
---

# Skill pack score — {{YYYY-MM-DD}}

<!-- Use after /upgrade-ai meta audit or pack-wide skill review -->
<!-- Copy to vault/learnings/ if reusable · or docs/ internal note · not daily issues format -->
<!-- Bar scale: 20 chars = 10.0 · filled █ · empty ░ · 2 blocks per point -->

## Summary

| | Score |
|---|:---:|
| **Pack overall (excl. debug)** | /10 |
| **Pack overall (all 12 skills)** | /10 |
| **Δ vs baseline** | + |

One-line takeaway:

## Score table

| Skill | Invoke | Before | After | Δ | Notes |
|-------|--------|:------:|:-----:|:---:|-------|
| debug | `/debug` | | | | |
| upgrade-ai | `/upgrade-ai` | | | | |
| git-push | `/git-push` | | | | |
| scrutinize | `/scrutinize` | | | | |
| fix-record | `/fix-record` | | | | |
| sql | `/sql` | | | | |
| builder-feature | `/builder-feature` | | | | |
| vault-recall | `/vault-recall` | | | | |
| builder-ui | `/builder-ui` | | | | |
| builder-api | `/builder-api` | | | | |
| builder-schema | `/builder-schema` | | | | |
| builder-infrastructure | `/builder-infrastructure` | | | | |

**Builder group (optional row):** average builder-ui/api/schema/infra = /10

## Bar chart (after scores)

Sort descending by **After**. Target pack average ≥ **9.0**.

```
debug        ████████████████████  9.0
upgrade-ai   ████████████████████  9.0
git-push     ████████████████████  9.0
scrutinize   ████████████████████  9.0
fix-record   ████████████████████  9.0
sql          ████████████████████  9.0
builder-feat ████████████████████  9.0
vault-recall ████████████████████  9.0
builder-*    ████████████████████  9.0  (ui/api/schema/infra mean)
```

### Bar rules

| Rule | Detail |
|------|--------|
| Width | 20 characters fixed |
| Filled | `█` — `round(after × 2)` blocks |
| Empty | `░` — remainder to 20 |
| Label | skill short name, pad to 12 chars |
| Score | `after` one decimal, right-aligned in chart line |
| Δ note | optional `← … (+Δ)` on highlight rows only |
| Group | `builder-*` = mean of ui, api, schema, infra |

**Example (score 8.3):** `round(8.3 × 2) = 17` → `█████████████████░░░`

## Dimension scores (optional)

| Dimension | Before | After | Δ |
|-----------|:------:|:-----:|:---:|
| Debug discipline | | | |
| Verification / evidence gates | | | |
| Cross-skill handoffs | | | |
| Token / reference depth | | | |
| Security (untrusted input) | | | |
| External repo parity | | | |

## Top gains / gaps

### Improved most

1.
2.
3.

### Still below 8.0

| Skill | Score | Blocker |
|-------|:-----:|---------|
| | | |

## Next actions

- [ ]
- [ ]

## References

- Versions: `docs/th/APPENDIX-TH.md` §1 or each `ai-skills/*/SKILL.md` frontmatter
- Upgrade workflow: `ai-skills/upgrade-ai/SKILL.md`
- Smoke: `scripts/smoke-skills.sh`
