# ภาคผนวก — รายละเอียดที่เติมจากการ audit

เอกสารนี้เติมสิ่งที่ [SKILLS-TH.md](./SKILLS-TH.md) และ [RULES-TH.md](./RULES-TH.md) สรุปไว้แต่ยังไม่ลงรายละเอียดครบ — อ่านคู่กับคู่มือหลัก

---

## 1. ตารางเวอร์ชัน skill (ณ repo ปัจจุบัน)

| Skill | Invoke | Version | มี `reference.md` |
|-------|--------|---------|-------------------|
| debug | `/debug` | 1.3.4 | ใช่ |
| scrutinize | `/scrutinize` | 1.2.5 | ใช่ |
| builder-ui | `/builder-ui` | 1.2.6 | ใช่ |
| builder-api | `/builder-api` | 1.2.4 | ใช่ |
| builder-schema | `/builder-schema` | 1.2.3 | ใช่ |
| builder-infrastructure | `/builder-infrastructure` | 1.2.4 | ใช่ |
| builder-feature | `/builder-feature` | 1.5.0 | ใช่ |
| fix-record | `/fix-record` | 1.2.3 | ใช่ |
| upgrade-ai | `/upgrade-ai` | 1.2.5 | ใช่ |
| git-push | `/git-push` | 1.2.3 | ใช่ |
| vault-recall | `/vault-recall` | 1.3.3 | ใช่ |
| wiki-ingest | `/wiki-ingest` | 1.0.3 | ใช่ |
| workday-init | `/workday-init` | 1.2.4 | ใช่ |
| workday-update | `/workday-update` | 1.2.3 | ใช่ |
| workday-review | `/workday-review` | 1.2.1 | ใช่ |

เวอร์ชันจริงอยู่ใน frontmatter ของแต่ละ `SKILL.md` — ถ้าแก้ skill ต้อง bump ตาม `upgrade-ai/reference.md`

---

## 2. ไฟล์ `reference.md` — อ่านเมื่อไหร่

