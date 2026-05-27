# issues — daily work log (รูปแบบใหม่เท่านั้น)

**หนึ่งวัน = หนึ่งไฟล์** `YYYY-MM-DD.md`

## โครงสร้าง

```markdown
---
date: YYYY-MM-DD
tags: [issues, skills, vault]
---

# Issues — YYYY-MM-DD

## 1. หัวข้อสั้น

#vault #skills

### คำถาม
...

### คำตอบ / สถานะ
resolved — ผลลัพธ์หนึ่งบรรทัด
```

- **ไม่เก็บทุกแชท** — เฉพาะงาน (ดู `vault-issues.mdc`)
- หนึ่งเรื่อง = `## N.` เลขต่อเนื่อง
- บทเรียนยาว → `learnings/` (รูปแบบคนละแบบ)

Template: [templates/template.issue.md](../../templates/template.issue.md)

## ไฟล์เก่า (อ่านอย่างเดียว)

ถ้ามี `## คำถาม` / `### HH:MM` / `ประเภท:` — เป็นระบบเก่า **อย่า append ต่อ**  
วันใหม่เริ่มจาก template ใหม่ · หรือสร้างไฟล์วันใหม่แล้วอ้างใน Obsidian ว่า archive

## Git

`issues/*.md` gitignored — local only
