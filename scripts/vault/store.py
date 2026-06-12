"""SQLite store for chunk metadata, FTS, and embeddings."""

from __future__ import annotations

import json
import sqlite3
import struct
from pathlib import Path
from typing import Any

import numpy as np

from vault_paths import db_path, manifest_path


def vector_to_blob(vec: list[float]) -> bytes:
    return struct.pack(f"{len(vec)}f", *vec)


def blob_to_vector(blob: bytes) -> np.ndarray:
    count = len(blob) // 4
    return np.array(struct.unpack(f"{count}f", blob), dtype=np.float32)


class VaultStore:
    def __init__(self, path: Path | None = None) -> None:
        self.path = path or db_path()
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.conn = sqlite3.connect(self.path)
        self.conn.row_factory = sqlite3.Row
        self._init_schema()

    def close(self) -> None:
        self.conn.close()

    def _init_schema(self) -> None:
        self.conn.executescript(
            """
            CREATE TABLE IF NOT EXISTS chunks (
                chunk_id TEXT PRIMARY KEY,
                doc_id TEXT NOT NULL,
                path TEXT NOT NULL,
                heading TEXT,
                line_start INTEGER,
                line_end INTEGER,
                excerpt TEXT,
                tier TEXT,
                project TEXT,
                doc_updated TEXT,
                embedding BLOB
            );
            CREATE INDEX IF NOT EXISTS idx_chunks_doc ON chunks(doc_id);
            CREATE INDEX IF NOT EXISTS idx_chunks_path ON chunks(path);
            CREATE INDEX IF NOT EXISTS idx_chunks_project ON chunks(project);

            CREATE VIRTUAL TABLE IF NOT EXISTS chunks_fts USING fts5(
                chunk_id UNINDEXED,
                doc_id UNINDEXED,
                path UNINDEXED,
                excerpt,
                heading
            );
            """
        )
        self.conn.commit()

    def delete_doc_chunks(self, doc_id: str) -> None:
        cur = self.conn.execute("SELECT chunk_id FROM chunks WHERE doc_id = ?", (doc_id,))
        chunk_ids = [row[0] for row in cur.fetchall()]
        self.conn.execute("DELETE FROM chunks WHERE doc_id = ?", (doc_id,))
        for chunk_id in chunk_ids:
            self.conn.execute("DELETE FROM chunks_fts WHERE chunk_id = ?", (chunk_id,))
        self.conn.commit()

    def upsert_chunk(
        self,
        *,
        chunk_id: str,
        doc_id: str,
        path: str,
        heading: str,
        line_start: int,
        line_end: int,
        excerpt: str,
        tier: str,
        project: str | None,
        doc_updated: str | None,
        embedding: list[float],
    ) -> None:
        self.conn.execute(
            """
            INSERT INTO chunks (
                chunk_id, doc_id, path, heading, line_start, line_end,
                excerpt, tier, project, doc_updated, embedding
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(chunk_id) DO UPDATE SET
                doc_id=excluded.doc_id,
                path=excluded.path,
                heading=excluded.heading,
                line_start=excluded.line_start,
                line_end=excluded.line_end,
                excerpt=excluded.excerpt,
                tier=excluded.tier,
                project=excluded.project,
                doc_updated=excluded.doc_updated,
                embedding=excluded.embedding
            """,
            (
                chunk_id,
                doc_id,
                path,
                heading,
                line_start,
                line_end,
                excerpt,
                tier,
                project,
                doc_updated,
                vector_to_blob(embedding),
            ),
        )
        self.conn.execute(
            "DELETE FROM chunks_fts WHERE chunk_id = ?",
            (chunk_id,),
        )
        self.conn.execute(
            """
            INSERT INTO chunks_fts (chunk_id, doc_id, path, excerpt, heading)
            VALUES (?, ?, ?, ?, ?)
            """,
            (chunk_id, doc_id, path, excerpt, heading),
        )

    def commit(self) -> None:
        self.conn.commit()

    def rebuild_fts(self) -> None:
        self.conn.execute("DELETE FROM chunks_fts")
        self.conn.execute(
            """
            INSERT INTO chunks_fts (chunk_id, doc_id, path, excerpt, heading)
            SELECT chunk_id, doc_id, path, excerpt, heading FROM chunks
            """
        )
        self.conn.commit()

    def all_chunks(self) -> list[sqlite3.Row]:
        cur = self.conn.execute("SELECT * FROM chunks")
        return list(cur.fetchall())

    def fts_search(self, query: str, limit: int = 50) -> list[dict[str, Any]]:
        safe = " ".join(w for w in query.split() if w.strip())
        if not safe:
            return []
        try:
            cur = self.conn.execute(
                """
                SELECT c.chunk_id, c.doc_id, c.path, c.heading, c.line_start, c.line_end,
                       c.excerpt, c.tier, c.project, c.embedding,
                       bm25(chunks_fts) AS rank
                FROM chunks_fts f
                JOIN chunks c ON c.chunk_id = f.chunk_id
                WHERE chunks_fts MATCH ?
                ORDER BY rank
                LIMIT ?
                """,
                (safe, limit),
            )
        except sqlite3.OperationalError:
            return []
        rows = []
        for row in cur.fetchall():
            rows.append(dict(row))
        return rows

    def vector_search(
        self,
        query_vec: np.ndarray,
        limit: int = 50,
        project: str | None = None,
        since: str | None = None,
    ) -> list[dict[str, Any]]:
        sql = "SELECT * FROM chunks WHERE embedding IS NOT NULL"
        params: list[Any] = []
        if project:
            sql += " AND project = ?"
            params.append(project)
        if since:
            sql += " AND (doc_updated IS NULL OR doc_updated >= ?)"
            params.append(since)
        cur = self.conn.execute(sql, params)
        scored: list[tuple[float, dict[str, Any]]] = []
        qnorm = np.linalg.norm(query_vec) or 1.0
        for row in cur.fetchall():
            vec = blob_to_vector(row["embedding"])
            denom = (np.linalg.norm(vec) * qnorm) or 1.0
            score = float(np.dot(query_vec, vec) / denom)
            scored.append((score, dict(row)))
        scored.sort(key=lambda x: x[0], reverse=True)
        return [item[1] | {"score": item[0]} for item in scored[:limit]]


def load_manifest() -> dict[str, Any]:
    path = manifest_path()
    if not path.is_file():
        return {"indexed_at": None, "files": {}}
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def save_manifest(manifest: dict[str, Any]) -> None:
    path = manifest_path()
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2, ensure_ascii=False)
        f.write("\n")
