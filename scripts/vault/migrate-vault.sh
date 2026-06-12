#!/usr/bin/env bash
# Migrate vault v1 (notes/* + _meta/) to Obsidian-native flat layout + _agent/.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WHAT_IF=0

while [ $# -gt 0 ]; do
  case "$1" in
    --what-if) WHAT_IF=1; shift ;;
    --repo=*) REPO_ROOT="${1#--repo=}"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

VAULT="$REPO_ROOT/vault"
LEGACY_NOTES="$VAULT/notes"
LEGACY_META="$VAULT/_meta"
AGENT="$VAULT/_agent"

move_tier() {
  local tier="$1"
  local src="$LEGACY_NOTES/$tier"
  local dest="$VAULT/$tier"
  [ -d "$src" ] || return 0
  mkdir -p "$dest"
  shopt -s nullglob
  for f in "$src"/*; do
    [ -f "$f" ] || continue
    local base
    base="$(basename "$f")"
    if [ -f "$dest/$base" ]; then
      echo "Collision: $dest/$base already exists" >&2
      exit 1
    fi
    if [ "$WHAT_IF" -eq 1 ]; then
      echo "Would move: $f -> $dest/$base"
    else
      mv "$f" "$dest/$base"
      echo "Moved: $base -> $tier/"
    fi
  done
}

if [ ! -d "$LEGACY_NOTES" ] && [ ! -d "$LEGACY_META" ]; then
  echo "Nothing to migrate (no vault/notes/ or vault/_meta/)"
  exit 0
fi

for tier in daily decisions sessions projects; do
  move_tier "$tier"
done

if [ -d "$LEGACY_NOTES" ] && [ "$WHAT_IF" -eq 0 ]; then
  if [ -z "$(find "$LEGACY_NOTES" -type f 2>/dev/null)" ]; then
    rmdir "$LEGACY_NOTES" 2>/dev/null || rm -rf "$LEGACY_NOTES"
    echo "Removed empty vault/notes/"
  fi
fi

if [ -d "$LEGACY_META" ]; then
  mkdir -p "$AGENT"
  for f in manifest.json tiers.json; do
    src="$LEGACY_META/$f"
    dest="$AGENT/$f"
    [ -f "$src" ] || continue
    if [ -f "$dest" ]; then
      echo "WARN: skipping $f - already in _agent/" >&2
    elif [ "$WHAT_IF" -eq 1 ]; then
      echo "Would move: $src -> $dest"
    else
      mv "$src" "$dest"
      echo "Moved: _meta/$f -> _agent/$f"
    fi
  done
  if [ "$WHAT_IF" -eq 0 ] && [ -z "$(find "$LEGACY_META" -type f 2>/dev/null)" ]; then
    rmdir "$LEGACY_META" 2>/dev/null || rm -rf "$LEGACY_META"
    echo "Removed empty vault/_meta/"
  fi
fi

MANIFEST="$AGENT/manifest.json"
if [ -f "$MANIFEST" ] && [ "$WHAT_IF" -eq 0 ]; then
  tmp="$(mktemp)"
  sed \
    -e 's|notes/daily/|daily/|g' \
    -e 's|notes/decisions/|decisions/|g' \
    -e 's|notes/sessions/|sessions/|g' \
    -e 's|notes/projects/|projects/|g' \
    -e 's/"schema_version": 1/"schema_version": 2/' \
    "$MANIFEST" > "$tmp"
  mv "$tmp" "$MANIFEST"
  echo "Rewrote manifest paths (schema v2)"
fi

TIERS="$AGENT/tiers.json"
if [ -f "$TIERS" ] && [ "$WHAT_IF" -eq 0 ]; then
  tmp="$(mktemp)"
  sed \
    -e 's|"notes/daily"|"daily"|g' \
    -e 's|"notes/decisions"|"decisions"|g' \
    -e 's|"notes/sessions"|"sessions"|g' \
    -e 's|"notes/projects"|"projects"|g' \
    -e 's|notes/daily/\*\*|daily/**|g' \
    -e 's/"schema_version": 1/"schema_version": 2/' \
    "$TIERS" > "$tmp"
  mv "$tmp" "$TIERS"
  echo "Rewrote tiers.json paths (schema v2)"
fi

echo "OK  migrate-vault complete. Run bootstrap-vault.sh --verify to confirm layout."
