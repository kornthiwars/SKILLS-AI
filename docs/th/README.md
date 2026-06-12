# คู่มือภาษาไทย — agent-skills

เอกสารนี้อธิบาย **ทุก skill** และ **ทุก rule** ใน repo นี้อย่างละเอียดเป็นภาษาไทย

## อ่านอะไรก่อน

| เอกสาร | เนื้อหา |
|--------|---------|
| [SKILLS-TH.md](./SKILLS-TH.md) | 10 skills — เรียกด้วย `/ชื่อ-skill` |
| [RULES-TH.md](./RULES-TH.md) | 34 rules — โหลดอัตโนมัติตาม Cursor |
| [APPENDIX-TH.md](./APPENDIX-TH.md) | เติมรายละเอียด — versions, reference.md, globs, setup scripts, mantra |
| [REFERENCE-INDEX-TH.md](./REFERENCE-INDEX-TH.md) | ลิงก์ไป `reference.md` ภาษาอังกฤษทุก skill |
| [CHANGE-CONTROL.md](../CHANGE-CONTROL.md) | ภาษาอังกฤษ — สถาปัตยกรรม 3 ชั้น (rules + skills + setup) |
| [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) | ทด agent มือใน Cursor (15 scenarios) |
| [EXTERNAL-PARITY.md](../EXTERNAL-PARITY.md) | ใช้ pack คู่ external skills จาก catalog |
| [CATALOG-SUBMISSION.md](../CATALOG-SUBMISSION.md) | ส่งเข้า awesome-agent-skills (เมื่อพร้อม) |

## agent-skills คืออะไร

**agent-skills** เป็นชุด **Cursor skills** (คำสั่งเชิงลึกเมื่อ invoke) และ **rules** (กฎที่ agent ต้องปฏิบัติ) สำหรับทำงานแบบ production:

1. **สังเกตก่อนแก้** — มี repro, หลักฐาน, ไม่เดา
2. **patch เล็ก** — งบไฟล์/บรรทัดจำกัด
3. **ตรวจหลังแก้** — ไม่บอกว่า “เสร็จ” โดยไม่ verify

## สองชนิด: Skill vs Rule

| | **Skill** (`ai-skills/`) | **Rule** (`ai-rules/`) |
|--|--------------------------|-------------------------|
| เปิดใช้ | ผู้ใช้พิมพ์ `/debug`, `/git-push`, … | Cursor โหลดตาม `alwaysApply` / `globs` / intelligent |
| ความลึก | workflow เต็ม (หลาย phase, ledger, matrix) | กฎสั้น ชัด — gate / ห้าม / ต้องทำ |
| ตัวอย่าง | `/debug` มี 4 ขั้น + mantra | `reproduce-before-fix` ห้าม patch ก่อน repro |

**ไม่ซ้ำกัน:** rule บังคับพฤติกรรมทุก turn ที่เกี่ยว; skill ให้ขั้นตอนเมื่อคุณเลือกงานนั้นโดยตรง

## ติดตั้ง (ครั้งเดียวต่อ workspace)

**macOS / Linux** — เปิดโฟลเดอร์ workspace ใน Cursor แล้วรัน:

```bash
./scripts/setup-macos-linux.sh .
```

**Windows** (PowerShell) — แทน `<workspace>` ด้วยโฟลเดอร์ที่เปิดใน Cursor (เช่น `C:\Users\you\project`):

```powershell
.\scripts\setup-windows.ps1 -InstallRoot <workspace>
```

หรือ `scripts\setup-windows.bat`

สร้าง junction: `.cursor/skills` → `ai-skills/`, `.cursor/rules` → `ai-rules/`, `.cursor/vault` → `vault/` (โน้ต local)

หลัง pull ใหม่: **Reload Cursor** หรือรัน setup อีกครั้ง

## ดัชนี skill (สรุป)

| Invoke | ใช้เมื่อ |
|--------|----------|
| `/debug` | bug, stack trace, พฤติกรรมผิด |
| `/scrutinize` | review PR / แผน / diff |
| `/builder-ui` | สถาปัตยกรรม UI / mock |
| `/builder-api` | สัญญา API / backend |
| `/builder-schema` | schema / migration |
| `/builder-infrastructure` | deploy, IaC, observability |
| `/builder-feature` | feature ข้าม layer |
| `/fix-record` | RCA หลัง fix จริง |
| `/upgrade-ai` | ปรับ skill/rule ใน repo นี้ |
| `/git-push` | commit/push ปลอดภัย |

รายละเอียดเต็ม → [SKILLS-TH.md](./SKILLS-TH.md)

## ดัชนี rule (สรุป)

| โฟลเดอร์ | จำนวน | บทบาท |
|----------|------:|--------|
| root (always-on) | 4 | manifest, ภาษา, clean code, decision-tree |
| `core/` | 5 | ลำดับทำงาน, วินิจฉัย, patch เล็ก, verify |
| `debugging/` | 5 | repro, หลักฐาน, ทางเลือกอื่น |
| `patching/` | 5 | ขอบเขตไฟล์, ขนาด diff, side effect |
| `architecture/` | 4 | layer, API, schema, shared code |
| `testing/` | 4 | validation, regression, manual steps |
| `risk/` | 4 | ระดับความเสี่ยง, prod, rollback |
| `workflow/` | 3 | เลือก skill, รูปแบบตอบ, หยุดเมื่อไม่ชัด |

รายละเอียดเต็ม → [RULES-TH.md](./RULES-TH.md)

## เอกสารภาษาอังกฤษ (canonical)

- [AGENTS.md](../../AGENTS.md)
- [ai-skills/SKILL-AUTHORING.md](../../ai-skills/SKILL-AUTHORING.md)
- [docs/SKILL-PATTERN.md](../SKILL-PATTERN.md)
