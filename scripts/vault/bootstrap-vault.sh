#!/usr/bin/env bash
# Bootstrap Obsidian-native vault layout + _agent catalog (no Python).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERIFY=0
REFRESH_TEMPLATES=0

while [ $# -gt 0 ]; do
  case "$1" in
    --verify) VERIFY=1; shift ;;
    --refresh-templates) REFRESH_TEMPLATES=1; shift ;;
    --repo=*) REPO_ROOT="${1#--repo=}"; shift ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

VAULT="$REPO_ROOT/vault"
AGENT="$VAULT/_agent"
TEMPLATES_RUNTIME="$VAULT/Templates"
TEMPLATES_PACK="$REPO_ROOT/templates/vault"
META_PACK="$TEMPLATES_PACK/meta"
NOTES_PACK="$TEMPLATES_PACK/notes"
OBSIDIAN_PACK="$TEMPLATES_PACK/obsidian"
OBSIDIAN_RUNTIME="$VAULT/.obsidian"

NOTE_DIRS=(daily decisions sessions projects)

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

mkdir -p "$VAULT"
[ -f "$VAULT/.gitkeep" ] || touch "$VAULT/.gitkeep"

for name in "${NOTE_DIRS[@]}"; do
  mkdir -p "$VAULT/$name"
done
mkdir -p "$AGENT" "$TEMPLATES_RUNTIME"

ensure_file_from_template "$AGENT/tiers.json" "$META_PACK/tiers.template.json"
ensure_file_from_template "$AGENT/manifest.json" "$META_PACK/manifest.template.json"

HOME_TARGET="$VAULT/Home.md"
if [ ! -f "$HOME_TARGET" ]; then
  [ -f "$NOTES_PACK/template.vault-home.md" ] || { echo "Missing template.vault-home.md" >&2; exit 1; }
  today="$(date +%Y-%m-%d)"
  sed "s/UPDATED/$today/g" "$NOTES_PACK/template.vault-home.md" > "$HOME_TARGET"
fi

for t in template.vault-daily.md template.vault-session.md template.vault-decision.md template.vault-project.md; do
  src="$NOTES_PACK/$t"
  dest="$TEMPLATES_RUNTIME/$t"
  if [ "$REFRESH_TEMPLATES" -eq 1 ]; then
    [ -f "$src" ] && cp "$src" "$dest"
  elif [ ! -f "$dest" ] && [ -f "$src" ]; then
    cp "$src" "$dest"
  fi
done

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
  [ -d "$TEMPLATES_RUNTIME" ] || { echo "Verify failed: missing Templates/" >&2; exit 1; }
fi

printf 'OK  vault bootstrap: %s\n' "$VAULT"
