#!/usr/bin/env bash
# Append bullet and/or Issues row to today's daily (vault autolog).
set -euo pipefail

BULLET=""
ISSUE=""
REPO_ROOT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --bullet) BULLET="$2"; shift 2 ;;
    --issue) ISSUE="$2"; shift 2 ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[ -n "$BULLET$ISSUE" ] || { echo "Provide --bullet and/or --issue" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
NOTES_PACK="$REPO_ROOT/templates/vault/notes"
TEMPLATE_FILE="$NOTES_PACK/template.vault-daily.md"

date="$(date +%Y-%m-%d)"
iso="$(date -Iseconds)"
daily_file="$REPO_ROOT/vault/daily/$date.md"
daily_dir="$(dirname "$daily_file")"

[ -d "$daily_dir" ] || {
  echo "Vault layout missing: run scripts/vault/bootstrap-vault.sh --verify first" >&2
  exit 1
}

if [ ! -f "$daily_file" ]; then
  [ -f "$TEMPLATE_FILE" ] || { echo "Missing template: $TEMPLATE_FILE" >&2; exit 1; }
  sed "s/__VAULT_DATE__/$date/g; s/__VAULT_ISO__/$iso/g" "$TEMPLATE_FILE" > "$daily_file"
  echo "INIT daily created"
fi

runs="$(grep -E '^runs:' "$daily_file" | head -1 | sed 's/runs:[[:space:]]*//' | tr -d '"')"
runs=$((runs + 1))

bullet_line=""
if [ -n "$BULLET" ]; then
  case "$BULLET" in
    -*) bullet_line="$BULLET" ;;
    *) bullet_line="- $BULLET" ;;
  esac
  if grep -qF -- "$bullet_line" "$daily_file"; then
    echo "SKIP duplicate bullet"
    bullet_line=""
  fi
fi

issue_row=""
if [ -n "$ISSUE" ]; then
  issue_row="| iss-${date}-${runs} | ${ISSUE} | open | daily_only | |"
  if grep -qF -- "$issue_row" "$daily_file"; then
    echo "SKIP duplicate issue row"
    issue_row=""
  fi
fi

tmp="$(mktemp)"
awk -v bullet="$bullet_line" -v issue_row="$issue_row" -v iso="$iso" -v runs="$runs" '
  /^updated_at:/ { print "updated_at: \"" iso "\""; next }
  /^runs:/ { print "runs: " runs; next }
  /^## สรุปงานวันนี้/ {
    print
    if (bullet != "") {
      print bullet
      bullet = ""
    }
    next
  }
  /^## Issues/ {
    print
    next
  }
  /^\|----\|/ {
    print
    if (issue_row != "") {
      print issue_row
    }
    next
  }
  { print }
' "$daily_file" > "$tmp"
mv "$tmp" "$daily_file"

echo "OK runs=$runs"
echo "$daily_file"
