# agent-skills

Repository สำหรับ **Cursor Agent Skills + Rules** (canonical อยู่ที่ `ai-skills/`, `ai-rules/`)

Agent entry: [AGENTS.md](AGENTS.md)

**Skills:** [ai-skills/](ai-skills/README.md) · **Rules:** [ai-rules/](ai-rules/README.md) · **Vault:** [vault/](vault/README.md)

---

## ติดตั้ง

### สิ่งที่ต้องมี

| รายการ | ใช้ทำอะไร |
|--------|-----------|
| [Git](https://git-scm.com/) | clone repo |
| [Cursor](https://cursor.com/) | skills / rules |
| `bash` (macOS/Linux) หรือ PowerShell 5.1+ (Windows) | setup script |
| `python3` (macOS/Linux) | เขียน `ai-skills-vault.json` |

### 1 — Clone

```bash
git clone git@github.com-kornthiwars:kornthiwars/agent-skills.git
cd agent-skills
```

### 2 — Setup (ครั้งเดียวหลัง clone)

สคริปต์สร้าง link ใต้ **โฟลเดอร์ที่เปิดใน Cursor** (install root): `.cursor/skills`, `.cursor/rules`, `.cursor/vault` + `ai-skills-vault.json`  
เนื้อหาจริงอยู่ใน `ai-skills/`, `ai-rules/`, `vault/` ของ repo นี้

**macOS / Linux:**

```bash
chmod +x scripts/setup-macos-linux.sh
./scripts/setup-macos-linux.sh      # default: parent project (e.g. exat/)
./scripts/setup-macos-linux.sh .    # workspace = agent-skills only
```

**Windows** — double-click `scripts\setup-windows.bat` หรือดู [scripts/README.md](scripts/README.md)

| ปัญหา | แก้ |
|--------|-----|
| Windows `mklink` ล้มเหลว | PowerShell **Run as administrator** แล้วรัน setup อีกครั้ง |
| `.cursor/skills` มีอยู่แล้วแต่ไม่ใช่ link | ลบแล้วรัน setup ใหม่ |

### 3 — Reload Cursor

แก้ skills/rules ที่ `ai-skills/` / `ai-rules/` เท่านั้น — ไม่แก้ใน junction โดยตรง

---

## Vault

Daily work log: `vault/issues/` · Plan: `vault/workday/` · Wiki: `vault/wiki/` (**local-only**).  
Obsidian: open `vault/` — see [vault/README.md](vault/README.md).  
Rule: `vault-issues.mdc` — logs **work-related** turns only (not chitchat); say **เก็บลง vault** to force-write.
