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
ASSETS="$VAULT/assets"
SCRIPT_VAULT="$REPO_ROOT/scripts/vault"

NOTE_DIRS=(daily daily/archive decisions sessions projects inbox)

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
mkdir -p "$ASSETS" "$META"

ensure_file_from_template "$META/tiers.json" "$SCRIPT_VAULT/tiers.template.json"
ensure_file_from_template "$META/manifest.json" "$SCRIPT_VAULT/manifest.template.json"

ensure_today_daily() {
  local date iso daily_file template daily_id
  date="$(date +%Y-%m-%d)"
  iso="$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S%z')"
  daily_file="$NOTES/daily/$date.md"
  template="$SCRIPT_VAULT/daily.template.md"
  daily_id="daily-$date"

  if [ ! -f "$daily_file" ]; then
    [ -f "$template" ] || { echo "Missing template: $template" >&2; exit 1; }
    sed "s/DATE/$date/g; s/ISO/$iso/g" "$template" > "$daily_file"
    printf 'OK  daily seeded: notes/daily/%s.md\n' "$date"
  fi

  if [ ! -f "$META/manifest.json" ]; then
    return 0
  fi
  if grep -q "\"id\": \"$daily_id\"" "$META/manifest.json"; then
    return 0
  fi

  if command -v jq >/dev/null 2>&1; then
    local tmp
    tmp="$(mktemp)"
    jq --arg id "$daily_id" \
      --arg path "notes/daily/$date.md" \
      --arg title "Daily $date" \
      --arg date "$date" \
      --arg iso "$iso" \
      '.updated_at = $iso
       | .docs += [{
           id: $id,
           path: $path,
           title: $title,
           tier: "episodic",
           project: "",
           status: "active",
           updated: $date
         }]' "$META/manifest.json" > "$tmp"
    mv "$tmp" "$META/manifest.json"
    printf 'OK  manifest: %s\n' "$daily_id"
  else
    printf '..  manifest: install jq to auto-register %s (or run /vault-daily)\n' "$daily_id" >&2
  fi
}

ensure_today_daily

if [ "$VERIFY" -eq 1 ]; then
  for name in "${NOTE_DIRS[@]}"; do
    [ -d "$NOTES/$name" ] || { echo "Verify failed: missing notes/$name" >&2; exit 1; }
  done
  for f in tiers.json manifest.json; do
    [ -f "$META/$f" ] || { echo "Verify failed: missing _meta/$f" >&2; exit 1; }
  done
fi

printf 'OK  vault bootstrap: %s\n' "$VAULT"
