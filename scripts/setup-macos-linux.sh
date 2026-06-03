#!/usr/bin/env bash
# Symlink .cursor/skills, .cursor/rules, .cursor/vault + ai-skills-vault.json
# Usage: ./scripts/setup-macos-linux.sh [install-root]
# Default (no arg): parent of agent-skills — typical when Cursor opens the project folder.
# Use "." or "--here" when Cursor opens agent-skills/ itself.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

resolve_install_root() {
  case "${1:-}" in
    '' | --parent | parent)
      cd "$REPO_ROOT/.." && pwd
      ;;
    --here | here | .)
      printf '%s\n' "$REPO_ROOT"
      ;;
    *)
      cd "$1" && pwd
      ;;
  esac
}

INSTALL_ROOT="$(resolve_install_root "${1:-}")"

SKILLS="$REPO_ROOT/ai-skills"
RULES="$REPO_ROOT/ai-rules"
VAULT="$REPO_ROOT/vault"

for dir in "$SKILLS" "$RULES" "$VAULT"; do
  [ -d "$dir" ] || { echo "Missing: $dir" >&2; exit 1; }
done

link_dir() {
  local link_path="$1"
  local target_path="$2"
  local target_abs parent existing_abs

  target_abs="$(cd "$target_path" && pwd)"
  parent="$(dirname "$link_path")"
  mkdir -p "$parent"

  if [ -e "$link_path" ] || [ -L "$link_path" ]; then
    if [ -L "$link_path" ]; then
      existing_abs="$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$link_path")"
      if [ "$existing_abs" = "$target_abs" ]; then
        printf 'OK  %s\n' "$link_path"
        return 0
      fi
    fi
    rm -rf "$link_path"
  fi

  ln -sfn "$target_abs" "$link_path"
  printf 'OK  %s -> %s\n' "$link_path" "$target_abs"
}

write_vault_pointer() {
  local cursor_dir="$INSTALL_ROOT/.cursor"
  local vault_abs json_path

  mkdir -p "$cursor_dir"
  vault_abs="$(cd "$VAULT" && pwd)"

  json_path="$cursor_dir/ai-skills-vault.json"
  python3 - "$json_path" "$REPO_ROOT" "$vault_abs" <<'PY'
import json, sys
path, repo_root, vault_root = sys.argv[1:4]
data = {
    "repoRoot": repo_root,
    "vaultRoot": vault_root,
    "issuesRelative": ".cursor/vault/issues",
    "learningsRelative": ".cursor/vault/learnings",
    "workdayRelative": ".cursor/vault/workday",
}
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)
PY
  printf 'OK  %s\n' "$json_path"
}

ensure_vault_folders() {
  local rel path
  for rel in issues learnings workday; do
    path="$VAULT/$rel"
    if [ ! -d "$path" ]; then
      mkdir -p "$path"
      printf 'OK  created vault/%s\n' "$rel"
    fi
  done
}

bootstrap_daily_issues() {
  local today file template
  today="$(date +%Y-%m-%d)"
  file="$VAULT/issues/$today.md"

  if [ -f "$file" ]; then
    printf 'OK  vault/issues/%s.md\n' "$today"
    return 0
  fi

  template="$REPO_ROOT/templates/template.issue.md"
  if [ ! -f "$template" ]; then
    printf '..  skip daily issues (no template)\n'
    return 0
  fi

  sed "s/{{YYYY-MM-DD}}/$today/g" "$template" >"$file"
  printf 'OK  created vault/issues/%s.md\n' "$today"
}

cleanup_in_repo_cursor() {
  local skills_link="$REPO_ROOT/.cursor/skills"
  local skills_target

  [ "$INSTALL_ROOT" = "$REPO_ROOT" ] && return 0
  [ ! -L "$skills_link" ] && return 0

  skills_target="$(python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$skills_link")"
  [ "$skills_target" = "$(cd "$SKILLS" && pwd)" ] || return 0

  rm -rf "$REPO_ROOT/.cursor"
  printf 'OK  removed in-repo .cursor (links now at parent)\n'
}

printf 'Install: %s\n' "$INSTALL_ROOT"
printf 'Repo:    %s\n\n' "$REPO_ROOT"

cleanup_in_repo_cursor

link_dir "$INSTALL_ROOT/.cursor/skills" "$SKILLS"
link_dir "$INSTALL_ROOT/.cursor/rules" "$RULES"
link_dir "$INSTALL_ROOT/.cursor/vault" "$VAULT"

write_vault_pointer
ensure_vault_folders
bootstrap_daily_issues

printf '\nDone. Reload Cursor.\n'
