# ภาคผนวก — รายละเอียดที่เติมจากการ audit

เอกสารนี้เติมสิ่งที่ [SKILLS-TH.md](./SKILLS-TH.md) และ [RULES-TH.md](./RULES-TH.md) สรุปไว้แต่ยังไม่ลงรายละเอียดครบ — อ่านคู่กับคู่มือหลัก

---

## 1. ตารางเวอร์ชัน skill (ณ repo ปัจจุบัน)

| Skill | Invoke | Version | มี `reference.md` |
|-------|--------|---------|-------------------|
| debug | `/debug` | 1.3.12 | ใช่ |
| scrutinize | `/scrutinize` | 1.2.14 | ใช่ |
| builder-ui | `/builder-ui` | 1.3.2 | ใช่ |
| builder-ui-cost | `/builder-ui-cost` | 1.0.2 | ใช่ |
| builder-api | `/builder-api` | 1.2.11 | ใช่ |
| builder-schema | `/builder-schema` | 1.2.10 | ใช่ |
| builder-infrastructure | `/builder-infrastructure` | 1.2.11 | ใช่ |
| builder-feature | `/builder-feature` | 1.8.4 | ใช่ |
| fix-record | `/fix-record` | 1.2.10 | ใช่ |
| upgrade-ai | `/upgrade-ai` | 1.3.6 | ใช่ |
| git-push | `/git-push` | 1.2.10 | ใช่ |
| vault-daily | `/vault-daily` | 2.3.1 | ใช่ |
| vault-capture | `/vault-capture` | 2.4.0 | ใช่ |
| vault-recall | `/vault-recall` | 2.4.7 | ใช่ |

เวอร์ชันจริงอยู่ใน frontmatter ของแต่ละ `SKILL.md` — ถ้าแก้ skill ต้อง bump ตาม `upgrade-ai/reference.md`

---

## 2. ไฟล์ `reference.md` — อ่านเมื่อไหร่

| ไฟล์ | เนื้อหาลึก |
|------|------------|
| `debug/reference.md` | phase 1–4 prose (on demand), exit criteria, hypothesis ledger, close-out verification gate + callee cleanup + § Vault boundary |
| `git-push/reference.md` | push matrix, commit gate, SSH multi-account, ตาราง error |
| `scrutinize/reference.md` | agent-skills PR checklist, review lenses, browser MCP, close-out verification gate |
| `fix-record/reference.md` | section guide, worked example, publish + close-out verification |
| `upgrade-ai/reference.md` | pack-internal discovery, context engineering, version governance, anti-patterns |
| `docs/EXTERNAL-PARITY.md` | catalog crosswalk, security, non-goals |
| `builder-api/reference.md` | slice brief intake, API phases, § Close-out deliverables + gate |
| `builder-schema/reference.md` | slice brief intake, schema phases, § Close-out deliverables + gate |
| `builder-infrastructure/reference.md` | slice brief intake, CI/gh-fix-ci, § Close-out deliverables + gate |
| `builder-feature/reference.md` | index — plan-only gate, Plan mode path resolution |
| `builder-feature/reference-design-reasoning.md` | goal, hypotheses, hierarchy, constraints, recursive review |
| `builder-feature/reference-workflow.md` | workflow map, express lane, phases 0–8 |
| `builder-feature/reference-slice-handoff.md` | slice backlog, slice brief, close-out, anti-rationalization |
| `templates/template.feature-plan.md` | durable plan — `.cursor/plans/` skeleton, phases 0–7, close-out gate, slice backlog |
| `builder-ui/reference.md` | slice brief, Figma SVG / Pixel mode, Confidence + Assumptions, § Close-out deliverables + gate |
| `builder-ui-cost/reference.md` | attach strategy, in-chat intake manifest, verify gate |
| `templates/template.slice-brief.md` | slice handoff contract (feature → builder-*) |

**หลัก:** `SKILL.md` = workflow + guardrails · `reference.md` = ตาราง/ตัวอย่างยาว (อย่า copy ซ้ำใน rule อื่น)

---

## 3. ส่วนร่วมทุก skill — Scope Guardrails

**SSoT:** [`SKILL-AUTHORING.md`](../../ai-skills/SKILL-AUTHORING.md) § Scope Guardrails

| ข้อ | ความหมาย |
|-----|----------|
| ALWAYS confirm scope | ยืนยันไฟล์/ขอบเขตก่อนแก้ |
| ALWAYS state non-goals | บอกชัดว่างานนี้ **ไม่** ทำอะไร |
| NEVER speculative rewrite | ห้าม rewrite ใหญ่เมื่อ patch เล็กพอ |

