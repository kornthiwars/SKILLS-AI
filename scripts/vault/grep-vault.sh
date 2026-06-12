#!/usr/bin/env bash
# Search vault notes (gitignored) — rg --no-ignore when available.
set -euo pipefail

PATTERN=""
TIER="all"
MAX=30
REPO_ROOT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --pattern) PATTERN="$2"; shift 2 ;;
    --tier) TIER="$2"; shift 2 ;;
    --max) MAX="$2"; shift 2 ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[ -n "$PATTERN" ] || { echo "Missing --pattern" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
NOTES="$REPO_ROOT/vault/notes"

roots=()
case "$TIER" in
  decisions) roots=("$NOTES/decisions") ;;
  sessions)  roots=("$NOTES/sessions") ;;
  projects)  roots=("$NOTES/projects") ;;
  daily)     roots=("$NOTES/daily") ;;
  *)         roots=("$NOTES/decisions" "$NOTES/sessions" "$NOTES/projects") ;;
esac

if command -v rg >/dev/null 2>&1; then
  existing=()
  for r in "${roots[@]}"; do
    [ -d "$r" ] && existing+=("$r")
  done
  if [ ${#existing[@]} -eq 0 ]; then
    echo '[]'
    exit 0
  fi
  rg --no-ignore -n --max-count "$MAX" "$PATTERN" "${existing[@]}" 2>/dev/null | \
    awk -v repo="$REPO_ROOT" -F: 'BEGIN{print "["} {
      path=$1; sub(repo"/","",path); gsub(/\\/,"/",path);
      line=$2; excerpt=$3;
      for(i=4;i<=NF;i++) excerpt=excerpt ":" $i;
      printf "%s{\"path\":\"%s\",\"line\":%s,\"excerpt\":\"%s\"}", (NR>1?",":""), path, line, excerpt
    } END{print "]"}' || echo '[]'
else
  echo '[]'
  exit 0
fi
