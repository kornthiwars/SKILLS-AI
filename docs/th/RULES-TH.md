# คู่มือ Rules (ภาษาไทย)

Rules อยู่ใน `ai-rules/**/*.mdc` — Cursor โหลดเข้า context ตาม:

| วิธีโหลด | ความหมาย |
|----------|----------|
| **`alwaysApply: true`** | ทุก turn ใน workspace (กิน token ตลอด) |
| **`globs`** | เมื่อแตะไฟล์ที่ path ตรง pattern |
| **intelligent** | Cursor เลือกเมื่อคำอธิบาย rule ตรงงาน (ไม่มี glob) |

**รวม 34 ไฟล์** — 4 ตัว always-on, 30 ตัว scoped

---

## สารบัญ

- [Always-on (4)](#always-on-โหลดทุก-turn)
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

**ลำดับ 9 ขั้น (ห้ามข้าม):**

1. Observe — สังเกตอาการ  
2. Reproduce — ทำซ้ำได้หรือพิสูจน์ว่าทำไม่ได้  
3. Isolate — แคบขอบเขต  
4. Diagnose — วินิจฉัยด้วยหลักฐาน  
5. Disprove alternatives — หักล้างทางเลือก  
6. Assess impact & risk  
7. Propose minimal patch  
8. Verify  
9. Regression check — ถ้า patch redirect caller ให้ grep symbol เก่า (`callee-redirect-cleanup.mdc`)

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
| DB | `/builder-schema` |
| git | `/git-push` |
| ค้น vault | `/vault-recall` |
| ปรับ skill | `/upgrade-ai` |
| RCA ยาว | `/fix-record` |

**ห้ามใน production:** fix เดา, refactor ปน bugfix, เปลี่ยน API/schema แอบ, ทำลาย schema โดยไม่มีแผน

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

**ข้อยกเว้น:** user ขอภาษาเดียว; ข้อความ quote จาก log/UI; ไฟล์ vault (metadata ภาษาอังกฤษ)

---

### `vault-issues.mdc`

| | |
|--|--|
| **โหลด** | alwaysApply |

**จุดประสงค์:** นโยบาย **เขียน vault** (Obsidian) — แยก issues · workday · wiki

**ที่เก็บ:**

| โฟลเดอร์ | ใช้ทำอะไร |
|----------|-----------|
| `vault/issues/YYYY-MM-DD.md` | บันทึกงานรายวัน — หัวข้อ `## N.` + Question/Answer |
| `vault/workday/YYYY-MM-DD.md` | แผน WORKDAY — skills `workday-init` · update · review |
| `vault/workday/plans/{slug}.md` | แผน feature จาก `/builder-feature` (opt-in persist) — gitignored |
| `vault/wiki/pages/{slug}.md` | ความรู้ถาวร — **`/wiki-ingest`** เท่านั้น |

**เมื่อเขียน issues:** หลังจบงานจริง (code, git, skill, debug) — **ไม่** log ทุกแชท

**เมื่อเขียน wiki:** ผ่าน **`/wiki-ingest`** เมื่อปิดเรื่องแล้ว + คุ้มค้นหาซ้ำ / mechanism ซับซ้อน / user ขอเก็บ wiki

**Resolve vault root (4 ขั้น):** `ai-skills-vault.json` → `.cursor/vault/` → `vault/` → โฟลเดอร์ที่มี `ai-skills/` + setup script

**ก่อน debug/git ติด:** ค้นตาม `vault-recall/reference.md` (ลำดับ wiki/pages ≤3 ไฟล์ → **workday/plans/** เมื่อ query ชื่อ feature/plan → issues วันนี้/เมื่อวาน) — รายละเอียด [APPENDIX-TH.md](./APPENDIX-TH.md) §7

**Wiki page:** Summary, Key points, Related — template `templates/template.wiki-page.md`

**ภาษาใน vault:** เนื้อหาไทยหรืออังกฤษได้; `tags`, `title`, `symptoms` ใช้ **English**

---

### `clean-code.mdc`

| | |
|--|--|
| **โหลด** | alwaysApply |

**จุดประสงค์:** baseline **โค้ดแอป** ที่ AI สร้าง/แก้ (ไม่ใช่กฎเขียน skill)

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

## โฟลเดอร์ `core/`

### `core/execution-model.mdc`

| globs | `**/*.{ts,tsx,js,jsx,py,go,rs,java,kt,cs,php,rb,sql,vue,svelte}` |
|-------|---------------------------------------------------------------------|

**ทำอะไร:** บังคับลำดับ 9 ขั้นจาก manifest — **ห้าม** ข้ามไป patch ก่อนขั้น 1–6 พอ  
**bug:** ใช้ `/debug` แทน invent กระบวนการสั้นเอง

---

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

| globs | `**/*` |

**แก้เฉพาะสิ่งที่ root cause พิสูจน์แล้วต้องการ**  
**ห้าม** ปน refactor, cleanup, optimize, feature ใน patch เดียว  
อ้างงบ patch ใน manifest

---

### `core/verification-required.mdc`

| globs | `**/*` |

**ก่อนบอกว่า “เสร็จ”:**

- บอกผลที่คาดหลัง patch  
- รันหรืออธิบายวิธี verify  
- บอกสิ่งที่ **ยังไม่ได้** รัน  
- ระบุ regression risk  

ถ้า verify ไม่ได้ → พูดตรงๆ อย่าแกล้งว่าพิสูจน์แล้ว

---

## โฟลเดอร์ `debugging/`

ชุดนี้เสริม `/debug` — เปิดเมื่อแก้ bug (มัก glob `**/*`)

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

| globs | `**/*` |

ชอบ fix แคบ: condition, guard, wrapper  
**ห้าม** ปน refactor/cleanup/feature กับ bugfix — งบ 120 บรรทัด / 5 ไฟล์  
**ยกเว้น:** ลบ symbol ที่ orphan จาก callee redirect ใน turn เดียวกัน (`callee-redirect-cleanup.mdc`)

### `patching/no-hidden-side-effects.mdc`

| globs | `**/*` |

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

| globs | `**/*` |

ไม่บอก “เสร็จ” โดยไม่มี expected outcome, ขั้น verify, พิจารณา flow ที่ไม่ได้แตะ, ช่องว่างถ้าไม่รัน test

### `testing/regression-test-policy.mdc`

| globs | `**/*.{test,spec}.{ts,tsx,js,jsx,py,go}` |

behavior เปลี่ยน → เพิ่ม/อัปเดต test ถ้ามี harness หรือเขียน manual regression  
ชอบ test ที่ lock repro ไม่ใช่ implementation detail

### `testing/unsafe-untested-change.mdc`

| globs | `**/*` |

HIGH risk ต้องมี automated test **หรือ** manual steps ชัด — ไม่งั้นติดป้าย **unsafe** ห้ามอ้าง production-ready

### `testing/manual-test-flows.mdc`

| globs | `**/*` |

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

### `workflow/decision-tree.mdc`

| โหลด | intelligent |

แผนที่ intent → skill (ดูตารางใน manifest)  
หลายอย่างพร้อมกัน: **recall → diagnose → patch → verify → git-push**

### `workflow/response-format.mdc`

| โหลด | intelligent |

ก่อนเสนอ patch ควรมี 8 ส่วน: อาการ, สมมติฐาย/สาเหตุ, หลักฐาน, ทางเลือกอื่น, impact, patch, แผน validate, regression risk  
ข้ามได้เฉพาะ one-liner LOW risk ที่ user ขอชัด

### `workflow/stop-conditions.mdc`

| โหลด | intelligent |

**หยุดถาม user** เมื่อ: สาเหตุพิสูจน์ไม่ได้, ต้อง rewrite สถาปัตยกรรม, หลาย domain ไม่ตกลง scope, runtime ขัดกับ assumption, regression ไม่รู้, เกินงบ patch  
**ห้าม** ทำต่อเงียบๆ

---

## ตารางสรุป: Always-on vs Scoped

| ประเภท | จำนวน | Token | เมื่อไหร่มีผล |
|--------|------:|-------|----------------|
| Always-on | 4 | ทุก turn (~300 บรรทัดรวม) | ทุกคำถาม |
| Scoped | 30 | เมื่อ glob/intelligent ติด | แก้โค้ด / review / risk สูง |

---

## ความสัมพันธ์ 3 ชั้น

```
Rules (สั้น, บังคับ)  →  Skills (ลึก, invoke)  →  Scripts/CI (ตรวจอัตโนมัติ)
     ↑                        ↑                           ↑
  ai-rules/              ai-skills/                  smoke-skills.sh
```

---

## คำสั่งตรวจว่า rules ยังครบ

```bash
./scripts/smoke-skills.sh
```

---

---

## ภาคผนวก

- ตาราง **globs ครบ 30 scoped rules** → [APPENDIX-TH.md](./APPENDIX-TH.md) §9  
- smoke / change-control-check / CI → APPENDIX §8  

*อัปเดตตาม tree 34 ไฟล์ `.mdc` — ถ้าเพิ่ม rule ให้อัปเดต RULES-TH + APPENDIX §9 แล้วรัน smoke*
