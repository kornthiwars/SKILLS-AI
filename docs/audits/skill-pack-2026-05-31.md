---
audit_date: 2026-05-31
scope: agent-skills pack
baseline_label: "pre-upgrade (~7.3 avg)"
current_label: "post-upgrade working tree"
auditor: upgrade-ai /upgrade meta audit
related_upgrade: pack-wide 9.0 rubric push
tags: [skill-pack, audit, upgrade-ai]
---

# Skill pack score — 2026-05-31

## Summary

| | Score |
|---|:---:|
| **Pack overall (excl. debug)** | 8.9/10 |
| **Pack overall (all 12 skills)** | 8.9/10 |
| **Δ vs baseline** | +1.6 |

One-line takeaway: All skills now have cheat sheets, handoffs, and verification gates; vault corpus remains empty (runtime recall unproven).

## Score table

| Skill | Invoke | Before | After | Δ | Notes |
|-------|--------|:------:|:-----:|:---:|-------|
| debug | `/debug` | 7.5 | 9.2 | +1.7 | reference.md 332 lines; stop-the-line, Prove-It |
| upgrade-ai | `/upgrade-ai` | 7.0 | 9.0 | +2.0 | cheat sheet + handoffs + close-out gate (v1.2.0) |
| git-push | `/git-push` | 7.5 | 9.0 | +1.5 | matrix, pre-commit checklist, push verify gate |
| scrutinize | `/scrutinize` | 7.0 | 9.0 | +2.0 | new reference.md; agent-skills PR checklist |
| fix-record | `/fix-record` | 6.5 | 9.0 | +2.5 | decomposed to reference.md + Prove-It |
| sql | `/sql` | 7.5 | 8.8 | +1.3 | execution verification; less external parity than debug |
| builder-feature | `/builder-feature` | 7.5 | 9.0 | +1.5 | vertical slices + close-out gate |
| vault-recall | `/vault-recall` | 7.0 | 8.5 | +1.5 | struct OK; learnings/ empty — runtime recall unproven |
| builder-ui | `/builder-ui` | 7.5 | 8.9 | +1.4 | close-out gate in reference |
| builder-api | `/builder-api` | 7.5 | 8.9 | +1.4 | close-out gate in reference |
| builder-schema | `/builder-schema` | 7.5 | 8.9 | +1.4 | close-out gate in reference |
| builder-infrastructure | `/builder-infrastructure` | 7.5 | 8.9 | +1.4 | close-out gate in reference |

**Builder group (optional row):** average builder-ui/api/schema/infra = **8.9/10**

## Bar chart (after scores)

Sort descending by **After**. Target pack average ≥ **9.0**.

```
debug        ██████████████████░░  9.2
scrutinize   ██████████████████░░  9.0
fix-record   ██████████████████░░  9.0
git-push     ██████████████████░░  9.0
builder-feat ██████████████████░░  9.0
upgrade-ai   ██████████████████░░  9.0
builder-*    █████████████████░░░  8.9
sql          █████████████████░░░  8.8
vault-recall █████████████████░░░  8.5
```

## Dimension scores (optional)

| Dimension | Before | After | Δ |
|-----------|:------:|:-----:|:---:|
| Debug discipline | 6.5 | 9.2 | +2.7 |
| Verification / evidence gates | 6.0 | 9.0 | +3.0 |
| Cross-skill handoffs | 5.5 | 9.0 | +3.5 |
| Token / reference depth | 6.5 | 8.8 | +2.3 |
| Security (untrusted input) | 6.0 | 8.0 | +2.0 |
| External repo parity | 5.5 | 8.5 | +3.0 |

## Top gains / gaps

### Improved most

1. **debug** — hypothesis ledger, stop-the-line, Prove-It, dedicated reference.md
2. **fix-record / scrutinize** — decomposition + verification protocols
3. **Pack consistency** — cheat sheets + handoffs on all 12 skills

### Still below 9.0

| Skill | Score | Blocker |
|-------|:-----:|---------|
| vault-recall | 8.5 | `vault/learnings/` empty — no runtime recall corpus |
| sql | 8.8 | execution gate present; fewer external parity patterns than debug |
| builder-* | 8.9 | close-out gates added; depth lighter than debug |

## Next actions

- [ ] Populate `vault/learnings/` from closed issues (local; gitignored)
- [ ] Run `./scripts/smoke-skills.sh` on macOS/Linux CI or WSL
- [ ] Behavioral smoke: `docs/DYNAMIC-AGENT-SMOKE.md` after Cursor reload

## References

- Versions: `docs/th/APPENDIX-TH.md` §1 or each `ai-skills/*/SKILL.md` frontmatter
- Upgrade workflow: `ai-skills/upgrade-ai/SKILL.md`
- Smoke: `scripts/smoke-skills.sh`
