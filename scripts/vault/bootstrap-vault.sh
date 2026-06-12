#!/usr/bin/env bash
# Bootstrap Obsidian-native vault layout + _agent catalog (no Python).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERIFY=0

while [ $# -gt 0 ]; do
  case "$1" in
    --verify) VERIFY=1; shift ;;
    --repo=*) REPO_ROOT="${1#--repo=}"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

VAULT="$REPO_ROOT/vault"
AGENT="$VAULT/_agent"
TEMPLATES_PACK="$REPO_ROOT/templates/vault"
META_PACK="$TEMPLATES_PACK/meta"
NOTES_PACK="$TEMPLATES_PACK/notes"
OBSIDIAN_PACK="$TEMPLATES_PACK/obsidian"
OBSIDIAN_RUNTIME="$VAULT/.obsidian"
LEGACY_TEMPLATES="$VAULT/Templates"

NOTE_DIRS=(daily decisions sessions projects)
PACK_TEMPLATES=(
  template.vault-daily.md
  template.vault-session.md
  template.vault-decision.md
  template.vault-project.md
)

ensure_file_from_template() {
  local target="$1"
  local template="$2"
  [ -f "$target" ] && return 0
  [ -f "$template" ] || { echo "Missing template: $template" >&2; exit 1; }
  mkdir -p "$(dirname "$target")"
  cp "$template" "$target"
}

copy_if_missing() {
  local source="$1"
  local dest="$2"
  [ -f "$dest" ] && return 0
  [ -f "$source" ] || { echo "Missing seed: $source" >&2; exit 1; }
  mkdir -p "$(dirname "$dest")"
  cp "$source" "$dest"
}

remove_legacy_templates_dir() {
  [ -d "$LEGACY_TEMPLATES" ] || return 0
  if [ -L "$LEGACY_TEMPLATES" ]; then
    echo "WARN: vault/Templates is a link — remove manually if you want pack-only templates." >&2
    return 0
  fi

  local unexpected=0
  local f name pack
  shopt -s nullglob
  local files=("$LEGACY_TEMPLATES"/*)
  shopt -u nullglob

  if [ "${#files[@]}" -eq 0 ]; then
    rmdir "$LEGACY_TEMPLATES" 2>/dev/null || rm -rf "$LEGACY_TEMPLATES"
    echo "Removed empty vault/Templates/ (schemas live in templates/vault/notes/)."
    return 0
  fi

  for f in "${files[@]}"; do
    [ -f "$f" ] || continue
    name="$(basename "$f")"
    pack="$NOTES_PACK/$name"
    if [ ! -f "$pack" ] || ! cmp -s "$f" "$pack"; then
      unexpected=1
      echo "WARN: vault/Templates/$name differs from pack or is unknown — not removed." >&2
    fi
  done

  if [ "$unexpected" -eq 0 ]; then
    rm -rf "$LEGACY_TEMPLATES"
    echo "Removed vault/Templates/ copy (use templates/vault/notes/ in git)."
  fi
}

mkdir -p "$VAULT"
[ -f "$VAULT/.gitkeep" ] || touch "$VAULT/.gitkeep"

for name in "${NOTE_DIRS[@]}"; do
  mkdir -p "$VAULT/$name"
done
mkdir -p "$AGENT"

ensure_file_from_template "$AGENT/tiers.json" "$META_PACK/tiers.template.json"
ensure_file_from_template "$AGENT/manifest.json" "$META_PACK/manifest.template.json"

remove_legacy_templates_dir

if [ -d "$OBSIDIAN_PACK" ]; then
  mkdir -p "$OBSIDIAN_RUNTIME"
  for f in "$OBSIDIAN_PACK"/*; do
    [ -f "$f" ] || continue
    copy_if_missing "$f" "$OBSIDIAN_RUNTIME/$(basename "$f")"
  done
fi

if [ -d "$VAULT/notes" ] || [ -d "$VAULT/_meta" ]; then
  echo "WARN: Legacy layout detected (vault/notes/ or vault/_meta/). Run: scripts/vault/migrate-vault.sh" >&2
fi

if [ "$VERIFY" -eq 1 ]; then
  for name in "${NOTE_DIRS[@]}"; do
    [ -d "$VAULT/$name" ] || { echo "Verify failed: missing $name" >&2; exit 1; }
  done
  for f in tiers.json manifest.json; do
    [ -f "$AGENT/$f" ] || { echo "Verify failed: missing _agent/$f" >&2; exit 1; }
  done
  for t in "${PACK_TEMPLATES[@]}"; do
    [ -f "$NOTES_PACK/$t" ] || { echo "Verify failed: missing templates/vault/notes/$t" >&2; exit 1; }
  done
fi

printf 'OK  vault bootstrap: %s\n' "$VAULT"
