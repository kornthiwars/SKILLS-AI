# Issues — daily log

**หนึ่งวัน = หนึ่งไฟล์** → `YYYY-MM-DD.md` (เวลา local)

## โครงสร้าง

```
vault/issues/
├── README.md
└── YYYY-MM-DD.md     # บันทึกรายวัน (local — ไม่ commit ขึ้น GitHub)
```

Template สำหรับวันใหม่: [templates/template.issue.md](../../templates/template.issue.md) (setup scripts สร้างให้อัตโนมัติ)

ไฟล์ `YYYY-MM-DD.md` อยู่ใน `.gitignore` — เก็บเฉพาะเครื่องคุณ ไม่ sync กับ remote

## หมวดในแต่ละไฟล์

| Section | เก็บอะไร |
|---------|----------|
| **คำถาม** | คำถามที่ยังไม่มีคำตอบ / สิ่งที่ต้องค้นหา |
| **ปัญหา** | อาการ, error, สิ่งที่พัง |
| **วิธีแก้** | สิ่งที่ลองแล้วได้ผล (พร้อมคำสั่งหรือลิงก์สั้นๆ) |
| **อื่นๆ** | บันทึกทั่วไป, ไอเดีย, follow-up |

## รูปแบบ entry (ให้ AI ใช้)

```markdown
### HH:MM — หัวข้อสั้น

- **ประเภท:** คำถาม | ปัญหา | วิธีแก้ | อื่นๆ
- **บริบท:** (optional)
- **รายละเอียด:**
- **สถานะ:** open | resolved | wontfix
```

## กฎ

- **append เท่านั้น** — อย่าลบประวัติเก่าในไฟล์วันนั้น (แก้ typo เล็กน้อยได้)
- **ห้ามเก็บ secrets** — password, token, private key, connection string เต็มๆ
- วันใหม่ → สร้างจาก `templates/template.issue.md` ถ้ายังไม่มี (หรือรัน setup script)

## เรียกใช้

- Rule: `ai-rules/vault-issues.mdc` → `.cursor/rules/` after setup (`alwaysApply: true`)
- Template: `templates/template.issue.md`
- ค่าเริ่มต้น: AI บันทึก **ทุกคำถาม** ลง `คำถาม` อัตโนมัติ
- ข้อความที่เป็นการเรียก skill (เช่น `/debug`, `/sql`, `/builder-*`) ก็นับและต้องบันทึก
- พูด: **เก็บลง vault** / **บันทึกปัญหาวันนี้** / save to vault (บังคับเขียนทันที)
