#!/usr/bin/env bash
# Symlink .cursor/skills, .cursor/rules, .cursor/vault + ai-skills-vault.json
# Usage: ./scripts/setup-macos-linux.sh [install-root] [--subprojects dir1,dir2] [--no-auto-subprojects]
# Default (no install-root): parent of agent-skills — typical when Cursor opens the project folder.
# Use "." or "--here" when Cursor opens agent-skills/ itself.
# Subprojects: vault-only wire for monorepo siblings (e.g. exat-web/) — auto when agent-skills is child of install root.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

INSTALL_ROOT_ARG=""
SUBPROJECTS=""
AUTO_SUBPROJECTS=1

while [ $# -gt 0 ]; do
  case "$1" in
    --subprojects)
      SUBPROJECTS="${2:-}"
      [ -n "$SUBPROJECTS" ] || { echo "Missing value for --subprojects" >&2; exit 1; }
      shift 2
      ;;
    --no-auto-subprojects)
      AUTO_SUBPROJECTS=0
      shift
      ;;
    --here | here | . | --parent | parent)
      INSTALL_ROOT_ARG="$1"
      shift
      ;;
    --*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      INSTALL_ROOT_ARG="$1"
      shift
      ;;
  esac
done

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

INSTALL_ROOT="$(resolve_install_root "${INSTALL_ROOT_ARG:-}")"

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

write_vault_pointer_at() {
  local cursor_dir="$1"
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
    "workdayRelative": ".cursor/vault/workday",
    "wikiRelative": ".cursor/vault/wiki",
}
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)
PY
  printf 'OK  %s\n' "$json_path"
}

write_vault_pointer() {
  write_vault_pointer_at "$INSTALL_ROOT/.cursor"
}

wire_subproject_vault() {
  local sub_root="$1"
  local cursor_dir

  [ -d "$sub_root" ] || return 0
  sub_root="$(cd "$sub_root" && pwd)"
  [ "$sub_root" != "$INSTALL_ROOT" ] || return 0

  cursor_dir="$sub_root/.cursor"
  link_dir "$cursor_dir/vault" "$VAULT"
  write_vault_pointer_at "$cursor_dir"
  printf 'OK  subproject vault: %s\n' "$sub_root"
}

collect_subproject_roots() {
  local name dir agent_skills_in_install sibling

  if [ -n "$SUBPROJECTS" ]; then
    IFS=',' read -r -a _subs <<<"$SUBPROJECTS"
    for name in "${_subs[@]}"; do
      name="${name#"${name%%[![:space:]]*}"}"
      name="${name%"${name##*[![:space:]]}"}"
      [ -n "$name" ] || continue
      if [ -d "$name" ]; then
        printf '%s\n' "$(cd "$name" && pwd)"
      elif [ -d "$INSTALL_ROOT/$name" ]; then
        printf '%s\n' "$(cd "$INSTALL_ROOT/$name" && pwd)"
      else
        printf '..  skip subproject (missing): %s\n' "$name" >&2
      fi
    done
    return 0
  fi

  [ "$AUTO_SUBPROJECTS" -eq 1 ] || return 0

  agent_skills_in_install="$INSTALL_ROOT/agent-skills"
  [ -d "$agent_skills_in_install" ] || return 0
  [ "$(cd "$agent_skills_in_install" && pwd)" = "$(cd "$REPO_ROOT" && pwd)" ] || return 0

  for sibling in "$INSTALL_ROOT"/*; do
    [ -d "$sibling" ] || continue
    [ "$sibling" = "$agent_skills_in_install" ] && continue
    printf '%s\n' "$(cd "$sibling" && pwd)"
  done
}

ensure_vault_folders() {
  local rel path
  for rel in issues workday workday/plans wiki wiki/pages wiki/sources; do
    path="$VAULT/$rel"
    if [ ! -d "$path" ]; then
      mkdir -p "$path"
      printf 'OK  created vault/%s\n' "$rel"
    fi
  done
}

bootstrap_wiki_files() {
  local today index_file log_file template

  today="$(date +%Y-%m-%d)"
  index_file="$VAULT/wiki/index.md"
  log_file="$VAULT/wiki/log.md"

  if [ -f "$index_file" ]; then
    printf 'OK  vault/wiki/index.md\n'
  else
    template="$REPO_ROOT/templates/template.wiki-index.md"
    if [ ! -f "$template" ]; then
      printf '..  skip wiki index (no template)\n'
    else
      sed "s/{{YYYY-MM-DD}}/$today/g" "$template" >"$index_file"
      printf 'OK  created vault/wiki/index.md\n'
    fi
  fi

  if [ -f "$log_file" ]; then
    printf 'OK  vault/wiki/log.md\n'
  else
    template="$REPO_ROOT/templates/template.wiki-log.md"
    if [ ! -f "$template" ]; then
      printf '..  skip wiki log (no template)\n'
    else
      sed "s/{{YYYY-MM-DD}}/$today/g" "$template" >"$log_file"
      printf 'OK  created vault/wiki/log.md\n'
    fi
  fi
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
bootstrap_wiki_files
bootstrap_daily_issues

while IFS= read -r sub_root; do
  [ -n "$sub_root" ] || continue
  wire_subproject_vault "$sub_root"
done < <(collect_subproject_roots)

printf '\nDone. Reload Cursor.\n'
