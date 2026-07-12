# คู่มือ Rules (ภาษาไทย)

Rules อยู่ใน `ai-rules/**/*.mdc` — Cursor โหลดเข้า context ตาม:

| วิธีโหลด | ความหมาย |
|----------|----------|
| **`alwaysApply: true`** | ทุก turn ใน workspace (กิน token ตลอด) |
| **`globs`** | เมื่อแตะไฟล์ที่ path ตรง pattern |
| **intelligent** | Cursor เลือกเมื่อคำอธิบาย rule ตรงงาน (ไม่มี glob) |

**รวม 33 ไฟล์** — **3** always-on, **1** activation map (`_index.mdc`), **24** glob-scoped, **5** intelligent (on-request)

---

## สารบัญ

- [Always-on (3)](#always-on-โหลดทุก-turn)
- [Activation map](#activation-map-_indexmdc)
- [core/](#โฟลเดอร์-core)
- [debugging/](#โฟลเดอร์-debugging)
- [patching/](#โฟลเดอร์-patching)
- [architecture/](#โฟลเดอร์-architecture)
- [testing/](#โฟลเดอร์-testing)
- [risk/](#โฟลเดอร์-risk)
- [workflow/](#โฟลเดอร์-workflow)

---

## Always-on (โหลดทุก turn)

### `change-control-manifest.mdc`

| | |
|--|--|
| **ไฟล์** | `ai-rules/change-control-manifest.mdc` |
| **โหลด** | alwaysApply |

**จุดประสงค์:** กำหนดให้ agent เป็น **ระบบ change-control** ไม่ใช่แค่ “พิมพ์โค้ดเร็ว”

**ลำดับ 10 ขั้น (ห้ามข้าม เมื่อจะ patch):**

1. Observe — สังเกตอาการ  
2. Reproduce — ทำซ้ำได้หรือพิสูจน์ว่าทำไม่ได้  
3. Isolate — แคบขอบเขต  
4. Diagnose — วินิจฉัยด้วยหลักฐาน  
5. Disprove alternatives — หักล้างทางเลือก  
6. Assess impact & risk  
7. Propose minimal patch  
8. **Verify** — IDENTIFY → RUN → READ ก่อน claim เสร็จ  
9. **Vault autolog** — หลัง verified patch ต้อง append daily (`vault-autolog.mdc`)  
10. Regression check — ถ้า patch redirect caller ให้ grep symbol เก่า (`callee-redirect-cleanup.mdc`)

**Verify gate:** ระบุคำสั่งพิสูจน์ → รัน → อ่านผลจริง · ห้าม “should work” / READY โดยไม่มีหลักฐาน

**Work type (ย่อ):** Ask/explain → ตอบตรง (ข้าม 1–10) · copy/UI ชัด → patch→verify→autolog · บั๊กไม่ชัด → debug · **ยังพัง/retry → Attempt ledger** (ด้านล่าง) · ไม่แน่ใจ → ถาม bug vs copy?

**Attempt ledger (ตอน retry เท่านั้น):**  
1. `Read`/`Write` `vault/sessions/attempt-<slug>.md` จาก [`template.attempt-ledger.md`](../../templates/vault/notes/template.attempt-ledger.md)  
2. ตาราง ≤5 แถวในไฟล์ + ในแชท · `Read` ซอร์สจริง · ห้าม patch/โค้ดเดิมที่ fail แล้ว  
3. optional: `append-daily.ps1 -Issue "retry: …"`

**งบ patch ค่าเริ่มต้น:**

| จำกัด | ค่า |
|--------|-----|
| ไฟล์สูงสุด | 5 |
| บรรทัด (add+del) | 120 |

เกิน → อธิบายในแชท หรือแยกงาน / `[BUDGET-OVERRIDE]` + user ยืนยัน

**ความมั่นใจ (confidence):**

| Confidence | ความเสี่ยง | การกระทำ |
|------------|------------|----------|
| ≥ 0.9 | LOW | patch เฉพาะจุดได้ |
| 0.7 – 0.89 | ใดก็ได้ | เสนอ patch — ควรให้ user review |
| < 0.7 | ใดก็ได้ | **วินิจฉัยอย่างเดียว** — ห้าม patch |

**จับคู่ skill:**

| สถานการณ์ | Skill |
|-----------|--------|
| bug | `/debug` |
| review PR | `/scrutinize` |
| UI / mock | `/builder-ui` |
| API / backend | `/builder-api` |
| DB | `/builder-schema` |
| infra / CI | `/builder-infrastructure` |
| git | `/git-push` |
| ปรับ skill | `/upgrade-ai` |
| RCA ยาว | `/fix-record` |
| vault | `/vault-capture` · `/vault-recall` · `/vault-daily` |

**Active skill precedence:** เมื่อ skill มี iron law (เช่น `/builder-feature` plan-only) — **override** ขั้น 7–8 ของลำดับ

**Scoped vs meta:** patching/testing/debugging rules ใช้ application-source globs — ไม่ trigger จากแก้ `ai-skills/` / `ai-rules/` / `docs/` อย่างเดียว

**ห้ามใน production:** fix เดา, refactor ปน bugfix, เปลี่ยน API/schema แอบ, ทำลาย schema โดยไม่มีแผน, **ยัดโค้ด/patch เดิมที่ fail ในเทรดนี้**, ข้าม Attempt ledger ตอน retry

---

### `bilingual-th-en.mdc`

| | |
|--|--|
| **โหลด** | alwaysApply |

**จุดประสงค์:** คำตอบในแชทผสม **ไทย ~60%** + **English ~40%**

- ไทย: อธิบายหลัก, ขั้นตอน, สรุป  
- English: คำศัพท์เทคนิค, ชื่อ command, error, ชื่อไฟล์  
- **ห้าม** เขียนย่อหน้าไทยเต็มแล้วตามด้วยย่อหน้าอังกฤษเต็มซ้ำ  
- code block คงภาษาเดิม (มักเป็น English)

**ข้อยกเว้น:** user ขอภาษาเดียว; ข้อความ quote จาก log/UI

---

### `workflow/vault-autolog.mdc`

| | |
|--|--|
| **ไฟล์** | `ai-rules/workflow/vault-autolog.mdc` |
| **โหลด** | alwaysApply |

**จุดประสงค์:** หลัง patch ที่ verify แล้ว — append bullet ลง `vault/daily/YYYY-MM-DD.md` อัตโนมัติ (ผ่าน `scripts/vault/append-daily.ps1` / `.sh`)

**Iron law:** ตอบ user ต้องมีบรรทัด `Vault daily:` — `updated vault/daily/...` หรือ `skipped — <reason>`

**ข้ามได้เมื่อ:** read-only, plan-only/review-only iron law, user บอก skip, copy บรรทัดเดียวไม่มีคุณค่า durable

**Path:** parent workspace → `agent-skills/vault/` หรือ `.cursor/vault/` junction; pack root → `vault/`

---

### `clean-code.mdc` (ไม่ใช่ always-on)

| | |
|--|--|
| **โหลด** | **globs** — app source `**/*.{ts,tsx,js,jsx,html,css,py,go,…}` (Tier 1) |

**จุดประสงค์:** baseline **โค้ดแอป** ที่ AI สร้าง/แก้ — โหลดเมื่อแตะไฟล์แอป ไม่กิน token ทุก turn

**หลัก 8 ข้อ (ย่อ):**

1. ขอบเขตเล็ก — แก้เท่าที่จำเป็น  
2. ตั้งชื่อชัด  
3. ฟังก์ชันไม่ปนงาน  
4. ไม่ copy logic ซ้ำโดยไม่จำเป็น  
5. จัดการ error ชัด — ไม่กลืนเงียบ  
6. อย่าเปลี่ยน behavior นอก scope  
7. มี test/verify เมื่อ behavior เปลี่ยน  
8. ไม่ทิ้ง dead code — **ยกเว้น redirect:** ถ้า turn นี้เปลี่ยน caller (a1→a2) ให้ grep a1 แล้วลบถ้าไม่มี reference เหลือ (ดู `patching/callee-redirect-cleanup.mdc`)

**ก่อนจบ turn:** บอกว่ารัน lint/test อะไรแล้ว / อะไรยังไม่ได้รัน

**ต่างจาก `minimal-change`:** clean-code = สไตล์และคุณภาพโค้ด; minimal-change = **ขอบเขต** patch

---

## Activation map (`_index.mdc`)

| | |
|--|--|
| **ไฟล์** | `ai-rules/_index.mdc` |
| **โหลด** | intelligent (on request) — **ไม่** always-on |

**จุดประสงค์:** แผนที่ tier 0–3 — always-on vs scoped vs on-request vs skill invoke

- Tier 0: manifest, bilingual, vault-autolog (**3**)  
- Tier 1: `clean-code.mdc` + `core/`, `debugging/`, `patching/`, … (globs)  
- Tier 2: risk, stop-conditions, uncertainty-control  
- Tier 3: depth ใน skill `reference.md`

Spine: [ARCHITECTURE.md](../../ARCHITECTURE.md) · EN: [_index.mdc](../../ai-rules/_index.mdc)

---

## โฟลเดอร์ `core/`

### `core/diagnosis-first.mdc`

| globs | ไฟล์โค้ดหลายภาษา (ดูในไฟล์) |

**ก่อนแก้โค้ด ต้องระบุ:**

- พฤติกรรมที่พัง vs ที่คาด  
- layer ที่ได้รับผล  
- execution path  
- หลักฐาน root cause  

**ห้าม** patch สาเหตุที่ยังเป็นเดา — ถ้าไม่มีหลักฐาน ให้เก็บหรือถาม

---

### `core/uncertainty-control.mdc`

| โหลด | intelligent (ไม่มี glob) |

**หยุดและถามเมื่อ:**

- สาเหตุหลายอันน่าเชื่อเท่ากัน  
- ดู runtime ไม่ได้  
- context สำคัญขาด  
- confidence < 0.7  
- blast radius ไม่รู้  

**เลือก:** turn วินิจฉัยอย่างเดียว ดีกว่า patch เสี่ยง

---

### `core/minimal-change.mdc`

| globs | application-source bundle (APPENDIX §9) |

**แก้เฉพาะสิ่งที่ root cause พิสูจน์แล้วต้องการ**  
**ห้าม** ปน refactor, cleanup, optimize, feature ใน patch เดียว  
อ้างงบ patch ใน manifest

---

### `core/verification-required.mdc`

| globs | application-source bundle (APPENDIX §9) |

**ก่อนบอกว่า “เสร็จ”:**

- บอกผลที่คาดหลัง patch  
- รันหรืออธิบายวิธี verify  
- บอกสิ่งที่ **ยังไม่ได้** รัน  
- ระบุ regression risk  

ถ้า verify ไม่ได้ → พูดตรงๆ อย่าแกล้งว่าพิสูจน์แล้ว

---

## โฟลเดอร์ `debugging/`

ชุดนี้เสริม `/debug` — เปิดเมื่อแก้ bug (application-source bundle — APPENDIX §9)

### `debugging/reproduce-before-fix.mdc`

**ห้าม** bugfix patch จน repro นิ่ง หรือจนเขียนชัดว่าทำ repro ไม่ได้เพราะอะไร + ต้องการ artifact อะไร

### `debugging/root-cause-proof.mdc`

Root cause ต้องอธิบายอาการครบ path — อ้าง log, stack, branch, state  
ถ้ายังเป็น hypothesis → ติดป้ายและหักล้างก่อน

### `debugging/disprove-alternatives.mdc`

แต่ละสมมติฐาน: มีทางเลือกอื่น, ทำไมทางเลือกนั้นน้อยกว่า (มีหลักฐาน), อะไรจะพิสูจน์ว่าสมมติฐานหลักผิด  
**ห้าม** ยึดไอเดียแรกที่ “น่าจะใช่”

### `debugging/evidence-based-debugging.mdc`

ใช้ log, stack, debugger, repro script — **หลีกเลี่ยง** “น่าจะ”, “มักจะ” โดยไม่มี observation ใน session  
อัปเดต debug ledger หลังทุก experiment

### `debugging/regression-analysis.mdc`

หลัง patch ระบุ: caller ที่กระทบ, shared module, edge case, ถ้า fix ผิดจะลามอย่างไร — ก่อนปิดว่า fixed

---

## โฟลเดอร์ `patching/`

### `patching/patch-scope-control.mdc`

| globs | ไฟล์ source หลายประเภท |

แก้เฉพาะไฟล์บน **fail path**, dependency chain ที่พิสูจน์, หรือ contract ที่กระทบ  
แตะ >5 ไฟล์ → แต่ละไฟล์ต้อง justify หรือแยก PR

### `patching/patch-size-limits.mdc`

| globs | application-source bundle (APPENDIX §9) |

ชอบ fix แคบ: condition, guard, wrapper  
**ห้าม** ปน refactor/cleanup/feature กับ bugfix — งบ 120 บรรทัด / 5 ไฟล์  
**ยกเว้น:** ลบ symbol ที่ orphan จาก callee redirect ใน turn เดียวกัน (`callee-redirect-cleanup.mdc`)

### `patching/no-hidden-side-effects.mdc`

| globs | application-source bundle (APPENDIX §9) |

**ห้ามโดยไม่บอก user:** fallback เงียบ, catch กว้างกลืน error, เปลี่ยน default/flag, แก้แค่ log ให้ error หายจาก UI

### `patching/dependency-impact.mdc`

ก่อนแก้ module ที่คนอื่น import: รายชื่อ dependent, public API ที่ใช้, ชอบแก้ local มากกว่าเปลี่ยน shared

### `patching/safe-edit-order.mdc`

ลำดับ: repro/test fail → fix เล็กสุด → verify → regression เป้า → **callee redirect cleanup** → cleanup กว้าง **แยก patch**  
**ห้าม** “เก็บความสะอาดก่อน” ตอน incident

### `patching/callee-redirect-cleanup.mdc`

| globs | ไฟล์ source หลายประเภท |

เมื่อ patch **เปลี่ยนสิ่งที่ caller เรียก** (เช่น a เรียก a1 → a2):

1. grep symbol เก่า (a1, import เก่า)
2. **ไม่มี caller เหลือ** → ลบ definition ใน **patch เดียวกัน** (อยู่ในงบ)
3. **ยังมี caller อื่น** → อย่าลบ · บอกใน reply
4. ลบเกินงบ → ใส่ NEXT ACTIONS อย่าปล่อยค้างเงียบ

**ไม่รวม:** cleanup ทั้ง repo / dead code ที่ไม่ได้ orphan ใน turn นี้

---


## โฟลเดอร์ `architecture/`

### `architecture/architecture-boundaries.mdc`

| globs | `**/*.{ts,tsx,js,jsx,py,go}` |

แยกชั้น: UI = presentation, API = transport/validation, domain = business rules, infra = I/O  
โค้ดใหม่อยู่ชั้นถูก — ข้ามชั้นต้อง justify

### `architecture/api-contract-safety.mdc`

| globs | `**/api/**`, `**/routes/**`, controllers, handlers, … |

**ห้าม** เปลี่ยน request/response, status semantics, ความหมาย field โดยไม่ approve  
ออกแบบ contract ใหม่ → `/builder-api`

### `architecture/shared-module-protection.mdc`

| globs | `**/shared/**`, `common`, `lib`, `utils`, `core`, … |

แก้ shared = **ความเสี่ยงสูง** — หา dependent ก่อน, ชอบแก้ที่ call site

### `architecture/schema-change-protection.mdc`

| globs | migrations, schema, prisma, … |

ต้องมีแผน migrate, rollback, compatibility, data safety  
**ห้าม** destructive schema อัตโนมัติ — ใช้ `/builder-schema` วางแผน migrate/rollback และยืนยัน prod ชัดเจนก่อน execute

---

## โฟลเดอร์ `testing/`

### `testing/mandatory-validation.mdc`

| globs | application-source bundle (APPENDIX §9) |

ไม่บอก “เสร็จ” โดยไม่มี expected outcome, ขั้น verify, พิจารณา flow ที่ไม่ได้แตะ, ช่องว่างถ้าไม่รัน test

### `testing/regression-test-policy.mdc`

| globs | `**/*.{test,spec}.{ts,tsx,js,jsx,py,go}` |

behavior เปลี่ยน → เพิ่ม/อัปเดต test ถ้ามี harness หรือเขียน manual regression  
ชอบ test ที่ lock repro ไม่ใช่ implementation detail

### `testing/unsafe-untested-change.mdc`

| globs | application-source bundle (APPENDIX §9) |

HIGH risk ต้องมี automated test **หรือ** manual steps ชัด — ไม่งั้นติดป้าย **unsafe** ห้ามอ้าง production-ready

### `testing/manual-test-flows.mdc`

| globs | application-source bundle (APPENDIX §9) |

ไม่มี CI: ให้ขั้นมือแบบ copy-paste ได้ — setup, action, expected, negative case

---

## โฟลเดอร์ `risk/`

### `risk/risk-classification.mdc`

| โหลด | intelligent |

| ระดับ | ตัวอย่าง |
|--------|----------|
| LOW | typo, copy, logging, comment, null guard แคบมี proof |
| MEDIUM | validation, query logic, mapping, state, config |
| HIGH | auth, payments, concurrency, infra, schema, security, public API break |

**ต้องพูดระดับในแชทก่อน patch** — HIGH มักต้อง approval (ตารางเต็ม → [APPENDIX-TH.md](./APPENDIX-TH.md) §10)

### `risk/approval-gates.mdc`

ต้อง user approve ก่อน: HIGH risk, prod migration, auth/security, destructive ops, IAM/infra, public API break  
`/git-push` อย่างเดียว ≠ consent commit

### `risk/production-safety.mdc`

| globs | `.env*`, deploy, infra, prod, k8s, terraform, … |

ห้าม commit secret, เขียน prod โดยไม่ยืนยัน environment, destructive โดยไม่ approve  
สืบ read-only ก่อน — SQL/infra ใช้ skill ที่มี gate

### `risk/rollback-awareness.mdc`

ก่อน MEDIUM/HIGH patch: วิธี revert (git revert, flag, migration down), partial failure, ผลต่อ data

---

## โฟลเดอร์ `workflow/`

### `workflow/vault-autolog.mdc`

| โหลด | alwaysApply — ดู [Always-on](#always-on-โหลดทุก-turn) |

### `workflow/stop-conditions.mdc`

| โหลด | intelligent |

**หยุดถาม user** เมื่อ: สาเหตุพิสูจน์ไม่ได้, ต้อง rewrite สถาปัตยกรรม, หลาย domain ไม่ตกลง scope, runtime ขัดกับ assumption, regression ไม่รู้, เกินงบ patch  
**ห้าม** ทำต่อเงียบๆ

---

## ตารางสรุป: Always-on vs Scoped

| ประเภท | จำนวน | Token | เมื่อไหร่มีผล |
|--------|------:|-------|----------------|
| Always-on | **3** | ทุก turn | manifest, bilingual-th-en, vault-autolog |
| Activation map | **1** | on request | `_index.mdc` |
| Glob-scoped | **24** | เมื่อแตะไฟล์ตรง glob | รวม `clean-code` + core/debugging/patching/… |
| Intelligent | **5** | agent เลือกตาม description | risk/* (3), stop-conditions, uncertainty-control |

---

## ความสัมพันธ์ 4 ชั้น

```
Spine (ARCHITECTURE.md)  →  Rules  →  Skills  →  Setup scripts
        ↑                      ↑           ↑              ↑
   SSoT map              ai-rules/   ai-skills/    setup-*
```

รายละเอียด EN: [CHANGE-CONTROL.md](../CHANGE-CONTROL.md) · [ARCHITECTURE.md](../../ARCHITECTURE.md)

---

## ภาคผนวก

- ตาราง **globs** → [APPENDIX-TH.md](./APPENDIX-TH.md) §9  
- setup scripts / patch budget → APPENDIX §8  

*อัปเดตตาม tree 33 ไฟล์ `.mdc` — ตัด `execution-model`, `decision-tree`, `response-format` (ซ้ำ/ritual) แล้ว · ถ้าเพิ่ม rule ให้อัปเดต RULES-TH + APPENDIX §9*
