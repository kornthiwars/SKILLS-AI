#!/usr/bin/env python3
"""Offline smoke tests (no embedding download). Run: python scripts/vault/smoke_test.py"""

from __future__ import annotations

import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from chunker import chunk_note, content_hash, doc_id_from_note, parse_note
from vault_config import DEFAULT_CONFIG, load_config, save_config


def test_chunker() -> None:
    sample = """---
id: dec-test
title: Test
---
## One
Hello world.

## Two
More text.
"""
    parsed = parse_note("notes/decisions/test.md", sample)
    assert doc_id_from_note(parsed, "notes/decisions/test.md") == "dec-test"
    chunks = chunk_note(parsed, max_chars=100, overlap_chars=10)
    assert len(chunks) >= 2
    assert chunks[0].heading == "One"


def test_config_roundtrip() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        cfg_path = Path(tmp) / "config.json"
        save_config(DEFAULT_CONFIG, cfg_path)
        loaded = load_config(cfg_path)
        assert loaded["embedding"]["model"] == "BAAI/bge-m3"
        assert "notes/daily/**" in loaded["paths"]["index_exclude"]


def main() -> int:
    test_chunker()
    test_config_roundtrip()
    print("smoke_test: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
