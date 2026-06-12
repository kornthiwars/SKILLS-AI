# Catalog submission — awesome-agent-skills

Prepare to list [kornthiwars/agent-skills](https://github.com/kornthiwars/agent-skills) in [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills).

**Bar ([CONTRIBUTING](https://github.com/VoltAgent/awesome-agent-skills/blob/main/CONTRIBUTING.md)):** public repo, working skills, docs, **real community usage** — brand-new skills are declined. Submit after external references, stars, or sustained personal/team use.

---

## Pre-submission checklist

- [ ] `./scripts/validate-skills.sh` green
- [ ] [SKILL-EVAL-PROMPTS.md](./SKILL-EVAL-PROMPTS.md) regression bundle run (manual)
- [ ] README + AGENTS.md link to repo; clone URL works
- [ ] No secrets in repo; `vault/**` gitignored
- [ ] Evidence of adoption (pick ≥1): GitHub stars, fork/clone by others, blog/issue link, team usage note

---

## Draft catalog entry

**Category:** Community Skills → **Context Engineering** (or **Development and Testing**)

```markdown
- **[kornthiwars/agent-skills](https://github.com/kornthiwars/agent-skills)** - Change-control Cursor skill pack with vault memory
```

Description must stay **≤10 words** per CONTRIBUTING. Adjust only if maintainer asks.

---

## PR template (fork awesome-agent-skills)

**Title:** `Add skill: kornthiwars/agent-skills`

**Body:**

```markdown
## Summary
Curated link to opinionated Cursor agent-skills pack (debug, builder-*, vault, change-control rules).

## Checklist
- [x] Public repo with SKILL.md per skill
- [x] Link verified
- [x] Community usage: <fill: stars / team / duration>

## Category
Context Engineering → end of section
```

**Steps:**

1. Fork `VoltAgent/awesome-agent-skills`
2. Add draft line to `README.md` under **Context Engineering**
3. Open PR; link this pack's README

---

## After listing

- Add badge or “Listed in awesome-agent-skills” line to root README (optional)
- Keep [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md) crosswalk updated when adding external skills

## Related

- [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md) § Using this pack with external skills
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) § External discovery
