# vault

Obsidian vault root = โฟลเดอร์ **`vault/`** นี้ (เปิด repo หรือเปิด `vault/` โดยตรง)

## โครงสร้าง

```
templates/                    ← repo root
vault/
├── .obsidian/                ← graph สี 2 โฟลเดอร์ (ใน git)
├── issues/YYYY-MM-DD.md      ← งานรายวัน (local, gitignored)
└── learnings/YYYY-MM-DD-HHmm.md  ← บทเรียนแยกไฟล์ (local)
```

## Flow

```
งาน Q&A สั้น        → issues/YYYY-MM-DD.md     (## N. + คำถาม/คำตอบ)
คุยเล่น             → ไม่เขียน
lesson ค้นหาซ้ำได้  → learnings/YYYY-MM-DD-HHmm  (จบเรื่อง + OR สัญญาณ — ดู rule)
RCA หลัง fix        → /fix-record
```

**issues ≠ learnings** — อย่าใช้ bullet `ประเภท` / section เก่าร่วมกัน

## Tags (Obsidian)

### Type (บังคับ)

| Tag | โฟลเดอร์ |
|-----|----------|
| `issues` | `issues/` |
| `learning` | `learnings/` |

### Topic (เลือก 1–3 ต่อ entry)

`vault` · `git` · `skills` · `sql` · `debug` · `research` · `ui` · `api` · `infrastructure`

ใส่ใน frontmatter รายวัน + บรรทัด `#vault #git` ใต้ `## N. title`

## Graph

- ไฟล์: `vault/.obsidian/graph.json`
- **Groups:** `path:issues` (ฟ้า) · `path:learnings` (ทอง)
- **Filter:** `-path:templates -file:README`
- เปิด **Tags** ใน Graph ได้ · **ไม่มี hub file** · ไม่บังคับ wikilink

## Plugin (แนะนำ)

**Property Over File Name** — แสดง `title:` แทนชื่อไฟล์ `2026-05-27-1545.md`  
เปิด community plugins ใน Obsidian; repo มี config ใน `.obsidian/community-plugins.json`

## Agent rule

`ai-rules/vault-issues.mdc` → `.cursor/rules/` หลัง setup

## Git

**ใน git:** README, `.obsidian`, `templates/`  
**local only:** `issues/*.md`, `learnings/*.md` (ยกเว้น `*/README.md`)
