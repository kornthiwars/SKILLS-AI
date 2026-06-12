#!/usr/bin/env bash
# Bootstrap vault/notes layout + _meta for agent-only memory (no Python).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VERIFY=0
for arg in "$@"; do
  case "$arg" in
    --verify) VERIFY=1 ;;
    --repo=*) REPO_ROOT="${arg#--repo=}" ;;
  esac
done

VAULT="$REPO_ROOT/vault"
NOTES="$VAULT/notes"
META="$VAULT/_meta"
SCRIPT_VAULT="$REPO_ROOT/scripts/vault"

NOTE_DIRS=(daily decisions sessions projects)

ensure_file_from_template() {
  local target="$1"
  local template="$2"
  [ -f "$target" ] && return 0
  [ -f "$template" ] || { echo "Missing template: $template" >&2; exit 1; }
  mkdir -p "$(dirname "$target")"
  cp "$template" "$target"
}

mkdir -p "$VAULT"
[ -f "$VAULT/.gitkeep" ] || touch "$VAULT/.gitkeep"

for name in "${NOTE_DIRS[@]}"; do
  mkdir -p "$NOTES/$name"
done
mkdir -p "$META"

ensure_file_from_template "$META/tiers.json" "$SCRIPT_VAULT/tiers.template.json"
ensure_file_from_template "$META/manifest.json" "$SCRIPT_VAULT/manifest.template.json"

if [ "$VERIFY" -eq 1 ]; then
  for name in "${NOTE_DIRS[@]}"; do
    [ -d "$NOTES/$name" ] || { echo "Verify failed: missing notes/$name" >&2; exit 1; }
  done
  for f in tiers.json manifest.json; do
    [ -f "$META/$f" ] || { echo "Verify failed: missing _meta/$f" >&2; exit 1; }
  done
fi

printf 'OK  vault bootstrap: %s\n' "$VAULT"