แต่ละ skill ใน `SKILL.md` ใช้ one-liner `Pack defaults: … § Scope Guardrails` (+ skill-specific เมื่อจำเป็น) — **ไม่** copy bullet 4 ข้อซ้ำใน SKILL

**Builder close-out:** `ARTIFACTS` ชี้ `reference.md` § Close-out deliverables — ดู SKILL-AUTHORING § Builder close-out deliverables

---

## 4. ส่วนร่วม — SKILL REPORT

ทุก skill ใช้ output contract เดียว — [`templates/template.skill-report.md`](../../templates/template.skill-report.md):

```
SKILL REPORT
══════════════════════
STATUS | OBJECTIVE | DISCOVERIES | ANALYSIS | RISKS
ARTIFACTS | NEXT ACTIONS | HANDOFF | CONFIDENCE
```

- **ป้ายหัวข้อ:** English (คงที่)
- **เนื้อหา:** ไทย ~60% / English ~40% — ห้ามซ้ำสองภาษาทั้งบล็อก
- **Mid-session:** STATUS, OBJECTIVE, DISCOVERIES หรือ ANALYSIS, NEXT ACTIONS, CONFIDENCE
- **Close-out:** ครบทุก section

`/debug`: **Mantra + cheat sheet** อยู่ใน `SKILL.md` · phase 1–4 prose เต็มอยู่ใน `debug/reference.md` (โหลดเมื่อติดขั้นตอน)

`/debug` ครั้งแรก: ยังต้อง **ท่อง Mantra ตามต้นฉบับ** ก่อน แล้วค่อยใช้ SKILL REPORT

### Mantra เต็ม (จาก `debug/SKILL.md`)

> 1. **First is reproducibility.** Can the issue be reproduced reliably?  
> 2. **Know the fail path.** Debugger first; then source trace + knob enumeration; then in-code instrumentation.  
> 3. **Question your hypothesis.** What would disprove it?  
> 4. **Every run is a breadcrumb.** Cross-reference all of them.

- User บอก **"skip the mantra"** → ข้ามการท่อง แต่ยังทำ 4 ขั้น  
- **Flaky repro** → ยกอัตราให้ debug ได้ (50% ดีกว่า 1%)  
- **No repro** → หยุด ขอ env/artifact อย่าเดาสมมติฐาน

---

## 5. `/scrutinize` — เช็ค PR ของ agent-skills เพิ่ม

เมื่อ diff แตะ `ai-skills/*/SKILL.md`, `reference.md`, หรือ `ai-rules/*.mdc`:

- [ ] `metadata.version` bump ตาม upgrade-ai governance  
- [ ] `disable-model-invocation: true` (ยกเว้นที่ document ไว้)  
- [ ] `SKILL.md` ไม่ยาวเกิน ~300 บรรทัด — phase ยาวย้ายไป `reference.md`  
- [ ] Handoffs ลิงก์ skill ที่เกี่ยวข้อง — ไม่ orphan workflow  
- [ ] RCA ยาว → `/fix-record` แยกจาก daily Q&A ในแชท

---

## 6. `/fix-record` — ปลายทางและ sign-off

| ปลายทาง | หมายเหตุ |
|---------|----------|
| JIRA comment | **default** — ต้อง sign-off ก่อน POST |
| PR description | ได้ |
| `docs/fix-records/<ticket>.md` | ได้ |

**ห้าม** โพสต์ JIRA โดยไม่ได้รับ *"post it"* / *"go ahead"* / *"yes"*

---

## 7. โฟลเดอร์ `vault/` (Obsidian + agent dual-use)

- เนื้อหา `vault/**` gitignore (ยกเว้น `vault/.gitkeep`) — โน้ตส่วนตัวบนเครื่อง
- **Obsidian:** เปิด folder → `agent-skills/vault` หรือ `.cursor/vault` junction (clone เก่าอาจชื่อ `SKILLS-AI/` — ดู [LEGACY-PATH.md](../../LEGACY-PATH.md))
- setup: junction `.cursor/vault` → `vault/` + `bootstrap-vault` — สร้างโฟลเดอร์ + `_agent/` + `.obsidian/` seed + `daily/YYYY-MM-DD.md` วันนี้ถ้ายังไม่มี
- โครงสร้าง: `vault/{daily,decisions,sessions,projects}/` · archive เก่า → `daily/archive/YYYY/` · catalog ที่ `vault/_agent/manifest.json`
- templates (git): `templates/vault/notes/template.vault-*.md` — agent `Read` → replace placeholders → `Write`
- Spine: [ARCHITECTURE.md](../../ARCHITECTURE.md) § Vault memory · [templates/vault/README.md](../../templates/vault/README.md)
- โหมดค้น: `grep-vault.ps1` (gitignore-safe) หรือ manifest + per-file `Read`

