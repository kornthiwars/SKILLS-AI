#!/usr/bin/env python3
"""Bootstrap vault directories, config, and embedding model prewarm."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import json
import sys
from pathlib import Path

from embedder import embed_query
from vault_config import DEFAULT_CONFIG, load_config, save_config
from vault_paths import index_dir, notes_root, vault_root


NOTE_DIRS = [
    "daily",
    "daily/archive",
    "projects",
    "decisions",
    "sessions",
    "inbox",
]


def bootstrap(*, prewarm: bool = True) -> dict:
    vault_root().mkdir(parents=True, exist_ok=True)
    (vault_root() / "assets").mkdir(parents=True, exist_ok=True)
    gitkeep = vault_root() / ".gitkeep"
    if not gitkeep.exists():
        gitkeep.touch()

    for name in NOTE_DIRS:
        (notes_root() / name).mkdir(parents=True, exist_ok=True)

    index_dir().mkdir(parents=True, exist_ok=True)
    config = load_config()
    if not (index_dir() / "config.json").is_file():
        save_config(config)
    else:
        save_config(config)

    warmed = False
    if prewarm:
        try:
            embed_query("vault bootstrap prewarm", config)
            warmed = True
        except Exception as exc:  # noqa: BLE001
            return {"ok": False, "error": f"prewarm failed: {exc}"}

    return {
        "ok": True,
        "vault": str(vault_root()),
        "config": str(index_dir() / "config.json"),
        "prewarm": warmed,
        "model": config.get("embedding", {}).get("model", DEFAULT_CONFIG["embedding"]["model"]),
    }


def main() -> int:
    try:
        result = bootstrap()
        print(json.dumps(result, indent=2))
        return 0 if result.get("ok") else 1
    except Exception as exc:  # noqa: BLE001
        print(json.dumps({"ok": False, "error": str(exc)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
