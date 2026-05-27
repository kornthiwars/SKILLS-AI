# learnings — บทเรียน (ออกแบบแยกจาก issues)

**หนึ่งปัญหาที่แก้จบ = หนึ่งไฟล์** — ไม่ยัดลง `issues/YYYY-MM-DD.md`

## เมื่อไหร่สร้าง

**ไม่ใช้กฎ “≥2 รอบแชท”** — ใช้กฎ **lesson ค้นหาซ้ำได้**

### ต้องครบ (AND)

1. **จบเรื่องแล้ว** (fixed / decided / wontfix / deferred)
2. **คุ้มเก็บถาวร** — เดือนหน้าอยาก Grep หา note นี้ได้

### อย่างน้อยหนึ่งข้อ (OR)

- mechanism ไม่ trivial  
- ลอง **≥2 แนวทางต่างกัน** เรื่องเดียวกัน (ไม่นับแค่จำนวนข้อความ)  
- อาการซ้ำใน issues ~7 วัน หรือ user บอกเคยเจอ  
- friction ระบบ (git / skill / vault / setup)  
- user ขอเก็บเป็นบทเรียน  

| ใช้ **issues** แทน | ไม่ใช่ learning |
|---------------------|-----------------|
| Q&A งานสั้น, อธิบาย rule | chitchat |
| ถามครั้งเดียวจบ | ยังสืบไม่จบ |
| บันทึกว่าทำอะไรวันนี้ | `/fix-record` (RCA ยาว) |

## ชื่อไฟล์

`YYYY-MM-DD-HHmm.md` — เวลา local ตอนจบ lesson

## โครงสร้าง (lesson card)

ดู [templates/template.learning.md](../../templates/template.learning.md)

| Section | เก็บอะไร |
|---------|----------|
| **บริบท** | งาน / repo / skill ที่เกี่ยว |
| **อาการ** | เห็นอะไร |
| **สาเหตุ** | mechanism สั้นๆ |
| **วิธีแก้** | คำสั่ง ไฟล์ ที่ work |
| **ใช้เมื่อไหร่** | trigger เปิด note นี้ซ้ำ |
| **หลีกเลี่ยง** | anti-pattern |
| **อ้างอิง** | ลิงก์ไป `issues/YYYY-MM-DD` (ข้อความ ไม่บังคับ wikilink) |

**ห้าม** ใช้ `### คำถาม` · `ประเภท:` · `สถานะ: open` แบบ issues เก่า

## Obsidian

- frontmatter `tags: [learning, <skill>]` + `skill:` ตรงกับ topic
- `title:` ภาษาอังกฤษ — graph แสดงชื่ออ่านง่าย (plugin Property Over File Name)
- สีโฟลเดอร์: `path:learnings` ใน `vault/.obsidian/graph.json`

## ค้นหา (agent)

Grep `symptoms:`, `skill:`, `files:`, คำใน **อาการ** — อ่าน ≤3 ไฟล์

Rule: `ai-rules/vault-issues.mdc`
