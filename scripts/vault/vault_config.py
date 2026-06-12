"""Load and save vault indexer configuration."""

from __future__ import annotations

import json
from copy import deepcopy
from pathlib import Path
from typing import Any

from vault_paths import config_path, index_dir

DEFAULT_CONFIG: dict[str, Any] = {
    "schema_version": 1,
    "embedding": {
        "provider": "fastembed",
        "model": "BAAI/bge-m3",
        "dimensions": 1024,
    },
    "chunking": {
        "strategy": "heading_then_tokens",
        "max_tokens": 512,
        "overlap_tokens": 64,
    },
    "paths": {
        "notes_glob": "notes/**/*.md",
        "index_exclude": ["notes/daily/**", "notes/inbox/**", "notes/daily/archive/**"],
    },
    "tiers": {
        "ephemeral": "notes/daily",
        "semantic": ["notes/decisions", "notes/projects"],
        "episodic": "notes/sessions",
    },
    "search": {
        "dedupe_threshold": 0.85,
        "fts_weight": 0.4,
        "vector_weight": 0.6,
    },
}


def load_config(path: Path | None = None) -> dict[str, Any]:
    cfg_file = path or config_path()
    if not cfg_file.is_file():
        return deepcopy(DEFAULT_CONFIG)
    with cfg_file.open(encoding="utf-8") as f:
        data = json.load(f)
    merged = deepcopy(DEFAULT_CONFIG)
    _deep_merge(merged, data)
    return merged


def save_config(config: dict[str, Any], path: Path | None = None) -> None:
    cfg_file = path or config_path()
    index_dir().mkdir(parents=True, exist_ok=True)
    with cfg_file.open("w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
        f.write("\n")


def _deep_merge(base: dict[str, Any], override: dict[str, Any]) -> None:
    for key, value in override.items():
        if key in base and isinstance(base[key], dict) and isinstance(value, dict):
            _deep_merge(base[key], value)
        else:
            base[key] = value
