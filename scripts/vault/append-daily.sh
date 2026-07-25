#!/usr/bin/env bash
# Append bullet and/or Issues row to today's daily for one project (vault autolog).
set -euo pipefail

BULLET=""
ISSUE=""
PROJECT="${VAULT_PROJECT:-}"
REPO_ROOT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --bullet) BULLET="$2"; shift 2 ;;
    --issue) ISSUE="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[ -n "$BULLET$ISSUE" ] || { echo "Provide --bullet and/or --issue" >&2; exit 1; }
[ -n "$PROJECT" ] || { echo "Provide --project or set VAULT_PROJECT" >&2; exit 1; }

PROJECT="$(printf '%s' "$PROJECT" | tr '[:upper:]' '[:lower:]')"
case "$PROJECT" in
  ''|*[!a-z0-9_-]* ) echo "Project must be [a-z0-9_-] length 1–64" >&2; exit 1 ;;
esac
[ "${#PROJECT}" -le 64 ] || { echo "Project must be [a-z0-9_-] length 1–64" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="${REPO_ROOT:-$PACK_ROOT}"
TEMPLATE_FILE="$PACK_ROOT/templates/vault/notes/template.vault-daily.md"
[ -f "$TEMPLATE_FILE" ] || TEMPLATE_FILE="$REPO_ROOT/templates/vault/notes/template.vault-daily.md"

date="$(date +%Y-%m-%d)"
iso="$(date -Iseconds)"
daily_file="$REPO_ROOT/vault/daily/${date}__${PROJECT}.md"
daily_dir="$(dirname "$daily_file")"

[ -d "$daily_dir" ] || {
  echo "Vault layout missing: run scripts/vault/bootstrap-vault.sh --verify first" >&2
  exit 1
}

remote_event() {
  local kind="$1" text="$2"
  local base="${VAULT_REMOTE_URL:-}" token="${VAULT_AGENT_TOKEN:-}"
  [ -n "$base" ] && [ -n "$token" ] || return 0
  base="${base%/}"
  local uri="$base/vault/v2/daily/$date/projects/$PROJECT/events"
  if command -v curl >/dev/null 2>&1; then
    if curl -fsS -m 8 -X POST "$uri" \
      -H "Authorization: Bearer $token" \
      -H "Content-Type: application/json" \
      -d "{\"kind\":\"$kind\",\"text\":$(printf '%s' "$text" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))' 2>/dev/null || printf '"%s"' "$text"),\"source\":\"append-daily\"}" \
      >/dev/null 2>&1; then
      echo "REMOTE ok $uri"
    else
      echo "REMOTE skip: request failed"
    fi
  fi
}

if [ ! -f "$daily_file" ]; then
  [ -f "$TEMPLATE_FILE" ] || { echo "Missing template: $TEMPLATE_FILE" >&2; exit 1; }
  daily_id="daily-${date}__${PROJECT}"
  sed "s/__VAULT_DAILY_ID__/$daily_id/g; s/__VAULT_DATE__/$date/g; s/__VAULT_ISO__/$iso/g; s/__VAULT_PROJECT__/$PROJECT/g" "$TEMPLATE_FILE" > "$daily_file"
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
  else
    remote_event bullet "${BULLET#- }"
  fi
fi

issue_row=""
if [ -n "$ISSUE" ]; then
  issue_row="| iss-${date}-${runs} | ${ISSUE} | open | daily_only | |"
  if grep -qF -- "$issue_row" "$daily_file"; then
    echo "SKIP duplicate issue row"
    issue_row=""
  else
    remote_event issue "$ISSUE"
  fi
fi

tmp="$(mktemp)"
awk -v bullet="$bullet_line" -v issue_row="$issue_row" -v iso="$iso" -v runs="$runs" -v project="$PROJECT" '
  BEGIN { fm = 0; fm_closed = 0; summary_done = 0 }
  /^---$/ {
    if (fm) { fm_closed = 1; fm = 0 } else { fm = 1 }
    print
    next
  }
  /^project:/ { print "project: \"" project "\""; next }
  /^updated_at:/ { print "updated_at: \"" iso "\""; next }
  /^runs:/ { print "runs: " runs; next }
  fm_closed && !summary_done && /^## / {
    print
    if (bullet != "") {
      print bullet
      bullet = ""
    }
    summary_done = 1
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

echo "OK runs=$runs project=$PROJECT"
echo "$daily_file"
