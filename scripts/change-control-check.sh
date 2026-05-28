#!/usr/bin/env bash
# Enforce patch budget from change-control-manifest.mdc on working tree diff
# Usage: ./scripts/change-control-check.sh
# Env: MAX_FILES=5 MAX_LINES=120 SKIP_CHANGE_CONTROL=1 to bypass
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

MAX_FILES="${MAX_FILES:-5}"
MAX_LINES="${MAX_LINES:-120}"

if [ "${SKIP_CHANGE_CONTROL:-}" = "1" ]; then
  printf 'SKIP change-control-check (SKIP_CHANGE_CONTROL=1)\n'
  exit 0
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  printf 'Not a git repo — skip change-control-check\n'
  exit 0
fi

file_count=0
line_total=0
while IFS=$'\t' read -r add del file; do
  [ -z "${file:-}" ] && continue
  file_count=$((file_count + 1))
  case "$add" in
    ''|-) add=0 ;;
  esac
  case "$del" in
    ''|-) del=0 ;;
  esac
  if [ "$add" -eq "$add" ] 2>/dev/null && [ "$del" -eq "$del" ] 2>/dev/null; then
    line_total=$((line_total + add + del))
  fi
done < <(git diff --numstat HEAD 2>/dev/null || git diff --numstat 2>/dev/null || true)

if [ "$file_count" -eq 0 ]; then
  printf 'PASS no diff — change-control-check\n'
  exit 0
fi

printf 'Change-control: %s files, %s lines (budget: %s files, %s lines)\n' \
  "$file_count" "$line_total" "$MAX_FILES" "$MAX_LINES"

if [ "$file_count" -le "$MAX_FILES" ] && [ "$line_total" -le "$MAX_LINES" ]; then
  printf 'PASS change-control-check\n'
  exit 0
fi

if git log -1 --format=%B 2>/dev/null | grep -q '\[BUDGET-OVERRIDE\]'; then
  printf 'PASS change-control-check ([BUDGET-OVERRIDE] in HEAD commit message)\n'
  exit 0
fi

printf 'FAIL change-control-check — budget exceeded\n'
printf '  Reduce scope, split work, or use [BUDGET-OVERRIDE] with explicit user approval\n'
exit 1
