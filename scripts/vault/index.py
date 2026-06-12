#!/usr/bin/env python3
"""Incremental vault indexer."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import argparse
import fnmatch
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

from chunker import chunk_note, content_hash, doc_id_from_note, parse_note
from embedder import embed_texts
from store import VaultStore, load_manifest, save_manifest
from vault_config import load_config
from vault_paths import notes_root, vault_root


def tier_for_path(path_rel: str, config: dict) -> str:
    norm = path_rel.replace("\\", "/")
    tiers = config.get("tiers", {})
    semantic = tiers.get("semantic", [])
    if isinstance(semantic, str):
        semantic = [semantic]
    for prefix in semantic:
        if norm.startswith(prefix.replace("\\", "/") + "/") or norm.startswith(prefix + "/"):
            return "semantic"
    episodic = str(tiers.get("episodic", "notes/sessions")).replace("\\", "/")
    if norm.startswith(episodic + "/"):
        return "episodic"
    ephemeral = str(tiers.get("ephemeral", "notes/daily")).replace("\\", "/")
    if norm.startswith(ephemeral + "/"):
        return "ephemeral"
    return "other"


def should_index(path_rel: str, config: dict) -> bool:
    norm = path_rel.replace("\\", "/")
    excludes = config.get("paths", {}).get("index_exclude", [])
    for pattern in excludes:
        if fnmatch.fnmatch(norm, pattern.replace("\\", "/")):
            return False
    return norm.endswith(".md")


def iter_note_files() -> list[Path]:
    root = notes_root()
    if not root.is_dir():
        return []
    return sorted(root.rglob("*.md"))


def rel_path(path: Path) -> str:
    return path.relative_to(vault_root()).as_posix()


def index_vault(*, full: bool = False, status: bool = False) -> int:
    config = load_config()
    if status:
        return print_status(config)

    manifest = {"indexed_at": None, "files": {}} if full else load_manifest()
    files_meta = {} if full else manifest.get("files", {})

    store = VaultStore()
    if full:
        store.conn.execute("DELETE FROM chunks")
        store.conn.commit()
        store.rebuild_fts()

    notes = iter_note_files()
    changed = 0
    for note_path in notes:
        path_rel = rel_path(note_path)
        if not should_index(path_rel, config):
            continue

        text = note_path.read_text(encoding="utf-8")
        digest = content_hash(text)
        prev = files_meta.get(path_rel)
        if not full and prev and prev.get("content_hash") == digest:
            continue

        parsed = parse_note(path_rel, text)
        doc_id = doc_id_from_note(parsed, path_rel)
        store.delete_doc_chunks(doc_id)

        chunk_cfg = config.get("chunking", {})
        max_chars = int(chunk_cfg.get("max_tokens", 512)) * 4
        overlap = int(chunk_cfg.get("overlap_tokens", 64)) * 4
        chunks = chunk_note(parsed, max_chars=max_chars, overlap_chars=overlap)
        if not chunks:
            files_meta[path_rel] = {
                "doc_id": doc_id,
                "content_hash": digest,
                "mtime": datetime.fromtimestamp(note_path.stat().st_mtime, tz=timezone.utc).isoformat(),
                "chunk_ids": [],
            }
            changed += 1
            continue

        texts = [c.text for c in chunks]
        embeddings = embed_texts(texts, config)
        tier = tier_for_path(path_rel, config)
        project = parsed.frontmatter.get("project")
        updated = parsed.frontmatter.get("updated") or parsed.frontmatter.get("date")

        chunk_ids: list[str] = []
        for seq, (chunk, emb) in enumerate(zip(chunks, embeddings)):
            chunk_id = f"{doc_id}#{seq}"
            chunk_ids.append(chunk_id)
            excerpt = chunk.text[:500]
            store.upsert_chunk(
                chunk_id=chunk_id,
                doc_id=doc_id,
                path=path_rel,
                heading=chunk.heading,
                line_start=chunk.line_start,
                line_end=chunk.line_end,
                excerpt=excerpt,
                tier=tier,
                project=str(project) if project else None,
                doc_updated=str(updated) if updated else None,
                embedding=emb,
            )

        files_meta[path_rel] = {
            "doc_id": doc_id,
            "content_hash": digest,
            "mtime": datetime.fromtimestamp(note_path.stat().st_mtime, tz=timezone.utc).isoformat(),
            "chunk_ids": chunk_ids,
        }
        changed += 1

    store.commit()
    store.close()

    manifest["files"] = files_meta
    manifest["indexed_at"] = datetime.now(timezone.utc).isoformat()
    save_manifest(manifest)

    print(json.dumps({"ok": True, "changed_files": changed, "total_files": len(files_meta)}))
    return 0


def print_status(config: dict) -> int:
    manifest = load_manifest()
    files = manifest.get("files", {})
    print(
        json.dumps(
            {
                "indexed_at": manifest.get("indexed_at"),
                "indexed_files": len(files),
                "model": config.get("embedding", {}).get("model"),
                "notes_root": str(notes_root()),
            },
            indent=2,
        )
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Index vault notes")
    parser.add_argument("--full", action="store_true", help="Rebuild entire index")
    parser.add_argument("--status", action="store_true", help="Print index status JSON")
    args = parser.parse_args()
    try:
        return index_vault(full=args.full, status=args.status)
    except Exception as exc:  # noqa: BLE001
        print(json.dumps({"ok": False, "error": str(exc)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
