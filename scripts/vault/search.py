#!/usr/bin/env python3
"""Hybrid FTS + vector search for vault."""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import argparse
import json
import re
import sys
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import Any

import numpy as np

from embedder import embed_query
from store import VaultStore, blob_to_vector, load_manifest
from vault_config import load_config
from vault_paths import notes_root, vault_root


DATE_RE = re.compile(r"\b(20\d{2}-\d{2}-\d{2})\b")


def normalize_scores(scores: dict[str, float]) -> dict[str, float]:
    if not scores:
        return {}
    vals = list(scores.values())
    lo, hi = min(vals), max(vals)
    if hi - lo < 1e-9:
        return {k: 1.0 for k in scores}
    return {k: (v - lo) / (hi - lo) for k, v in scores.items()}


def simple_mmr(
    candidates: list[dict[str, Any]],
    *,
    top_k: int,
    lambda_mult: float = 0.7,
) -> list[dict[str, Any]]:
    if len(candidates) <= top_k:
        return candidates
    selected: list[dict[str, Any]] = []
    remaining = candidates[:]
    while remaining and len(selected) < top_k:
        if not selected:
            best = max(remaining, key=lambda x: x["score"])
            selected.append(best)
            remaining.remove(best)
            continue
        best_item = None
        best_value = -1.0
        for item in remaining:
            relevance = item["score"]
            redundancy = 0.0
            for picked in selected:
                if picked.get("doc_id") == item.get("doc_id"):
                    redundancy = max(redundancy, 0.9)
            value = lambda_mult * relevance - (1 - lambda_mult) * redundancy
            if value > best_value:
                best_value = value
                best_item = item
        if best_item is None:
            break
        selected.append(best_item)
        remaining.remove(best_item)
    return selected


def resolve_daily_path(query: str) -> Path | None:
    q = query.strip().lower()
    today = date.today()
    target: date | None = None
    if "เมื่อวาน" in q or "yesterday" in q:
        target = today - timedelta(days=1)
    else:
        m = DATE_RE.search(query)
        if m:
            target = date.fromisoformat(m.group(1))
        elif re.search(r"\b(สรุป|daily|งานวัน)\b", q, re.I):
            target = today
    if target is None:
        return None
    path = notes_root() / "daily" / f"{target.isoformat()}.md"
    return path if path.is_file() else None


def hybrid_search(
    query: str,
    *,
    top: int = 5,
    project: str | None = None,
    since: str | None = None,
    config: dict | None = None,
) -> list[dict[str, Any]]:
    config = config or load_config()
    weights = config.get("search", {})
    fts_w = float(weights.get("fts_weight", 0.4))
    vec_w = float(weights.get("vector_weight", 0.6))

    store = VaultStore()
    fts_rows = store.fts_search(query, limit=top * 8)
    query_vec = np.array(embed_query(query, config), dtype=np.float32)
    vec_rows = store.vector_search(query_vec, limit=top * 8, project=project, since=since)
    store.close()

    combined: dict[str, dict[str, Any]] = {}
    fts_scores = normalize_scores({r["chunk_id"]: abs(float(r.get("rank", 0))) for r in fts_rows})
    vec_scores = normalize_scores({r["chunk_id"]: float(r.get("score", 0)) for r in vec_rows})

    for row in fts_rows + vec_rows:
        cid = row["chunk_id"]
        if cid not in combined:
            combined[cid] = {
                "chunk_id": cid,
                "doc_id": row["doc_id"],
                "path": row["path"],
                "heading": row.get("heading"),
                "line_start": row.get("line_start"),
                "line_end": row.get("line_end"),
                "excerpt": row.get("excerpt"),
                "tier": row.get("tier"),
                "project": row.get("project"),
            }
        base = combined[cid]
        base["score"] = fts_w * fts_scores.get(cid, 0.0) + vec_w * vec_scores.get(cid, 0.0)

    ranked = sorted(combined.values(), key=lambda x: x["score"], reverse=True)
    return simple_mmr(ranked, top_k=top)


def dedupe_search(title: str, config: dict | None = None) -> dict[str, Any]:
    config = config or load_config()
    threshold = float(config.get("search", {}).get("dedupe_threshold", 0.85))
    hits = hybrid_search(title, top=3, config=config)
    if not hits:
        return {"match": False, "threshold": threshold, "hits": []}
    best = hits[0]
    match = float(best.get("score", 0)) >= threshold
    return {
        "match": match,
        "threshold": threshold,
        "best": best if match else None,
        "hits": hits,
    }


def is_index_stale() -> bool:
    manifest = load_manifest()
    if not manifest.get("files"):
        return True
    indexed_at = manifest.get("indexed_at")
    if not indexed_at:
        return True
    for note_path in notes_root().rglob("*.md") if notes_root().is_dir() else []:
        rel = note_path.relative_to(vault_root()).as_posix()
        if rel.startswith("notes/daily/") or rel.startswith("notes/inbox/"):
            continue
        meta = manifest.get("files", {}).get(rel)
        if not meta:
            return True
        mtime = datetime.fromtimestamp(note_path.stat().st_mtime)
        try:
            idx_time = datetime.fromisoformat(str(meta.get("mtime", "")).replace("Z", "+00:00"))
            if mtime > idx_time.replace(tzinfo=None):
                return True
        except ValueError:
            return True
    return False


def main() -> int:
    parser = argparse.ArgumentParser(description="Search vault")
    parser.add_argument("query", nargs="?", default="", help="Search query")
    parser.add_argument("--top", type=int, default=5)
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--project", default=None)
    parser.add_argument("--since", default=None)
    parser.add_argument("--dedupe", metavar="TITLE", help="Dedupe check for new note title")
    args = parser.parse_args()

    try:
        config = load_config()
        if args.dedupe:
            result = dedupe_search(args.dedupe, config)
            print(json.dumps(result, ensure_ascii=False, indent=2))
            return 0

        daily_path = resolve_daily_path(args.query)
        if daily_path:
            payload = {
                "mode": "daily",
                "path": daily_path.relative_to(vault_root()).as_posix(),
                "content": daily_path.read_text(encoding="utf-8"),
            }
            print(json.dumps(payload, ensure_ascii=False, indent=2))
            return 0

        if not args.query.strip():
            print(json.dumps({"ok": False, "error": "query required"}), file=sys.stderr)
            return 1

        results = hybrid_search(
            args.query,
            top=args.top,
            project=args.project,
            since=args.since,
            config=config,
        )
        payload = {"mode": "hybrid", "query": args.query, "results": results}
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0
    except Exception as exc:  # noqa: BLE001
        print(json.dumps({"ok": False, "error": str(exc)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
