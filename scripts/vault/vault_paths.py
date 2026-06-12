"""Resolve agent-skills repo and vault directories."""

from __future__ import annotations

from pathlib import Path

_SCRIPTS_VAULT = Path(__file__).resolve().parent


def repo_root() -> Path:
    return _SCRIPTS_VAULT.parent.parent


def vault_root() -> Path:
    return repo_root() / "vault"


def notes_root() -> Path:
    return vault_root() / "notes"


def index_dir() -> Path:
    return vault_root() / "_index"


def config_path() -> Path:
    return index_dir() / "config.json"


def manifest_path() -> Path:
    return index_dir() / "manifest.json"


def db_path() -> Path:
    return index_dir() / "vectors.sqlite"
