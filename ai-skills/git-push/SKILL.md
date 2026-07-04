---
name: git-push
metadata:
  version: "1.2.10"
description: >-
  Use when the user asks to push, publish, sync to GitHub, or confirms commit+push
  (ยืนยัน). Safely inspect repo state, commit only on explicit consent, push once,
  verify remote. Blocks dirty tree without consent. Invoke with /git-push.
compatibility: >-
  Cursor with junction setup (scripts/setup-macos-linux.sh or setup-windows.ps1).
  Requires explicit /slash invoke (disable-model-invocation). Copy ai-skills/ for
  other Agent Skills-compatible hosts.
disable-model-invocation: true
---

# Skill: git-push

Role: Release operator

Mission: Inspect repo state, use the correct remote identity, push once, verify.

## Quick cheat sheet

| State | Action |
|-------|--------|
| Dirty tree, no commit consent | **Blocked** — matrix row; propose message only |
| Clean, ahead of origin | Push after Phase 1 inspect |
| Wrong SSH / remote | Fix identity per reference § Remote & identity |
| After push | Verify remote HEAD + upstream |

Matrix detail: [`reference.md`](./reference.md). **Iron law:** commit only on explicit user request (`ยืนยัน` / confirm) — `/git-push` alone is not consent.

## agent-skills repo

When pushing **this** repository:

- Edit and commit **`ai-skills/`**, **`ai-rules/`**, **`scripts/`**, **`templates/`**, **`docs/`** — not files only under `.cursor/` junctions.
- After clone, run `./scripts/setup-macos-linux.sh .` so Cursor loads linked skills.
- `vault/**` (except `.gitkeep`) is **gitignored** — local notes only.

## Scope Guardrails

Pack defaults: [`SKILL-AUTHORING.md`](../SKILL-AUTHORING.md) § Scope Guardrails.

## Handoffs (other skills in this pack)

| Situation | Skill |
|-----------|--------|
| Review before merge | [`/scrutinize`](../scrutinize/SKILL.md) |
| Skill/rule changes in commit | [`/upgrade-ai`](../upgrade-ai/SKILL.md) checklist via scrutinize |

## Change-control

Before commit: [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) · [`approval-gates`](../../ai-rules/risk/approval-gates.mdc).

---

# Workflow

Phase 1 — parallel inspect:

```bash
git status && git diff && git diff --staged && git branch -vv && git remote -v && git log -3 --oneline
```

Warn if `.env` / `.env.*` in diff — exclude unless user asks. Phases 2–5: [reference.md](./reference.md) (commit gate → identity → push → verify).

---

## SKILL REPORT

Contract: [`templates/template.skill-report.md`](../../templates/template.skill-report.md).

| Section | `/git-push` |
|---------|-------------|
| STATUS | READY = pushed/synced; BLOCKED = dirty tree / no consent / SSH; IN_PROGRESS = inspecting |
| OBJECTIVE | Safely inspect, commit (if consented), push, verify remote |
| DISCOVERIES | `git status`, ahead/behind, matrix row, remote URL, auth errors |
| ANALYSIS | Path taken, block cause, proposed commit message if dirty |
| RISKS | Secrets in diff, force-push, wrong remote identity, hook failures |
| ARTIFACTS | Branch, remote, commit range pushed, command output snippets |
| NEXT ACTIONS | User phrase to unblock (e.g. ยืนยัน) or exact command |
| HANDOFF | `/scrutinize` before merge · `none` |
| CONFIDENCE | 0–100; no READY without fresh push/status output |

Mid-session: STATUS, OBJECTIVE, DISCOVERIES, NEXT ACTIONS, CONFIDENCE. Close-out: all sections.
