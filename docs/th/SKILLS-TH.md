# คู่มือ Skills (ภาษาไทย)

แต่ละ skill อยู่ใน `ai-skills/<ชื่อ>/SKILL.md` — เรียกในแชทด้วย **`/ชื่อ`** (เช่น `/debug`)

ทุก skill ใน repo นี้ตั้ง **`disable-model-invocation: true`** หมายความว่า agent **ไม่ควร** เปิด skill เองโดยไม่จำเป็น — คุณหรือบริบทงานควรชี้ชัด

---

## สารบัญ

1. [debug](#1-debug)
2. [scrutinize](#2-scrutinize)
4. [builder-ui](#4-builder-ui)
5. [builder-api](#5-builder-api)
6. [builder-schema](#6-builder-schema)
7. [builder-infrastructure](#7-builder-infrastructure)
8. [builder-feature](#8-builder-feature)
9. [fix-record](#9-fix-record)
10. [upgrade-ai](#10-upgrade-ai)
11. [git-push](#11-git-push)
12. [vault-recall](#12-vault-recall)
13. [workday-init](#13-workday-init)
14. [workday-update](#14-workday-update)
15. [workday-review](#15-workday-review)

---

## 1. debug

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/debug` |
| **เวอร์ชัน** | 1.3.1 (ดูใน `SKILL.md`) |
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
| 0 | Vault recall | ค้น `vault/wiki/pages/` และ `vault/issues/` ตาม `vault-recall/reference.md` |
| 1 | Reproduce reliably | สร้างสัญญาณ pass/fail ที่ทำซ้ำได้เร็ว (สคริปต์, test, ขั้นตอนมือ) |
| 2 | Know the fail path | debugger / trace / instrumentation ในโค้ด — รู้ว่า execution ไปทางไหนจนล้ม |
| 3 | Falsify hypothesis | สมมติฐาน 3–5 อันจัดอันดับ — **พยายามพิสูจน์ว่าผิด** ก่อนเชื่ออันใดอันหนึ่ง |
| 4 | Breadcrumb ledger | ทุกการรัน = บันทึก + **ตาราง H1/H2… CONFIRMED/REJECTED/INCONCLUSIVE** พร้อม cite evidence |

**Handoffs:** fix ยืนยันแล้ว → `/fix-record` · review patch → `/scrutinize` · schema/data plan → `/builder-schema`  
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

- `change-control-manifest.mdc` — ลำดับ 9 ขั้น (observe → regression)
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
- review skill/rule ใน agent-skills เอง (version bump, guardrails, vault links)

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
- **PR ของ agent-skills** (เมื่อแตะ skill/rule): bump `metadata.version`, `disable-model-invocation`, SKILL.md ≤~300 บรรทัด, ลิงก์ `vault-recall/reference.md` (ไม่ copy ตารางค้น), แยก issues / workday / fix-record / wiki — ดู checklist เต็มใน [APPENDIX-TH.md](./APPENDIX-TH.md) §5

### ตัวอย่าง

> `/scrutinize` — review PR ที่เพิ่ม endpoint ใหม่

---

## 3. sql (removed)

`/sql` ถูกถอดออกจาก repo นี้แล้ว เนื่องจากใช้งานได้ไม่ดีตาม feedback.

สำหรับงานฐานข้อมูล/สคีมา ให้ใช้:
- `/builder-schema` สำหรับออกแบบ schema, migration strategy, rollback plan
- rules `schema-change-protection` + `production-safety` สำหรับ prod confirmation gates

---

## 4. builder-ui

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-ui` |
| **บทบาท** | สถาปนิก UI — จาก reference (ภาพ/ mock) ไปสู่ component architecture |

### ใช้เมื่อไหร่

- ออกแบบ **frontend architecture**, component tree, design tokens
- มี visual reference (screenshot, Figma export)

### ไม่ใช้เมื่อไหร่

- clone pixel ตาบอดโดยไม่แยก hierarchy
- ยัด business logic ใน presentation layer
- แลก a11y/responsive เพื่อความเร็ว

### ขั้นตอน (7 phase)

1. Visual analysis  
2. Layout reconstruction  
3. Component extraction  
4. Design-system inference  
5. Interaction + state  
6. Accessibility review  
7. Verification (checklist pass/reject)

### ผลลัพธ์

- UI Analysis, Component Architecture, Design System
- Responsive Plan, Verification Plan

รายละเอียด checklist → `ai-skills/builder-ui/reference.md`

---

## 5. builder-api

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-api` |
| **บทบาท** | สถาปนิก API — domain ก่อน endpoint |

### ใช้เมื่อไหร่

- ออกแบบ/ refactor **API contract**, routes, service boundaries
- ต้องการ validation, auth, error model, observability

### ขั้นตอน (10 phase)

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

### ไม่ใช้เมื่อไหร่

- เริ่มจาก “สร้างตาราง” โดยไม่รู้ domain
- over-index ก่อนรู้ query pattern

### ขั้นตอน (10 phase)

Domain → Entity → Relationships → Normalization → Query patterns → Indexing → Integrity → Scale → Evolution → Verification

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

### ไม่ใช้เมื่อไหร่

- เริ่มจาก “จอง server” โดยไม่รู้ workload/SLO
- ผูก environment แน่นเกินไป

### ขั้นตอน (9 phase)

Workload & SLO → Boundaries → Deploy → Compute/network → Secrets → Observability → Reliability → Scale/cost → IaC + verify

---

## 8. builder-feature

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/builder-feature` |
| **Version** | 1.5.0 |
| **บทบาท** | **Plan-only orchestrator** — วาง flow + slice backlog **ไม่เขียนโค้ด** |

### ใช้เมื่อไหร่

- วางแผน **feature ข้าม layer** (UI + API + schema + infra)
- วางแผน **UI mock / static HTML** ผ่าน **express lane** (workflow สั้น + slice backlog)

### ไม่ใช้เมื่อไหร่

- implement เองใน skill นี้ (รวม HTML/CSS)
- บั๊กจุดเดียว → `/debug`
- layer เดียวพร้อม implement → `/builder-ui` ฯลฯ โดยตรง

### โหมด

| โหมด | ผลลัพธ์ |
|------|---------|
| **PLAN** | Phase 0–7 + slice backlog → `PLAN_READY` |
| **Express** | UI-only mock — workflow map ≥3 ขั้น + component outline + slice backlog |
| **Handoff** | Slice brief → `/builder-ui` · `/builder-api` · … |

### ขั้นตอน (plan)

0. Discovery (scope, non-goals, UI-only vs cross-layer)  
1. **Workflow map** (บังคับก่อน slice backlog)  
2–6. Reuse, boundaries, integration, rollout (express lane: defer N/A ได้)  
7. Plan verification  
→ Slice backlog → **`PLAN_READY`** → optional save [`template.feature-plan.md`](../templates/template.feature-plan.md) → user สั่ง **`/builder-ui slice N go`** ([`template.slice-brief.md`](../templates/template.slice-brief.md))

### ผลลัพธ์

- Workflow map, Orchestration plan, **Slice backlog table**, Slice N brief  
- **ไม่มี** diff ใน repo จาก skill นี้

### Smoke

- Scenario **#10** ใน [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) — plan-only ห้าม patch

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
- แทน wiki page สั้นใน vault (คนละ artifact — ใช้ `/wiki-ingest`)
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

### ความต่างจาก vault

| Artifact | ที่เก็บ | ใช้เมื่อ |
|----------|---------|----------|
| `vault/issues/` | บันทึกรายวัน Q&A | ทำงานประจำวัน |
| `vault/wiki/pages/` | ความรู้ระยะยาว (concept) | `/wiki-ingest` |
| fix-record | RCA เต็ม | ส่งทีม / JIRA / PR |

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

1. Reproduce (รวม vault search ถ้าเป็น agent-skills)  
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
| 0 | Vault recall ถ้า push เคยติด / git friction |
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

ก่อน commit: `./scripts/change-control-check.sh`  
เกินงบ 5 ไฟล์ / 120 บรรทัด → `[BUDGET-OVERRIDE]` + user approval

---

## 12. vault-recall

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/vault-recall` |
| **บทบาท** | บรรณารักษ์ vault — **ค้น** wiki/issues ไม่เขียน |

### ใช้เมื่อไหร่

- “ค้น vault”, “เคยเจออาการนี้ไหม”
- ก่อน debug ยาว หรือ git friction ซ้ำ

### ไม่ใช้เมื่อไหร่

- เขียน issues (ใช้ rule `vault-issues.mdc`) หรือ wiki (ใช้ `/wiki-ingest`)
- อ่าน wiki page เกิน 3 ไฟล์เต็มต่อการค้นหา
- ทุกข้อความแชทสบายๆ

### ขั้นตอน

1. ทำตาม `vault-recall/reference.md` (resolve root → grep wiki/pages → issues)  
2. รายงาน: สรุป, top 3 matches, ถ้าว่างแนะนำ `/wiki-ingest` หลังปิดเรื่อง

### ถูกเรียกแบบ inline

- `/debug` phase 0  
- `/git-push` phase 0  
- ไม่จำเป็นต้องพิมพ์ `/vault-recall` แยกถ้า skill อื่นรันอยู่แล้ว

---

## 13. workday-init

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/workday-init` |
| **บทบาท** | วางแผนงานรายวัน — แปลงความตั้งใจดิบเป็นแผนที่ทำได้ทันที |

### ใช้เมื่อไหร่

- เริ่มวัน — มี bullet, note, ความคิดกระจัดกระจาย
- ต้องการจัดกลุ่มงานตาม domain: **API · WEB · SKILL · DOCS · OPS**

### ไม่ใช้เมื่อไหร่

- งานเพิ่มกลางวัน → `/workday-update`
- สรุปท้ายวัน → `/workday-review`
- ลงมือ implement → ใช้ `/builder-*`

### ผลลัพธ์ — บล็อก WORKDAY

รูปแบบมาตรฐาน: `templates/template.workday.md`

```
WORKDAY → DATE · MISSION · ACTIVE TASKS · PROGRESS · PROBLEMS
       · DISCOVERED TODAY · NEXT · EVIDENCE · DAY SCORE
```

**init กรอก:** DATE, MISSION, ACTIVE TASKS, PROBLEMS, NEXT, DAY SCORE  
**ไฟล์ (บังคับ):** `vault/workday/YYYY-MM-DD.md` — ไม่ใช่ `issues/`  
**Task ID:** `{DOMAIN}-{NNN}` เช่น `API-001`, `WEB-002`

**กฎ:** ไม่เขียนโค้ด · PROGRESS/EVIDENCE ว่าง (`—`) จนกว่าจะ review

---

## 14. workday-update

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/workday-update` |
| **บทบาท** | อัปเดตแผนกลางวัน — งานใหม่, bug, client request |

### ใช้เมื่อไหร่

- พบ bug, scope change, refactor ระหว่างทำ
- ต้องเปลี่ยน priority หรือ dependency

### ไม่ใช้เมื่อไหร่

- ยังไม่มีแผนเช้า → `/workday-init` ก่อน
- สรุปท้ายวัน → `/workday-review`

### ผลลัพธ์ — WORKDAY ฉบับอัปเดต (เต็มบล็อก)

**update เปลี่ยน:** DISCOVERED TODAY, ACTIVE TASKS, PROBLEMS, NEXT · overwrite ไฟล์เดิม + bump `plan_version`  
**ไฟล์:** อัปเดต `vault/workday/YYYY-MM-DD.md` (bump `plan_version`)

**กฎ:** ห้าม task ซ้ำ · ทุก discovery มี source + reason · ไม่ `[x]` โดยไม่มี evidence review

---

## 15. workday-review

| รายการ | ค่า |
|--------|-----|
| **Invoke** | `/workday-review` |
| **บทบาท** | audit ท้ายวันจาก **git + codebase** เทียบแผนเช้า |

### ใช้เมื่อไหร่

- ปิดวัน — ต้องการรู้ว่าทำอะไรจริง vs แผน
- เตรียม input ให้ `/workday-init` พรุ่งนี้

### หลักฐาน (ลำดับความสำคัญ)

1. Codebase 2. Git 3. แผนรายวัน 4. User notes 5. Conversation

**ห้าม** mark complete จากแค่บทสนทนา — ต้อง cite file/commit/test

### ผลลัพธ์ — WORKDAY ปิดวัน (เต็มบล็อก)

**review กรอก:** PROGRESS, EVIDENCE, DAY SCORE · `status: closed` ใน frontmatter  
**ไฟล์:** `vault/workday/YYYY-MM-DD.md`

รายละเอียด → `workday-review/reference.md` · template → `templates/template.workday.md`

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
  F -->|UI| U[/builder-ui]
  F -->|API| P[/builder-api]
  F -->|schema| M[/builder-schema]
  F -->|infra| I[/builder-infrastructure]
  F -->|feature ทั้งก้อน| FE[/builder-feature]
  F -->|ไม่| G{push / ปรับ skill?}
  G -->|push| GP[/git-push]
  G -->|ปรับ skill| UA[/upgrade-ai]
  G -->|ค้นอดีต| VR[/vault-recall]
  A --> WI{วางแผนวัน?}
  WI -->|เริ่มวัน| WDI[/workday-init]
  WI -->|กลางวัน| WDU[/workday-update]
  WI -->|ท้ายวัน| WDR[/workday-review]
```

---

---

## ภาคผนวก

- ตารางเวอร์ชัน + `reference.md` ทุกตัว → [APPENDIX-TH.md](./APPENDIX-TH.md)
- Scope Guardrails / SKILL REPORT ร่วม → APPENDIX §3–4

*อัปเดตตาม repo หลัง change-control rollout — เวอร์ชันล่าสุดดูใน APPENDIX §1 หรือแต่ละ `SKILL.md`*
