# คู่มือ Skills (ภาษาไทย)

แต่ละ skill อยู่ใน `ai-skills/<ชื่อ>/SKILL.md` — เรียกในแชทด้วย **`/ชื่อ`**

**Domain catalog:** [ai-skills/_catalog/](../../ai-skills/_catalog/) · **เวอร์ชัน SSoT:** [APPENDIX-TH.md](./APPENDIX-TH.md) §1

ทุก skill ตั้ง **`disable-model-invocation: true`** — agent ไม่ auto-invoke; คุณพิมพ์ `/slash` เอง

---

## สารบัญ (14 skills)

| # | Skill | Domain |
|---|-------|--------|
| 1 | [debug](#1-debug) | Diagnose |
| 2 | [scrutinize](#2-scrutinize) | Diagnose |
| 3 | [builder-ui-cost](#3-builder-ui-cost) | Build |
| 4 | [builder-ui](#4-builder-ui) | Build |
| 5 | [builder-api](#5-builder-api) | Build |
| 6 | [builder-schema](#6-builder-schema) | Build |
| 7 | [builder-infrastructure](#7-builder-infrastructure) | Build |
| 8 | [builder-feature](#8-builder-feature) | Build |
| 9 | [fix-record](#9-fix-record) | Diagnose |
| 10 | [upgrade-ai](#10-upgrade-ai) | Meta |
| 11 | [git-push](#11-git-push) | Meta |
| 12 | [vault-daily](#12-vault-daily) | Memory |
| 13 | [vault-capture](#13-vault-capture) | Memory |
| 14 | [vault-recall](#14-vault-recall) | Memory |

> **หมายเหตุ:** `/sql` ถูกถอดออกจาก pack — ใช้ `/builder-schema` แทนงาน schema/migration

---

## 1. debug

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/debug` |
| **เวอร์ชัน** | ดู [APPENDIX-TH.md](./APPENDIX-TH.md) §1 |
| **บทบาท** | วิศวกร debug แบบมีวินัย — repro → trace → หักล้างสมมติฐาน → breadcrumb |

### ใช้เมื่อไหร่

- มี **bug**, **stack trace**, พฤติกรรมผิด, **performance regression**, **build/CI fail**, หรือ integration timeout
- ต้องการ **repro ที่ทำซ้ำได้**, ไล่ **fail path**, **ตารางสมมติฐาน CONF/REJ**, และ **ledger** การทดลอง
- ยังไม่ควรเสนอ fix จนกว่า **phase 1 exit criteria** จะครบ (มี artifact ไม่ใช่แค่เดา)

### ไม่ใช้เมื่อไหร่

- แค่ review แผน/PR โดยไม่มีอาการผิดพลาด → ใช้ `/scrutinize`
- แค่รัน SQL/schema work → ใช้ `/builder-schema`
- แค่ push git → ใช้ `/git-push`

### หลักการสำคัญ (Mantra)

บนการตอบครั้งแรก skill ขอให้ agent **ท่อง mantra ตามต้นฉบับ** (ยกเว้นคุณบอก **"skip the mantra"**):

1. **First is reproducibility.** — repro ได้ซ้ำไหม?  
2. **Know the fail path.** — debugger → trace + knobs → instrumentation  
3. **Question your hypothesis.** — อะไรจะพิสูจน์ว่าผิด?  
4. **Every run is a breadcrumb.** — ไขว้ทุกการรัน

**Flaky repro:** ยกอัตราก่อน (50% ดีกว่า 1%) · **No repro:** หยุด ขอ env/logs/core — **ห้าม** ไปขั้นเดาสมมติฐาน

รายละเอียดเพิ่ม → [APPENDIX-TH.md](./APPENDIX-TH.md) §4

### ขั้นตอน workflow

| Phase | ชื่อ | ทำอะไร |
|-------|------|--------|
| 1 | Reproduce reliably | สร้างสัญญาณ pass/fail ที่ทำซ้ำได้เร็ว (สคริปต์, test, ขั้นตอนมือ) |
| 2 | Know the fail path | debugger / trace / instrumentation ในโค้ด — รู้ว่า execution ไปทางไหนจนล้ม |
| 3 | Falsify hypothesis | สมมติฐาน 3–5 อันจัดอันดับ — **พยายามพิสูจน์ว่าผิด** ก่อนเชื่ออันใดอันหนึ่ง |
| 4 | Breadcrumb ledger | ทุกการรัน = บันทึก + **ตาราง H1/H2… CONFIRMED/REJECTED/INCONCLUSIVE** พร้อม cite evidence |

**Handoffs:** fix ยืนยันแล้ว → `/fix-record` หรือ `/vault-capture` (สั้น, ไม่แทน RCA) · จบวัน → `/vault-daily` · review patch → `/scrutinize` · schema/data plan → `/builder-schema`  
**Cheatsheet + รายละเอียด:** `debug/reference.md` (exit criteria, instrumentation lifecycle, verification protocol รวม callee redirect cleanup)

### สิ่งที่ skill ห้ามทำ

- เสนอ fix ก่อน phase 1 พอใจ
- เริ่มทดลองสมมติฐานก่อนรู้ fail path
- ยืนยัน root cause โดยไม่ผ่าน breadcrumb ทั้งหมด
- rewrite ใหญ่แทน patch เล็กที่มีหลักฐาน

### ผลลัพธ์ที่คาดหวัง

- **Debug ledger** + **hypothesis table** ต่อเนื่องในแชท
- Repro artifact, trace notes, สมมติฐานที่ถูกตัดออก (REJECTED พร้อม evidence)
- รูปแบบตอบ: **SKILL REPORT** (ดู `templates/template.skill-report.md`)
- ข้อเสนอ fix **เล็กที่สุด** หลัง verification protocol ผ่าน (รวม grep symbol เก่าถ้าเปลี่ยน caller) — แล้วเสนอ `/fix-record` ถ้าไม่ trivial

### ความสัมพันธ์กับ rules

- `change-control-manifest.mdc` — ลำดับ 10 ขั้น (observe → vault autolog → regression) · Attempt ledger ตอน retry
- rules ใน `debugging/`, `patching/`, `testing/` — เปิดเมื่อแก้โค้ด

### ตัวอย่างประโยคที่ใช้

> `/debug` — login หลัง deploy คืน 500 แต่ local ผ่าน

---

## 2. scrutinize

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/scrutinize` |
| **บทบาท** | ผู้ review ภายนอก — ถามว่า “ควรมี change นี้ไหม” แล้วไล่โค้ดจริง |

### ใช้เมื่อไหร่

- ก่อน **merge PR**
- ต้องการ **second opinion** บนแผน, diff, หรือสถาปัตยกรรม
- review skill/rule ใน agent-skills เอง (version bump, guardrails, handoffs)

### ไม่ใช้เมื่อไหร่

- Rubber-stamp “LGTM” โดยไม่มี `file:line`
- จับ style nit แทนปัญหาโครงสร้าง
- ข้ามคำถาม “มีทางที่เล็กกว่านี้ไหม” (ยกเว้นคุณบอกไม่ต้องถาม scope)

### ขั้นตอน workflow

1. **Intent** — เป้าหมาย change คืออะไร? มีทางเลือกที่เล็ก/เรียบง่ายกว่าไหม?
2. **Trace** — ไล่ path จริง: entry → call sites → state → exit
3. **Verify** — path นั้นทำให้ได้พฤติกรรมที่อ้างไหม? edge cases? test coverage?
4. **Report** — findings เรียง blocker → major → nit; **verdict** หนึ่งบรรทัด

### Verdict ที่เป็นไปได้

| Verdict | ความหมาย |
|---------|----------|
| ship | พร้อม merge |
| fix-then-ship | แก้จุดสำคัญก่อน |
| rework | ออกแบบใหม่ |
| reject | ไม่ควรทำ |

### ผลลัพธ์

- แต่ละ finding: ปัญหา, ทำไมสำคัญ, **หลักฐาน file:line**, แนวแก้
- **PR ของ agent-skills** (เมื่อแตะ skill/rule): bump `metadata.version`, `disable-model-invocation`, SKILL.md ≤~300 บรรทัด, handoffs ครบ — ดู checklist เต็มใน [APPENDIX-TH.md](./APPENDIX-TH.md) §5

### ตัวอย่าง

> `/scrutinize` — review PR ที่เพิ่ม endpoint ใหม่

---

## 3. builder-ui-cost

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-ui-cost` |
| **บทบาท** | UI **pixel match** จาก PNG/SVG — **token ต่ำสุด** (manifest ในแชท ไม่เขียน intake `.md` ลง repo) |

### ใช้เมื่อไหร่

- ต้องการ clone UI จาก mock **เร็ว + ถูก token**
- มี PNG และ/หรือ SVG แนบครั้งเดียว → `build` → `verify` ใน browser

### ไม่ใช้เมื่อไหร่

- production component tree, design system, a11y เต็ม → `/builder-ui`
- feature ข้าม layer → `/builder-feature` ก่อน

### ขั้นตอนสั้น

1. **Intake** — `## Intake manifest` ในแชท (ไม่ commit `.md`)
2. User: `build` — สร้างไฟล์ UI
3. User: `verify` — browser compare ครั้งเดียว

Handoff production → [`/builder-ui`](#4-builder-ui)

---

## 4. builder-ui

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-ui` |
| **บทบาท** | สถาปนิก UI — จาก reference (ภาพ/ mock) ไปสู่ component architecture |

### ใช้เมื่อไหร่

- ออกแบบ **frontend architecture**, component tree, design tokens
- มี visual reference (screenshot, Figma export)
- **`slice N go`** หลัง `/builder-feature` — โหลด slice brief ก่อน phase 1

### ไม่ใช้เมื่อไหร่

- clone pixel ตาบอดโดยไม่แยก hierarchy
- ยัด business logic ใน presentation layer
- แลก a11y/responsive เพื่อความเร็ว

### ขั้นตอน (8 phase)

0. Slice brief intake (จากแผน feature หรือ N/A ถ้า standalone)  
1. Visual analysis  
2. Layout reconstruction  
3. Component extraction  
4. Design-system inference  
5. Interaction + state  
6. Accessibility review  
7. Verification (checklist pass/reject)

รายละเอียด slice brief → `ai-skills/builder-ui/reference.md` § Slice brief intake

### ผลลัพธ์

- UI Analysis, Component Architecture, Design System
- Responsive Plan, Verification Plan

---

## 5. builder-api

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-api` |
| **บทบาท** | สถาปนิก API — domain ก่อน endpoint |

### ใช้เมื่อไหร่

- ออกแบบ/ refactor **API contract**, routes, service boundaries
- ต้องการ validation, auth, error model, observability
- **`slice N go`** หลัง `/builder-feature` — โหลด slice brief ก่อน phase 1

### ขั้นตอน (11 phase)

0. Slice brief intake (จากแผน feature หรือ N/A ถ้า standalone)  
1. Domain analysis  
2. Resource modeling  
3. Contract design  
4. Validation architecture  
5. AuthN/AuthZ  
6. Error system  
7. Scalability  
8. Observability + reliability  
9. Backend structure  
10. Verification  

รายละเอียด slice brief → `ai-skills/builder-api/reference.md` § Slice brief intake

### ผลลัพธ์

- API Analysis, Resource Architecture, API Contracts
- Security Architecture, Reliability Plan

---

## 6. builder-schema

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-schema` |
| **บทบาท** | สถาปนิก schema — entity, integrity, evolution ปลอดภัย |

### ใช้เมื่อไหร่

- ออกแบบ entity, ความสัมพันธ์, index, migration strategy
- **`slice N go`** หลัง `/builder-feature` — โหลด slice brief ก่อน phase 1

### ไม่ใช้เมื่อไหร่

- เริ่มจาก “สร้างตาราง” โดยไม่รู้ domain
- over-index ก่อนรู้ query pattern

### ขั้นตอน (11 phase)

0. Slice brief intake (จากแผน feature หรือ N/A)  
1–10. Domain → Entity → Relationships → Normalization → Query patterns → Indexing → Integrity → Scale → Evolution → Verification

รายละเอียด slice brief → `ai-skills/builder-schema/reference.md` § Slice brief intake

### ผลลัพธ์

- Entity Architecture, Relationship Architecture, Evolution Plan

เชื่อมกับ rule `schema-change-protection` และ `production-safety`

---

## 7. builder-infrastructure

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-infrastructure` |
| **บทบาท** | สถาปนิก infra — SLO, deploy, security, observability, cost |

### ใช้เมื่อไหร่

- ออกแบบ deployment, platform, IaC, DR, scaling
- **`slice N go`** หลัง `/builder-feature` — โหลด slice brief ก่อน phase 1

### ไม่ใช้เมื่อไหร่

- เริ่มจาก “จอง server” โดยไม่รู้ workload/SLO
- ผูก environment แน่นเกินไป

### ขั้นตอน (10 phase)

0. Slice brief intake (จากแผน feature หรือ N/A)  
1–9. Workload & SLO → Boundaries → Deploy → Compute/network → Secrets → Observability → Reliability → Scale/cost → IaC + verify

รายละเอียด slice brief → `ai-skills/builder-infrastructure/reference.md` § Slice brief intake

---

## 8. builder-feature

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-feature` |
| **Version** | ดู [APPENDIX-TH.md](./APPENDIX-TH.md) §1 |
| **บทบาท** | **Plan-only orchestrator** — design reasoning + flow + slice backlog **ไม่เขียนโค้ด** |
| **Activation** | Manual `/builder-feature` — **ไม่มี** `paths` frontmatter (ไม่ auto-invoke ตอนแก้ app code) |

### ใช้เมื่อไหร่

- วางแผน **feature ข้าม layer** (UI + API + schema + infra)
- วางแผน **UI mock / static HTML** ผ่าน **express lane** (`Path: ui-only-express`)

### ไม่ใช้เมื่อไหร่

- implement เองใน skill นี้ (รวม HTML/CSS)
- บั๊กจุดเดียว → `/debug`
- layer เดียวพร้อม implement ทันที (ไม่ต้อง plan) → `/builder-ui` ฯลฯ โดยตรง

### Design reasoning (บังคับ — ไม่ใช่ชื่อ framework ภายนอก)

```text
Goal → Hypotheses → Hierarchy → Constraints → Consistency → Self-review
```

| Lens | Phase | ใน plan file |
|------|-------|----------------|
| Goal-driven | 0, 1 | `**Goal:**`, requirements, gap |
| Hypothesis | 2 | approach table ≥2 แถว → **chosen** หนึ่งเดียว |
| Hierarchy | 2–3 | infra → API → app → UI |
| Constraints | 0, 6 | constraints table + re-check |
| Consistency | ทุก phase | `overview` = goal; ledger ใน SKILL REPORT |
| Self-review | 7 | `### Recursive review` |

**Iron law:** ห้าม lock slice backlog จนกว่า hypothesis จะเหลือทางเดียวและผ่าน constraints

### โหมด

| โหมด | ผลลัพธ์ |
|------|---------|
| **PLAN** | Phase 0–7 + slice backlog → `plan_ready` |
| **Express** | `Path: ui-only-express` — plan สั้น (Phase 2 UI hypotheses, defer 4–6) |
| **Iterate** | แก้ plan file อย่างเดียว |
| **Handoff** | Slice brief → `/builder-ui` · `/builder-api` · … |

### Path (Phase 0)

| `Path:` | การทำงาน |
|---------|----------|
| `cross-layer` | phases 1–7 ใน builder-feature |
| `ui-only-express` | express lane — **อยู่** ใน builder-feature จน `slice N go` |
| UI-only + implement now | exit → `/builder-ui` (ไม่ผ่าน orchestrator) |

### ขั้นตอน (plan)

0. Discovery — **Goal**, constraints, gap, `Path:`  
1. **Workflow map** (บังคับก่อน slice backlog)  
2. Existing systems — **hypothesis table** + hierarchical layers + reuse  
3–6. Boundaries, delegation, integration, rollout (express: defer **4–6** N/A; Phase 6 rollback ยกเว้นได้เมื่อ express)  
7. Plan verification + **recursive review**  
→ Slice backlog + plan file **`.cursor/plans/<slug>.plan.md`** ([`template.feature-plan.md`](../templates/template.feature-plan.md))  
→ **`plan_ready`** → user ยืนยัน → **`slice N go`** ([`template.slice-brief.md`](../templates/template.slice-brief.md))

Close-out: [`template.feature-plan.md`](../templates/template.feature-plan.md) § Close-out gate (11 ข้อ)

### ผลลัพธ์

- Plan file path, workflow map, hypothesis table, **Slice backlog**, Slice N brief  
- **ไม่มี** diff ใน repo จาก skill นี้

### Handoff ไป owner skills

Vertical slice rules: [builder-feature/reference-slice-handoff.md](../../ai-skills/builder-feature/reference-slice-handoff.md) § Slice backlog

### Smoke

- Scenario **#9** (express) · **#10** (cross-layer) ใน [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md)
- Pass criteria: [SKILL-EVAL-PROMPTS.md](../SKILL-EVAL-PROMPTS.md) § builder-feature

### แผนเก่า (legacy migration)

แผนก่อน template 1.7.x ยัง execute slice ได้ — revise เมื่อต้องการ Goal/hypothesis/recursive review (ดู reference § Legacy plan migration)

### เอกสารลึก

- [reference-design-reasoning.md](../../ai-skills/builder-feature/reference-design-reasoning.md) · [reference-workflow.md](../../ai-skills/builder-feature/reference-workflow.md) § UI-only express lane  
- [REFERENCE-INDEX-TH.md](./REFERENCE-INDEX-TH.md)

---

## 9. fix-record

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/fix-record` |
| **บทบาท** | เขียน **RCA วิศวกรรม** หลัง fix ผ่าน validation แล้ว |

### ใช้เมื่อไหร่

- “เขียน RCA”, “document fix”, ปิด bug ด้วย writeup
- หลัง `/debug` จบและ fix **ยืนยันแล้ว**

### ไม่ใช้เมื่อไหร่

- bug ยังไม่ fix / ยังไม่ validate
- typo ชัดๆ ไม่ต้อง ceremony
- โพสต์ JIRA โดยไม่ sign-off

### input ที่ต้องครบ (4 อย่าง)

1. Repro  
2. Root cause  
3. Fix  
4. Validation  

ขาดอย่างใด → หยุดและบอกช่องว่าง

### โครง RCA (บังคับ + เสริม)

**บังคับ:** Summary, Root cause, Fix, Validation  

**ตามบริบท:** Symptom, Why symptom, How found, Why slipped, Action items

---

## 10. upgrade-ai

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/upgrade-ai` |
| **บทบาท** | วินิจฉัย **ชั้นที่พัง** (skill vs rule vs setup) ก่อนแก้ repo นี้ |

### ใช้เมื่อไหร่

- อาการเดิมซ้ำ ≥ 2 ครั้ง
- output ไม่สม่ำเสมอ / hallucination เพิ่ม
- user ปฏิเสธผลงานบ่อย
- skill ยาวเกิน (>300 บรรทัด / หลาย responsibility)
- regression หลังอัปเดต skill

### ไม่ใช้เมื่อไหร่

- แค่ cosmetic
- optimize โดยไม่มีหลักฐาน

### ขั้นตอน (8 phase)

1. Reproduce (grep `ai-skills/` / `ai-rules/` ถ้าเป็น agent-skills)  
2. Localize layer  
3. Isolate component  
4. Competing hypotheses (≥2)  
5. Root cause analysis  
6. Blast radius  
7. Upgrade proposal (minimal → redesign) + **version bump plan**  
8. Verification  

### ผลลัพธ์

- Diagnosis Summary, Evidence, Upgrade Proposal, Verification Plan

อ้างอิง governance → `upgrade-ai/reference.md`

---

## 11. git-push

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/git-push` |
| **บทบาท** | Release operator — ดู state, identity ถูก, push ครั้งเดียว, verify |

### ใช้เมื่อไหร่

- push / publish / sync GitHub
- push ล้ม (SSH, permission, upstream)
- **`/git-push ยืนยัน`** หลังถูก block เพราะ working tree dirty

### สำคัญมาก

- **`/git-push` อย่างเดียว ≠ อนุญาต commit**
- ต้องมีคำว่า **ยืนยัน**, **confirm**, **commit and push** ชัดเจน

### ขั้นตอน

| Phase | ทำอะไร |
|-------|--------|
| 1 | Inspect — `status`, `diff`, branch, remote, log |
| 2 | Commit gate — ตาม matrix ใน `reference.md` |
| 3 | Remote & identity — SSH ต้องตรง account ที่มีสิทธิ์ repo |
| 4 | Push |
| 5 | Verify — remote HEAD ตรง |

### Matrix (ย่อ)

| ahead | working tree | การกระทำ |
|-------|--------------|----------|
| 0 | clean | up to date |
| >0 | clean | push อย่างเดียว |
| 0 | dirty | **block** — ต้อง consent commit |
| >0 | dirty | **block** — เลือก push เก่าหรือ commit ก่อน |

### agent-skills repo เฉพาะ

commit เฉพาะ: `ai-skills/`, `ai-rules/`, `scripts/`, `templates/`, `docs/` — **ไม่** commit แค่ junction ใต้ `.cursor/`

ก่อน commit: ตรวจงบ patch ตาม manifest (≤5 ไฟล์ / ≤120 บรรทัด)  
เกินงบ → `[BUDGET-OVERRIDE]` + user approval

---

## 12. vault-daily

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/vault-daily` |
| **บทบาท** | สรุปงานประจำวัน — **1 วัน 1 ไฟล์** `vault/projects/{slug}/daily/YYYY-MM-DD.md` (จาก `template.vault-daily.md` ถ้ายังไม่มี) |

**Iron law:** ห้าม promote ไป `decisions/` / `sessions/` / `projects/` จนกว่า user confirm triage preview

**Handoffs จาก skill อื่น:** `/debug` (จบวัน) · `/builder-feature` (หลัง plan)

รายละเอียด → `ai-skills/vault-daily/SKILL.md` · integration → `vault-capture/reference.md`

---

## 13. vault-capture

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/vault-capture` |
| **บทบาท** | บันทึก episodic / ADR — infer `project` เอง; auto-ensure hub `projects/<slug>/hub.md`; link + backlink + manifest |

dedupe ผ่าน `manifest.json` ก่อนเขียน · hub ensure หลัง session/decision · **ห้าม** copy RCA เต็มจาก `/fix-record` · **ไม่ใช้ Python**

**Handoffs จาก:** `/debug`, `/fix-record`, `/scrutinize`, `/builder-feature`, builder specialist

---

## 14. vault-recall

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/vault-recall` + คำถาม |
| **เวอร์ชัน** | ดู [APPENDIX-TH.md](./APPENDIX-TH.md) §1 |
| **บทบาท** | ค้น memory — manifest + `grep-vault` / per-file Read (ห้าม directory Grep บน gitignored vault) |

**Cheat sheet:** วันที่ → `Read` daily · คำถามเทคนิค → manifest shortlist → `grep-vault.sh --pattern` (macOS) หรือ `grep-vault.ps1` (Windows)

**Handoffs ออก:** `/vault-capture` · `/vault-daily` · `/scrutinize` · `/debug`  
**Handoffs เข้า:** `/fix-record` (ก่อน RCA) · `/scrutinize` (ก่อน architecture verdict) · builder-* (ก่อน breaking change)

---

## สรุป: เลือก skill อย่างไร

```mermaid
flowchart TD
  A[คำถาม/งาน] --> B{มี bug / error?}
  B -->|ใช่| D[/debug]
  B -->|ไม่| C{review PR/plan?}
  C -->|ใช่| S[/scrutinize]
  C -->|ไม่| E{เกี่ยว DB?}
  E -->|ใช่| M[/builder-schema]
  E -->|ไม่| F{ออกแบบระบบ?}
  F -->|UI pixel ถูก token| UC[/builder-ui-cost]
  F -->|UI production| U[/builder-ui]
  F -->|API| P[/builder-api]
  F -->|schema| M[/builder-schema]
  F -->|infra| I[/builder-infrastructure]
  F -->|feature ทั้งก้อน| FE[/builder-feature]
  F -->|ไม่| G{push / ปรับ skill?}
  G -->|push| GP[/git-push]
  G -->|ปรับ skill| UA[/upgrade-ai]
  G -->|จำงาน / สรุปวัน| V[/vault-daily หรือ vault-capture]
  G -->|ถามความจำเก่า| R[/vault-recall]
```

---

---

## ภาคผนวก

- ตารางเวอร์ชัน + `reference.md` ทุกตัว → [APPENDIX-TH.md](./APPENDIX-TH.md)
- Scope Guardrails / SKILL REPORT ร่วม → APPENDIX §3–4

*อัปเดตตาม repo — เวอร์ชัน SSoT ที่ [APPENDIX-TH.md](./APPENDIX-TH.md) §1 เท่านั้น*
