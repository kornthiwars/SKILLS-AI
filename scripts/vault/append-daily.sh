#!/usr/bin/env bash
# Append one bullet to today's daily note (vault autolog).
set -euo pipefail

BULLET=""
REPO_ROOT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --bullet) BULLET="$2"; shift 2 ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[ -n "$BULLET" ] || { echo "Missing --bullet" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"

date="$(date +%Y-%m-%d)"
iso="$(date -Iseconds)"
daily_file="$REPO_ROOT/vault/daily/$date.md"
daily_dir="$(dirname "$daily_file")"

[ -d "$daily_dir" ] || {
  echo "Vault layout missing: run scripts/vault/bootstrap-vault.sh --verify first" >&2
  exit 1
}
[ -f "$daily_file" ] || {
  echo "Daily file missing: $daily_file — Write from templates/vault/notes/template.vault-daily.md (DATE/ISO) first" >&2
  exit 1
}

case "$BULLET" in
  -*) bullet_line="$BULLET" ;;
  *) bullet_line="- $BULLET" ;;
esac

if grep -qF "$bullet_line" "$daily_file"; then
  echo "SKIP duplicate"
  echo "$daily_file"
  exit 0
fi

runs="$(grep -E '^runs:' "$daily_file" | sed 's/runs:[[:space:]]*//')"
runs=$((runs + 1))

tmp="$(mktemp)"
awk -v bullet="$bullet_line" -v iso="$iso" -v runs="$runs" '
  /^updated_at:/ { print "updated_at: \"" iso "\""; next }
  /^runs:/ { print "runs: " runs; next }
  /^## Issues/ { print bullet; print ""; print; next }
  { print }
' "$daily_file" > "$tmp"
mv "$tmp" "$daily_file"

echo "OK runs=$runs"
echo "$daily_file"
