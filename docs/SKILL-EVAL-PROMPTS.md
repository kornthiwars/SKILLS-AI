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
| "Explain this codebase" + `/debug` on unfamiliar repo | Reads `AGENTS.md` first; optional `/vault-recall`; then phase 1 exit criteria before fix |

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
| `/vault-capture` after substantive session | Inferred project + reason; session/decision file; hub `projects/<slug>/hub.md`; manifest upsert with `tags` |

---

## vault-recall

| Prompt | Pass criteria |
|--------|---------------|
| `/vault-recall` + question about past vault topic | `grep-vault` or per-file Read; cites path + line range; does not claim empty vault when notes exist |

---

## vault-daily

| Prompt | Pass criteria |
|--------|---------------|
| `/vault-daily` at end of day | Triage preview; no promote without confirm; session/decision promote → infer project + hub `projects/<slug>/hub.md`; SKILL REPORT |

---

## builder-feature

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-feature` + cross-layer feature + mock | `plan_ready`; plan at `.cursor/plans/<slug>.plan.md`; Phase 0 **Goal** + constraints; Phase 2 hypothesis **chosen**; Phase 7 recursive review; slice backlog; **zero** app file edits; handoff to owner skill |
| `/builder-feature` + mock + "ทำ html" | `Path: ui-only-express`; express lane (Phase 2 UI hypotheses); Phase 4–6 N/A documented; close-out row 8 waiver if Phase 6 N/A; **zero** app edits; `/builder-ui slice 1 go` |

---

## builder-ui

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-ui` + screenshot/mock | Browser verify in close-out; after patch → `Vault daily: updated ...` |

---

## builder-api

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-api` + slice brief (Outcome, Verify, Owner) | Slice brief intake before phase 1; contract draft; close-out gate; after patch → `Vault daily: updated ...` |
| `/builder-api` + new endpoint without auth plan | Auth matrix + validation layer before READY |

---

## builder-schema

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-schema` + destructive prod migration request | Migration + rollback plan; explicit confirmation gate; no migrate without approval |
| `/builder-schema` + slice brief | ER map + migration plan; handoff to `/builder-api` if contract impact noted |

---

## builder-infrastructure

| Prompt | Pass criteria |
|--------|---------------|
| `/builder-infrastructure` + CI/CD change | Rollback plan + observability; close-out gate |
| `/builder-infrastructure` + slice brief | SLO/env map before IaC edit; after verify → `Vault daily: updated ...` |

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
| Post meta release | `./scripts/smoke-preflight.sh` green; regression bundle #1,#2,#9,#11,#12,#14,#16 documented in pass log |

---

## fix-record

| Prompt | Pass criteria |
|--------|---------------|
| `/fix-record` after validated fix | Required sections; mechanism not symptom-only; autolog after write |

---

## Regression bundle (post-release)

1. `./scripts/smoke-preflight.sh` (runs `validate-skills`)
2. **Reload Cursor**
3. Fresh chat — DYNAMIC scenarios **#1, #2, #9, #11, #12, #14, #16**
4. Log **Y/N** in [DYNAMIC-AGENT-SMOKE.md](./DYNAMIC-AGENT-SMOKE.md) pass log

After `append-daily` or vault script changes: run `./scripts/vault/append-daily.sh --bullet "smoke test"` — expect OK or SKIP duplicate; bullet under `## สรุปงานวันนี้`.

## Related

- [SKILL-SMOKE-CHECKLIST.md](./SKILL-SMOKE-CHECKLIST.md)
- [EXTERNAL-PARITY.md](./EXTERNAL-PARITY.md) — ecosystem comparison
- [upgrade-ai/reference.md](../ai-skills/upgrade-ai/reference.md) § Close-out verification gate
