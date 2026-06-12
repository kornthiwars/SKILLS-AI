# Skill eval prompts (manual)

Lightweight behavioral evals — extend [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md). Run in **fresh Cursor chat** after skill changes. Static preflight first:

```bash
./scripts/validate-skills.sh
# Windows: powershell -NoProfile -File scripts/validate-skills.ps1
```

Record **Y** / **N** in PR or local notes. Target: ≥1 prompt per core skill per release that touches `ai-skills/`.

---

## debug

| Prompt | Pass criteria |
|--------|---------------|
| Paste a stack trace + attach `/debug` | Mantra on first reply; no fix before repro; hypothesis table or ledger; after verified fix → `Vault daily: updated ...` |

---

## git-push

| Prompt | Pass criteria |
|--------|---------------|
| `/git-push` with dirty tree, no ยืนยัน | BLOCKED; proposed commit message; no `git commit` |
| `/git-push ยืนยัน` after consent | Inspect → commit → push → verify remote HEAD |

---

## vault-capture

| Prompt | Pass criteria |
|--------|---------------|
| `/vault-capture` after substantive session | Inferred project + reason; session/decision file; hub `projects/<slug>.md`; manifest upsert with `tags` |

---

## vault-recall

| Prompt | Pass criteria |
|--------|---------------|
| `/vault-recall` + question about past vault topic | `grep-vault` or per-file Read; cites path + line range; does not claim empty vault when notes exist |

---

## vault-daily

| Prompt | Pass criteria |
|--------|---------------|
| `/vault-daily` at end of day | Triage preview; no promote without confirm; SKILL REPORT |

---

## builder-feature

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-feature` + cross-layer feature + mock | PLAN_READY; slice backlog; **zero** app file edits; handoff to owner skill |

---

## builder-ui

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-ui` + screenshot/mock | Browser verify in close-out; after patch → `Vault daily: updated ...` |

---

## scrutinize

| Prompt | Pass criteria |
|--------|---------------|
| `/scrutinize` on skill diff | agent-skills checklist; version bump noted; no patch until review complete |

---

## upgrade-ai

| Prompt | Pass criteria |
|--------|---------------|
| `/upgrade-ai` meta audit | SKILL REPORT all sections; version bump plan; confidence capped ≤85 for audit-only |

---

## fix-record

| Prompt | Pass criteria |
|--------|---------------|
| `/fix-record` after validated fix | Required sections; mechanism not symptom-only; autolog after write |

---

## Regression bundle (post-release)

Run DYNAMIC scenarios **#1, #2, #9, #11, #14** plus `./scripts/validate-skills.sh` green.

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md) — ecosystem comparison
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) § Close-out verification gate
