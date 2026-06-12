"""Split markdown notes into chunks for embedding."""

from __future__ import annotations

import hashlib
import re
from dataclasses import dataclass
from typing import Any

import yaml

_FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)
_HEADING_RE = re.compile(r"^(#{1,6})\s+(.+)$", re.MULTILINE)


@dataclass
class Chunk:
    text: str
    heading: str
    line_start: int
    line_end: int


@dataclass
class ParsedNote:
    path_rel: str
    frontmatter: dict[str, Any]
    body: str
    body_line_offset: int


def parse_note(path_rel: str, content: str) -> ParsedNote:
    match = _FRONTMATTER_RE.match(content)
    if match:
        raw_fm = match.group(1)
        try:
            frontmatter = yaml.safe_load(raw_fm) or {}
        except yaml.YAMLError:
            frontmatter = {}
        body = content[match.end() :]
        body_line_offset = content[: match.end()].count("\n") + 1
    else:
        frontmatter = {}
        body = content
        body_line_offset = 1
    if not isinstance(frontmatter, dict):
        frontmatter = {}
    return ParsedNote(path_rel, frontmatter, body, body_line_offset)


def doc_id_from_note(parsed: ParsedNote, path_rel: str) -> str:
    note_id = parsed.frontmatter.get("id")
    if note_id:
        return str(note_id)
    stem = path_rel.replace("\\", "/").rsplit("/", 1)[-1]
    if stem.endswith(".md"):
        stem = stem[:-3]
    return stem


def chunk_note(parsed: ParsedNote, max_chars: int = 2000, overlap_chars: int = 256) -> list[Chunk]:
    body = parsed.body.strip()
    if not body:
        return []

    sections: list[tuple[str, str, int]] = []
    matches = list(_HEADING_RE.finditer(body))
    if not matches:
        sections.append(("", body, parsed.body_line_offset))
    else:
        for idx, match in enumerate(matches):
            heading = match.group(2).strip()
            start = match.end()
            end = matches[idx + 1].start() if idx + 1 < len(matches) else len(body)
            section_text = body[start:end].strip()
            line_start = parsed.body_line_offset + body[: match.start()].count("\n")
            if section_text:
                sections.append((heading, section_text, line_start))

    chunks: list[Chunk] = []
    for heading, text, line_start in sections:
        chunks.extend(_split_text(text, heading, line_start, max_chars, overlap_chars))
    return chunks


def _split_text(
    text: str,
    heading: str,
    line_start: int,
    max_chars: int,
    overlap_chars: int,
) -> list[Chunk]:
    if len(text) <= max_chars:
        line_end = line_start + text.count("\n")
        return [Chunk(text=text, heading=heading, line_start=line_start, line_end=line_end)]

    parts: list[Chunk] = []
    start = 0
    while start < len(text):
        end = min(start + max_chars, len(text))
        if end < len(text):
            break_at = text.rfind("\n\n", start, end)
            if break_at > start + max_chars // 2:
                end = break_at
        piece = text[start:end].strip()
        if piece:
            piece_line_start = line_start + text[:start].count("\n")
            piece_line_end = piece_line_start + piece.count("\n")
            parts.append(
                Chunk(
                    text=piece,
                    heading=heading,
                    line_start=piece_line_start,
                    line_end=piece_line_end,
                )
            )
        if end >= len(text):
            break
        start = max(end - overlap_chars, start + 1)
    return parts


def content_hash(content: str) -> str:
    digest = hashlib.sha256(content.encode("utf-8")).hexdigest()
    return f"sha256:{digest}"