**Memory tiers**

| Tier | โฟลเดอร์ | ใน manifest |
|------|----------|-------------|
| Ephemeral | `daily/YYYY-MM-DD.md` | ไม่บังคับ (upsert ได้) |
| Semantic | `decisions/`, `projects/` | ใช่ |
| Episodic | `sessions/` | ใช่ |

**Wikilinks:** `[[sessions/slug]]` — ไม่ใส่ `notes/` prefix

**Autolog (หลัง patch+verify):** `append-daily.ps1` / `.sh` — UTF-8 safe, แทรก bullet หลัง H2 แรกใน daily; reply **`Vault daily: updated vault/projects/{slug}/daily/YYYY-MM-DD.md`**

**Archive (หลัง triage):** `archive-daily.ps1` — ย้าย daily เก่า → `daily/archive/YYYY/` (default: เก่ากว่า 14 วัน)

**Scripts vault**

| Script | ใช้เมื่อ |
|--------|----------|
| `bootstrap-vault.ps1` / `.sh` | layout + Obsidian seed + daily วันนี้ |
| `append-daily.ps1` / `.sh` | autolog bullet / Issues row |
| `archive-daily.ps1` / `.sh` | ย้าย daily เก่า off hot folder |
| `grep-vault.ps1` / `.sh` | recall ค้น gitignored notes |

**Skills (เรียกเอง — `disable-model-invocation: true`)**

| Skill | ใช้เมื่อ |
|-------|----------|
| `/vault-daily` | สรุปงานวัน + triage + promote (confirm ก่อน) + อัป manifest |
| `/vault-capture` | บันทึก session / ADR — infer project + auto hub `projects/<slug>/hub.md`; dedupe manifest |
| `/vault-recall` | อ่าน manifest → `grep-vault` / Read → cite |

**เชื่อม skill เก่า:** ดู `ai-skills/vault-capture/reference.md` § Integration

---

## 8. Scripts (ภาษาไทย)

| Script | ใช้เมื่อ |
|--------|----------|
| `setup-macos-linux.sh` | ครั้งแรกหลัง clone / หลัง pull บน Mac หรือ Linux |
| `validate-skills.sh` / `.ps1` | ก่อน push — ตรวจ frontmatter, version, path (sync กับ §1 ไฟล์นี้) |
| `smoke-preflight.sh` / `.ps1` | ก่อน DYNAMIC behavioral — validate-skills + checklist |
| `setup-windows.ps1` / `.bat` | เหมือนกันบน Windows |
| `vault/archive-daily.ps1` | หลัง `/vault-daily` — ย้าย daily เก่า (ดู §7) |

สร้าง junction: `.cursor/skills`, `.cursor/rules`, `.cursor/vault` → โฟลเดอร์ใน pack

งบ patch (≤5 ไฟล์, ≤120 บรรทัด) อยู่ใน [`change-control-manifest.mdc`](../../ai-rules/change-control-manifest.mdc) · static validate: `validate-skills`

---

## 9. ตาราง `globs` ครบทุก scoped rule

**Application-source bundle** (patching · testing · debugging · minimal-change · verification-required):  
`**/*.{ts,tsx,js,jsx,html,css,py,go,rs,java,kt,cs,php,rb,sql,vue,svelte}` — **ไม่** trigger เมื่อแก้ meta อย่างเดียว (`ai-skills/`, `ai-rules/`, `docs/`, `scripts/`). ดู manifest § Scoped rules vs meta edits.

| ไฟล์ | globs (สรุป) |
|------|----------------|
| `core/diagnosis-first` | application-source bundle |
| `core/minimal-change` | application-source bundle |
| `core/verification-required` | application-source bundle |
| `core/uncertainty-control` | *(ไม่มี — intelligent)* |
| `debugging/*` (5 ไฟล์) | application-source bundle |
| `patching/patch-scope-control` | source หลายภาษา (ไม่มี sql) |
| `patching/*` อื่น (4) | application-source bundle |
| `architecture/architecture-boundaries` | `**/*.{ts,tsx,js,jsx,py,go}` |
| `architecture/api-contract-safety` | `api/`, `routes/`, `controllers/`, `handlers/`, `*route*` |
| `architecture/shared-module-protection` | `shared/`, `common/`, `lib/`, `utils/`, `core/` |
| `architecture/schema-change-protection` | `migrations/`, `schema/`, `prisma/`, `*migration*` |
| `testing/mandatory-validation` | application-source bundle |
| `testing/manual-test-flows` | application-source bundle |
| `testing/unsafe-untested-change` | application-source bundle |
| `testing/regression-test-policy` | `**/*.{test,spec}.{ts,tsx,js,jsx,py,go}` |
| `risk/production-safety` | `.env*`, `deploy/`, `infra/`, `*prod*`, `k8s/`, `terraform/` |
| `risk/risk-classification` | intelligent |
| `risk/approval-gates` | intelligent |
| `risk/rollback-awareness` | intelligent |
| `workflow/*` | `vault-autolog` = always-on · `stop-conditions` = intelligent |
| `ai-rules/_index.mdc` | intelligent — activation map tier 0–3 |
| `clean-code.mdc` | application-source bundle (Tier 1 globs — **ไม่** always-on) |

