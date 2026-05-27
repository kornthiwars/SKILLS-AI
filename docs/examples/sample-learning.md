---
date: 2026-05-27
time: "1600"
tags: [learning, vault, skills]
skill: vault
title: Wire vault recall before debug and git-push
status: resolved
symptoms: [repeat SSH push failure, skills ignore learnings folder]
files: [ai-skills/debug/SKILL.md, ai-skills/git-push/SKILL.md, ai-rules/vault-issues.mdc]
related_issue: "2026-05-27"
---

# Wire vault recall before debug and git-push

## บริบท

SKILLS-AI repo — vault v2 แยก issues/learnings แต่ skills ยังไม่ Grep ก่อนทำงาน

## อาการ

- Agent debug ซ้ำคำสั่งที่เคยแก้ในแชทก่อนหน้า
- `/git-push` ติด SSH/account โดยไม่ดู note เก่า

## สาเหตุ

Recall อยู่ใน `vault-issues.mdc` (alwaysApply) แต่ไม่ถูก bind เข้า workflow ของ `debug` / `git-push` — model ข้ามเมื่อ context ยาว

## วิธีแก้

1. เพิ่มขั้น Grep `vault/learnings/` (≤3 ไฟล์) ใน `debug` ก่อน reproduce และ `git-push` Phase 0 เมื่อ blocked
2. ใช้ `/vault-recall` สำหรับค้นโดยเฉพาะ
3. ดู `docs/SKILL-SMOKE-CHECKLIST.md` หลัง deploy rule

## ใช้เมื่อไหร่

อาการซ้ำ, friction git/SSH/skills, หลัง restructure vault

## หลีกเลี่ยง

- อย่า copy issues format ไป learnings
- อย่า commit `vault/issues/*.md`

## อ้างอิง

- `related_issue:` 2026-05-27
- `docs/examples/sample-learning.md` (tracked copy for authors)
