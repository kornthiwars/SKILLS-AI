#!/usr/bin/env bash
# Search vault notes (gitignored) — rg --no-ignore; roots from _agent/tiers.json.
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
VAULT="$REPO_ROOT/vault"
TIERS_FILE="$VAULT/_agent/tiers.json"

get_default_roots() {
  if [ -f "$TIERS_FILE" ] && command -v python3 >/dev/null 2>&1; then
    python3 - "$TIERS_FILE" "$VAULT" <<'PY'
import json, sys, os
tiers_path, vault = sys.argv[1], sys.argv[2]
with open(tiers_path, encoding="utf-8") as f:
    data = json.load(f)
for rel in data.get("recall_search_tiers", []):
    rel = rel.replace("notes/", "")
    print(os.path.join(vault, rel))
PY
    return
  fi
  echo "$VAULT/decisions"
  echo "$VAULT/sessions"
  echo "$VAULT/projects"
}

roots=()
case "$TIER" in
  decisions) roots=("$VAULT/decisions") ;;
  sessions)  roots=("$VAULT/sessions") ;;
  projects)  roots=("$VAULT/projects") ;;
  daily)     roots=("$VAULT/daily") ;;
  *)
    while IFS= read -r r; do
      [ -n "$r" ] && roots+=("$r")
    done < <(get_default_roots)
    ;;
esac

existing=()
for r in "${roots[@]}"; do
  [ -d "$r" ] && existing+=("$r")
done

if [ ${#existing[@]} -eq 0 ]; then
  echo '[]'
  exit 0
fi

if command -v rg >/dev/null 2>&1; then
  rg --no-ignore -n --max-count "$MAX" "$PATTERN" "${existing[@]}" 2>/dev/null | \
    awk -v repo="$REPO_ROOT" -F: 'BEGIN{print "["} {
      path=$1; sub(repo"/","",path); gsub(/\\/,"/",path);
      line=$2; excerpt=$3;
      for(i=4;i<=NF;i++) excerpt=excerpt ":" $i;
      gsub(/"/,"\\\"",excerpt);
      printf "%s{\"path\":\"%s\",\"line\":%s,\"excerpt\":\"%s\"}", (NR>1?",":""), path, line, excerpt
    } END{print "]"}' || echo '[]'
else
  echo '[]'
  exit 0
fi