---

## 10. ระดับความเสี่ยง (เต็มจาก rule)

| ระดับ | ตัวอย่าง |
|--------|----------|
| **LOW** | typo, copy, logging, comment, null guard แคบที่มี proof |
| **MEDIUM** | validation, query logic, mapping, state, config |
| **HIGH** | auth, payments, concurrency, infra, schema, security, **public API break** |

พูดระดับในแชทก่อน patch · HIGH → approval gate

---

## 11. สิ่งที่ **ไม่** อยู่ใน repo นี้ (ไม่ต้องหาใน docs/th)

| รายการ | หมายเหตุ |
|--------|----------|
| `examples/` UI mock (RiskPro HTML) | **ถอดออกจาก repo แล้ว** — mock อยู่ที่ consumer project ถ้าต้องการ |
| `test-builder` skill | ยังไม่มี — `builder-feature` วางแผน test ใน phase 7 เอง |
| Cursor Automations | แยกจาก agent-skills |
| เนื้อหา `vault/**` (ยกเว้น `.gitkeep`) | gitignore — local notes only |
| พฤติกรรม agent จริงใน Cursor | ทดมือตาม [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) |

---

## 12. Checklist ความครบของ docs ไทย

| รายการ | สถานะ |
|--------|--------|
| 14 skills มีหัวข้อใน SKILLS-TH (รวม builder-ui-cost + vault 3 ตัว) | ครบ |
| 33/33 rules มีหัวข้อใน RULES-TH (+ `_index.mdc`) | ครบ |
| ARCHITECTURE spine + `_catalog` | ครบ — ลิงก์ใน README ไทย |
| reference.md อธิบาย | ครบ (ไฟล์นี้ §2 + REFERENCE-INDEX-TH) |
| Scope Guardrails SSoT + builder ARTIFACTS | ครบ (§3 + SKILL-AUTHORING) |
| Mantra / flaky / skip mantra | ครบ (§4) |
| โฟลเดอร์ `vault/` + archive-daily + autolog UTF-8 | ครบ (§7) |
| setup scripts / patch budget | ครบ (§8) |
| globs ทุก rule | ครบ (§9) |
| SKILL-AUTHORING / SKILL-PATTERN (EN) | ลิงก์ใน README — ยังไม่แปลทั้งไฟล์ |
| แปล `reference.md` ทีละไฟล์ | ดัชนีไทย → [REFERENCE-INDEX-TH.md](./REFERENCE-INDEX-TH.md) (ลิงก์ EN) |
| Dynamic agent smoke | [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) |

---

## 13. เอกสารภาษาอังกฤษที่ควรอ่านคู่

| ไฟล์ | ทำไม |
|------|------|
| [ARCHITECTURE.md](../../ARCHITECTURE.md) | spine — pack, vault, apps, catalog |
| [SKILL-AUTHORING.md](../../ai-skills/SKILL-AUTHORING.md) | เขียน skill ใหม่ |
| [SKILL-PATTERN.md](../SKILL-PATTERN.md) | โครง SKILL.md + template index |
| [SKILL-SMOKE-CHECKLIST.md](../SKILL-SMOKE-CHECKLIST.md) | ทดสอบมือหลังแก้ rule |
| [CHANGE-CONTROL.md](../CHANGE-CONTROL.md) | 4 layers EN (spine + rules + skills + setup) |
| [EXTERNAL-PARITY.md](../EXTERNAL-PARITY.md) | เทียบ Claude Code / Cursor / agentskills.io — non-goals |
| [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) | Meta release regression bundle #1–#16 |

---

## 14. Meta release (หลัง push pack meta)

1. `./scripts/smoke-preflight.sh` — validate-skills + APPENDIX §1 version sync  
2. **Reload Cursor**  
3. Fresh chat — DYNAMIC **#1, #2, #9, #11, #12, #14, #16** (บันทึก Y/N ใน pass log)  
4. ทด `append-daily.ps1 -Project platform -Bullet "test"` — ต้องได้ OK + bullet ใต้ summary H2 (ไม่ error UTF-8)

รายละเอียด EN: [SKILL-SMOKE-CHECKLIST.md](../SKILL-SMOKE-CHECKLIST.md) § Meta release
