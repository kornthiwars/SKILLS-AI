#!/usr/bin/env python3
"""Read daily vault note by date."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import argparse
import json
from datetime import date

from vault_paths import notes_root, vault_root


def read_daily(target: date) -> dict:
    path = notes_root() / "daily" / f"{target.isoformat()}.md"
    if not path.is_file():
        return {"ok": False, "date": target.isoformat(), "error": "not_found"}
    return {
        "ok": True,
        "date": target.isoformat(),
        "path": path.relative_to(vault_root()).as_posix(),
        "content": path.read_text(encoding="utf-8"),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Read vault daily note")
    parser.add_argument("--date", default=date.today().isoformat(), help="YYYY-MM-DD")
    args = parser.parse_args()
    try:
        target = date.fromisoformat(args.date)
    except ValueError:
        print(json.dumps({"ok": False, "error": "invalid date"}), file=sys.stderr)
        return 1
    payload = read_daily(target)
    print(json.dumps(payload, ensure_ascii=False, indent=2))
    return 0 if payload.get("ok") else 2


if __name__ == "__main__":
    raise SystemExit(main())
