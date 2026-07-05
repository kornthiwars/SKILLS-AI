# คู่มือภาษาไทย — agent-skills

เอกสารนี้อธิบาย **14 skills** และ **36 rules** ใน repo นี้เป็นภาษาไทย

**Spine (อ่านก่อน):** [ARCHITECTURE.md](../../ARCHITECTURE.md) · Skill domains: [ai-skills/_catalog/](../../ai-skills/_catalog/)

## อ่านอะไรก่อน

| เอกสาร | เนื้อหา |
|--------|---------|
| [ARCHITECTURE.md](../../ARCHITECTURE.md) | แผนที่ SSoT — pack · vault · apps · catalog |
| [SKILLS-TH.md](./SKILLS-TH.md) | **14 skills** — เรียกด้วย `/ชื่อ-skill` |
| [RULES-TH.md](./RULES-TH.md) | **36 rules** — always-on + scoped + `_index.mdc` |
| [APPENDIX-TH.md](./APPENDIX-TH.md) | **SSoT ตารางเวอร์ชัน** · reference · globs · vault · scripts |
| [REFERENCE-INDEX-TH.md](./REFERENCE-INDEX-TH.md) | ลิงก์ไป `reference.md` ภาษาอังกฤษทุก skill |
| [CHANGE-CONTROL.md](../CHANGE-CONTROL.md) | EN — 4 layers (spine + rules + skills + setup) |
| [DYNAMIC-AGENT-SMOKE.md](../DYNAMIC-AGENT-SMOKE.md) | ทด agent มือใน Cursor (15 scenarios) |
| [EXTERNAL-PARITY.md](../EXTERNAL-PARITY.md) | ใช้ pack คู่ external skills จาก catalog |
| [CATALOG-SUBMISSION.md](../CATALOG-SUBMISSION.md) | ส่งเข้า awesome-agent-skills (เมื่อพร้อม) |

## agent-skills คืออะไร

**agent-skills** เป็นชุด **Cursor skills** (workflow เมื่อ invoke `/slash`) และ **rules** (กฎที่ agent ต้องปฏิบัติ) สำหรับงาน production:

1. **สังเกตก่อนแก้** — repro, หลักฐาน, ไม่เดา
2. **patch เล็ก** — งบไฟล์/บรรทัดจำกัด
3. **ตรวจหลังแก้** — ไม่บอกว่า “เสร็จ” โดยไม่ verify

## สองชนิด: Skill vs Rule

| | **Skill** (`ai-skills/`) | **Rule** (`ai-rules/`) |
|--|--------------------------|-------------------------|
| เปิดใช้ | `/debug`, `/git-push`, … | `alwaysApply` / `globs` / intelligent |
| ความลึก | workflow เต็ม (phase, ledger) | กฎสั้น — gate / ห้าม / ต้องทำ |
| จัดกลุ่ม | [_catalog/](../../ai-skills/_catalog/) ตาม domain | [_index.mdc](../../ai-rules/_index.mdc) ตาม tier |

**ไม่ซ้ำกัน:** rule บังคับทุก turn ที่เกี่ยว; skill ให้ขั้นตอนเมื่อ invoke งานนั้น

## ติดตั้ง (ครั้งเดียวต่อ workspace)

**macOS / Linux:**

```bash
./scripts/setup-macos-linux.sh
```

**Windows:**

```powershell
.\scripts\setup-windows.ps1 -InstallRoot <workspace>
```

สร้าง junction: `.cursor/skills` → `ai-skills/`, `.cursor/rules` → `ai-rules/`, `.cursor/vault` → `vault/`

Clone ชื่อ canonical: **`agent-skills/`** (ถ้ายังเป็น `SKILLS-AI/` บน disk ดู [LEGACY-PATH.md](../../LEGACY-PATH.md))

หลัง pull: **Reload Cursor**

## ดัชนี skill ตาม domain

| Domain | Catalog | Invoke ตัวอย่าง |
|--------|---------|-----------------|
| Diagnose | [_catalog/diagnose.md](../../ai-skills/_catalog/diagnose.md) | `/debug` · `/scrutinize` · `/fix-record` |
| Build | [_catalog/build.md](../../ai-skills/_catalog/build.md) | `/builder-feature` · `/builder-ui` · `/builder-ui-cost` · `/builder-api` |
| Memory | [_catalog/memory.md](../../ai-skills/_catalog/memory.md) | `/vault-capture` · `/vault-recall` · `/vault-daily` |
| Meta | [_catalog/meta.md](../../ai-skills/_catalog/meta.md) | `/upgrade-ai` · `/git-push` |

**เวอร์ชัน (SSoT):** [APPENDIX-TH.md](./APPENDIX-TH.md) §1 เท่านั้น — ไม่ duplicate ใน README

รายละเอียดเต็ม → [SKILLS-TH.md](./SKILLS-TH.md)

## ดัชนี rule (สรุป)

| ประเภท | จำนวน | บทบาท |
|--------|------:|--------|
| Always-on | 5 | manifest, bilingual, clean-code, vault-autolog, decision-tree |
| Activation map | 1 | `_index.mdc` — tier 0–3 (on request) |
| Scoped | 30 | core, debugging, patching, architecture, testing, risk, workflow |

รายละเอียดเต็ม → [RULES-TH.md](./RULES-TH.md)

## Vault (Obsidian)

โน้ต local ที่ `vault/` — gitignore · schema ใน [templates/vault/README.md](../../templates/vault/README.md)

| Tier | โฟลเดอร์ |
|------|----------|
| Ephemeral | `daily/` → archive เก่าไป `daily/archive/YYYY/` |
| Episodic | `sessions/` |
| Semantic | `decisions/`, `projects/` |

Autolog หลัง patch+verify → `append-daily.ps1` · สิ้นวัน → `/vault-daily`

## เอกสารภาษาอังกฤษ (canonical)

- [AGENTS.md](../../AGENTS.md)
- [ai-skills/SKILL-AUTHORING.md](../../ai-skills/SKILL-AUTHORING.md)
- [docs/SKILL-PATTERN.md](../SKILL-PATTERN.md)
- [templates/vault/README.md](../../templates/vault/README.md)
