#!/usr/bin/env bash
# Cursor afterFileEdit hook — incremental vault index (fail open)
set +e
input="$(cat)"
file_path="$(printf '%s' "$input" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("file_path",""))' 2>/dev/null || true)"
case "$file_path" in
  */vault/notes/*) ;;
  *) exit 0 ;;
esac
case "$file_path" in
  */daily/*|*/inbox/*) exit 0 ;;
esac

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_ROOT="$(cd "$HOOK_DIR/../.." && pwd)"
VAULT_LINK="$INSTALL_ROOT/.cursor/vault"
[ -L "$VAULT_LINK" ] || exit 0
VAULT_TARGET="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$VAULT_LINK" 2>/dev/null || readlink -f "$VAULT_LINK" 2>/dev/null || true)"
[ -n "$VAULT_TARGET" ] || exit 0
REPO_ROOT="$(dirname "$VAULT_TARGET")"
INDEX_PY="$REPO_ROOT/scripts/vault/index.py"
[ -f "$INDEX_PY" ] || exit 0

cd "$REPO_ROOT" || exit 0
if command -v python3 >/dev/null 2>&1; then
  python3 "$INDEX_PY" >/dev/null 2>&1
elif command -v python >/dev/null 2>&1; then
  python "$INDEX_PY" >/dev/null 2>&1
fi
exit 0