| ไฟล์ | เนื้อหาลึก |
|------|------------|
| `vault-recall/reference.md` | resolve vault root, wiki ≤3, **workday/plans/** feature plans, issues |
| `wiki-ingest/reference.md` | merge pages, index, log, close-out verification |
| `debug/reference.md` | phase 1 exit criteria, edit lock, hypothesis table, verification + callee cleanup |
| `git-push/reference.md` | push matrix, commit gate, SSH multi-account, ตาราง error |
| `scrutinize/reference.md` | agent-skills PR checklist, NeoLabHQ lenses, browser MCP, verification gate |
| `fix-record/reference.md` | section guide, worked example, publish + close-out verification |
| `upgrade-ai/reference.md` | external discovery, context engineering, version governance, anti-patterns |
| `workday-update/reference.md` | dedupe, DISCOVERED TODAY, close-out verification |
| `docs/EXTERNAL-PARITY.md` | catalog crosswalk, security, non-goals |
| `builder-api/reference.md` | slice brief intake, API phases, close-out |
| `builder-schema/reference.md` | slice brief intake, schema phases |
| `builder-infrastructure/reference.md` | slice brief intake, CI/gh-fix-ci, close-out |
| `builder-feature/reference.md` | plan-only, express lane, slice backlog, **plan persist** |
| `builder-ui/reference.md` | slice brief intake, [`template.slice-brief.md`](../../templates/template.slice-brief.md) |
| `templates/template.slice-brief.md` | slice handoff contract (feature → builder-*) |
| `templates/template.feature-plan.md` | PLAN_READY persist → `vault/workday/plans/` |
| `templates/template.workday.md` | WORKDAY block SSoT — section ownership init/update/review |
| `templates/template.workday-file.md` | Vault file wrapper (frontmatter + block) |
| `workday-init/reference.md` | Persistence path, in-place overwrite, load protocol |
| `workday-review/reference.md` | evidence mapping, DAY SCORE rubric |

**หลัก:** `SKILL.md` = workflow + guardrails · `reference.md` = ตาราง/ตัวอย่างยาว (อย่า copy ซ้ำใน rule อื่น)

---

## 3. ส่วนร่วมทุก skill — Scope Guardrails

เกือบทุก skill มีหัวข้อ **`## Scope Guardrails`**:

| ข้อ | ความหมาย |
|-----|----------|
| ALWAYS confirm scope | ยืนยันไฟล์/ขอบเขตก่อนแก้ |
| ALWAYS state non-goals | บอกชัดว่างานนี้ **ไม่** ทำอะไร |
| NEVER speculative rewrite | ห้าม rewrite ใหญ่เมื่อ patch เล็กพอ |

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
- [ ] ขั้นค้น vault **ลิงก์** `vault-recall/reference.md` ไม่ copy ตารางซ้ำ  
- [ ] แยก artifact: issues (รายวัน) · workday (แผน) · `/fix-record` (RCA) · wiki/pages (ความรู้ถาวร ผ่าน `/wiki-ingest`)

---

## 6. `/fix-record` — ปลายทางและ sign-off

| ปลายทาง | หมายเหตุ |
|---------|----------|
| JIRA comment | **default** — ต้อง sign-off ก่อน POST |
| PR description | ได้ |
| `docs/fix-records/<ticket>.md` | ได้ |
| wiki | ได้ |

**ห้าม** โพสต์ JIRA โดยไม่ได้รับ *"post it"* / *"go ahead"* / *"yes"*

---

## 7. Vault — ค้น vs เขียน

### ค้น (อ่าน)

→ `vault-recall/reference.md` หรือ `/vault-recall`

| ขั้น | การทำ |
|------|--------|
| resolve root | `ai-skills-vault.json` → `.cursor/vault/` → `vault/` → agent-skills clone |
| 1 | grep `wiki/pages/` (keywords, `title:`, tags, wikilinks) |
| 2 | อ่านเต็ม ≤ **3** หน้า (ไม่นับ README) |
| 3 | ถ้าไม่พอ → grep `issues/` วันนี้ + เมื่อวาน |
| 4 | (optional) `workday/` วันนี้ — context งานค้าง |

### เขียน (บันทึก)

→ rule `vault-issues.mdc` (issues) · skills `workday-*` (แผน) · `/wiki-ingest` (wiki)

| ประเภท | path | รูปแบบ |
|--------|------|--------|
| issues | `vault/issues/YYYY-MM-DD.md` | `## N. title` + Question / Answer |
| workday | `vault/workday/YYYY-MM-DD.md` | WORKDAY block — `/workday-init` · update · review |
| wiki | `vault/wiki/pages/{slug}.md` | concept page — `/wiki-ingest` เท่านั้น |

Template: `templates/template.issue.md`, `templates/template.wiki-page.md`, `templates/template.wiki-source.md`  
รายละเอียด Obsidian: `vault/README.md`

**ห้าม** ใส่ secret ใน vault

---

## 8. Scripts และ CI (ภาษาไทย)

### `smoke-skills.sh`

| ตรวจ | รายละเอียด |
|------|------------|
| ไฟล์สำคัญ | manifest, vault rule, docs CHANGE-CONTROL, … |
| rule tree | ≥ 25 ไฟล์ `.mdc` + ไฟล์ขั้นต่ำใน core/patching/risk/workflow |
| ทุก skill | `disable-model-invocation: true` + `## Scope Guardrails` |
| ลิงก์ | debug, git-push, AGENTS อ้าง change-control |

**FAIL → exit 1** (ใช้ก่อน commit / CI step แรก)

### `change-control-check.sh`

| ตรวจ | ค่า default |
|------|-------------|
| ไฟล์ใน diff | ≤ 5 |
| บรรทัด add+del | ≤ 120 |
| override | `[BUDGET-OVERRIDE]` ใน commit message HEAD |

`SKIP_CHANGE_CONTROL=1` ข้ามได้ (local)

### `skills-quality.yml` (GitHub Actions)

- trigger: push/PR → `main`  
- step 1: `smoke-skills.sh` — **ล้ม CI ได้**  
- step 2: แจ้ง WARN งบ PR + `change-control-check.sh || true` — **ไม่ล้ม CI** จากงบ

---

## 9. ตาราง `globs` ครบทุก scoped rule

| ไฟล์ | globs (สรุป) |
|------|----------------|
| `core/execution-model` | `**/*.{ts,tsx,js,jsx,py,go,rs,java,kt,cs,php,rb,sql,vue,svelte}` |
| `core/diagnosis-first` | เหมือนด้านบน + รวม sql |
| `core/minimal-change` | `**/*` |
| `core/verification-required` | `**/*` |
| `core/uncertainty-control` | *(ไม่มี — intelligent)* |
| `debugging/*` (5 ไฟล์) | `**/*` |
| `patching/patch-scope-control` | source หลายภาษา (ไม่มี sql) |
| `patching/*` อื่น (4) | `**/*` |
| `architecture/architecture-boundaries` | `**/*.{ts,tsx,js,jsx,py,go}` |
| `architecture/api-contract-safety` | `api/`, `routes/`, `controllers/`, `handlers/`, `*route*` |
| `architecture/shared-module-protection` | `shared/`, `common/`, `lib/`, `utils/`, `core/` |
| `architecture/schema-change-protection` | `migrations/`, `schema/`, `prisma/`, `*migration*` |
| `testing/mandatory-validation` | `**/*` |
| `testing/manual-test-flows` | `**/*` |
| `testing/unsafe-untested-change` | `**/*` |
| `testing/regression-test-policy` | `**/*.{test,spec}.{ts,tsx,js,jsx,py,go}` |
| `risk/production-safety` | `.env*`, `deploy/`, `infra/`, `*prod*`, `k8s/`, `terraform/` |
| `risk/risk-classification` | intelligent |
| `risk/approval-gates` | intelligent |
| `risk/rollback-awareness` | intelligent |
| `workflow/*` (3) | intelligent |

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
| เนื้อหา `vault/issues/*.md` | gitignore — เป็นของ local |
| พฤติกรรม agent จริงใน Cursor | ทดมือตาม [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md); preflight ไฟล์ → `./scripts/verify-dynamic-smoke-static.sh` |

---

## 12. Checklist ความครบของ docs ไทย

| รายการ | สถานะ |
|--------|--------|
| 11/11 skills มีหัวข้อใน SKILLS-TH | ครบ |
| 34/34 rules มีหัวข้อใน RULES-TH | ครบ |
| reference.md อธิบาย | ครบ (ไฟล์นี้ §2) |
| Mantra / flaky / skip mantra | ครบ (§4) |
| vault ค้น vs เขียน + templates | ครบ (§7) |
| smoke / budget / CI | ครบ (§8) |
| globs ทุก rule | ครบ (§9) |
| SKILL-AUTHORING / SKILL-PATTERN (EN) | ลิงก์ใน README — ยังไม่แปลทั้งไฟล์ |
| แปล `reference.md` ทีละไฟล์ | ดัชนีไทย → [REFERENCE-INDEX-TH.md](./REFERENCE-INDEX-TH.md) (ลิงก์ EN) |
| Dynamic agent smoke | [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) + `./scripts/verify-dynamic-smoke-static.sh` |

---

## 13. เอกสารภาษาอังกฤษที่ควรอ่านคู่

| ไฟล์ | ทำไม |
|------|------|
| [SKILL-AUTHORING.md](../../ai-skills/SKILL-AUTHORING.md) | เขียน skill ใหม่ |
| [SKILL-PATTERN.md](../SKILL-PATTERN.md) | โครง SKILL.md |
| [SKILL-SMOKE-CHECKLIST.md](../SKILL-SMOKE-CHECKLIST.md) | ทดสอบมือหลังแก้ rule |
| [CHANGE-CONTROL.md](../CHANGE-CONTROL.md) | 3 layers EN |
| [docs/examples/change-control-wiki-page.md](../examples/change-control-wiki-page.md) | ตัวอย่าง wiki page |
