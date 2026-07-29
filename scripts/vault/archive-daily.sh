#!/usr/bin/env bash
# Archive old project dailies: vault/projects/*/daily/*.md -> .../daily/archive/YYYY/
set -euo pipefail

OLDER_THAN_DAYS=14
BEFORE_DATE=""
PROJECT=""
DRY_RUN=0
REPO_ROOT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --older-than-days) OLDER_THAN_DAYS="$2"; shift 2 ;;
    --before-date) BEFORE_DATE="$2"; shift 2 ;;
    --project) PROJECT="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
PROJECTS_ROOT="$REPO_ROOT/vault/projects"

[ -d "$PROJECTS_ROOT" ] || { echo "Missing vault/projects - run bootstrap-vault first" >&2; exit 1; }

if [ -n "$BEFORE_DATE" ]; then
  cutoff="$BEFORE_DATE"
else
  cutoff="$(date -d "-${OLDER_THAN_DAYS} days" +%Y-%m-%d 2>/dev/null || date -v-"${OLDER_THAN_DAYS}"d +%Y-%m-%d)"
fi

moved=0
for proj_dir in "$PROJECTS_ROOT"/*; do
  [ -d "$proj_dir" ] || continue
  slug="$(basename "$proj_dir")"
  if [ -n "$PROJECT" ]; then
    want="$(printf '%s' "$PROJECT" | tr '[:upper:]' '[:lower:]')"
    [ "$slug" = "$want" ] || continue
  fi
  daily_dir="$proj_dir/daily"
  [ -d "$daily_dir" ] || continue
  for f in "$daily_dir"/*.md; do
    [ -f "$f" ] || continue
    base="$(basename "$f" .md)"
    echo "$base" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' || continue
    [ "$base" \< "$cutoff" ] || continue

    year="${base%%-*}"
    archive_dir="$daily_dir/archive/$year"
    dest="$archive_dir/$(basename "$f")"

    if [ "$DRY_RUN" -eq 1 ]; then
      echo "DRY  $f -> $dest"
    else
      mkdir -p "$archive_dir"
      if [ -f "$dest" ]; then
        echo "SKIP exists: $dest" >&2
        continue
      fi
      mv "$f" "$dest"
      echo "OK   $dest"
    fi
    moved=$((moved + 1))
  done
done

echo "Done archived=$moved cutoff=$cutoff"
