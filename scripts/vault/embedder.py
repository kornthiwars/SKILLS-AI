"""Local embedding via fastembed."""

from __future__ import annotations

from typing import Any

_embedder = None
_model_name: str | None = None


def get_embedder(config: dict[str, Any]):
    global _embedder, _model_name
    emb = config.get("embedding", {})
    model = emb.get("model", "BAAI/bge-m3")
    if _embedder is not None and _model_name == model:
        return _embedder

    from fastembed import TextEmbedding

    _model_name = model
    try:
        _embedder = TextEmbedding(model_name=model)
    except Exception:
        fallback = "BAAI/bge-small-en-v1.5"
        _model_name = fallback
        _embedder = TextEmbedding(model_name=fallback)
    return _embedder


def embed_texts(texts: list[str], config: dict[str, Any]) -> list[list[float]]:
    if not texts:
        return []
    model = get_embedder(config)
    return [vec.tolist() for vec in model.embed(texts)]


def embed_query(query: str, config: dict[str, Any]) -> list[float]:
    vectors = embed_texts([query], config)
    return vectors[0] if vectors else []
