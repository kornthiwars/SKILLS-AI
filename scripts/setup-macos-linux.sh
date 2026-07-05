#!/usr/bin/env bash
# Symlink .cursor/skills, .cursor/rules, .cursor/vault
# Usage: ./scripts/setup-macos-linux.sh [install-root] [--subprojects dir1,dir2] [--no-auto-subprojects]
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

for dir in "$SKILLS" "$RULES"; do
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

wire_subproject_vault() {
  local sub_root="$1"
  local cursor_dir

  [ -d "$sub_root" ] || return 0
  sub_root="$(cd "$sub_root" && pwd)"
  [ "$sub_root" != "$INSTALL_ROOT" ] || return 0

  cursor_dir="$sub_root/.cursor"
  link_dir "$cursor_dir/vault" "$VAULT"
  printf 'OK  subproject vault: %s\n' "$sub_root"
}

collect_subproject_roots() {
  local name agent_skills_in_install sibling

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
    base="$(basename "$sibling")"
    case "$base" in .cursor|agent-skills|SKILLS-AI|apps) continue ;; esac
    [ "$sibling" = "$agent_skills_in_install" ] && continue
    printf '%s\n' "$(cd "$sibling" && pwd)"
  done
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

chmod_pack_scripts() {
  local f
  for f in "$REPO_ROOT"/scripts/*.sh; do
    [ -f "$f" ] || continue
    chmod +x "$f"
  done
}

chmod_pack_scripts

bootstrap_vault() {
  local bootstrap="$REPO_ROOT/scripts/vault/bootstrap-vault.sh"
  local f

  for f in "$REPO_ROOT"/scripts/vault/*.sh; do
    [ -f "$f" ] || continue
    chmod +x "$f"
  done

  [ -f "$bootstrap" ] || { printf '..  skip vault (bootstrap-vault.sh missing)\n'; return 0; }

  "$bootstrap" --repo="$REPO_ROOT" --verify || return 1
  printf 'OK  vault (agent-only — no Python required)\n'
}

bootstrap_vault

link_dir "$INSTALL_ROOT/.cursor/skills" "$SKILLS"
link_dir "$INSTALL_ROOT/.cursor/rules" "$RULES"
link_dir "$INSTALL_ROOT/.cursor/vault" "$VAULT"

while IFS= read -r sub_root; do
  [ -n "$sub_root" ] || continue
  wire_subproject_vault "$sub_root"
done < <(collect_subproject_roots)

printf '\nDone. Reload Cursor.\n'
