# agent-skills

Repository สำหรับ **Cursor Agent Skills + Rules** (canonical อยู่ที่ `ai-skills/`, `ai-rules/`)

Agent entry: [AGENTS.md](AGENTS.md)

**Skills:** [ai-skills/](ai-skills/README.md) · **Rules:** [ai-rules/](ai-rules/README.md)

---

## ติดตั้ง

### สิ่งที่ต้องมี

| รายการ | ใช้ทำอะไร |
|--------|-----------|
| [Git](https://git-scm.com/) | clone repo |
| [Cursor](https://cursor.com/) | skills / rules |
| `bash` (macOS/Linux) หรือ PowerShell 5.1+ (Windows) | setup script |

### 1 — Clone

```bash
git clone git@github.com-kornthiwars:kornthiwars/agent-skills.git
cd agent-skills
```

### 2 — Setup (ครั้งเดียวหลัง clone)

สคริปต์สร้าง link ใต้ **โฟลเดอร์ที่เปิดใน Cursor**: `.cursor/skills`, `.cursor/rules`, `.cursor/vault`  
`vault/` เป็นโฟลเดอร์ว่างสำหรับโน้ต local ของคุณ (gitignore)

**macOS / Linux:**

```bash
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh
```

**Windows** — `scripts\setup-windows.bat` หรือ [scripts/README.md](scripts/README.md)

### 3 — Reload Cursor

แก้ skills/rules ที่ `ai-skills/` / `ai-rules/` — ไม่แก้ใน junction โดยตรง
