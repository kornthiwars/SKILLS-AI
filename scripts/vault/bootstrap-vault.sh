#!/usr/bin/env bash
# Bootstrap greenfield vault: projects/{slug}/{hub,daily,sessions,decisions} + _agent + .obsidian
# PackRoot (templates) = script pack; Vault runtime = REPO_ROOT
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REPO_ROOT="$PACK_ROOT"
VERIFY=0
PROJECT="${VAULT_PROJECT:-}"

while [ $# -gt 0 ]; do
  case "$1" in
    --verify) VERIFY=1; shift ;;
    --project) PROJECT="$2"; shift 2 ;;
    --repo=*) REPO_ROOT="${1#--repo=}"; shift ;;
    --repo-root) REPO_ROOT="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

VAULT="$REPO_ROOT/vault"
AGENT="$VAULT/_agent"
PROJECTS_ROOT="$VAULT/projects"
TEMPLATES_PACK="$PACK_ROOT/templates/vault"
META_PACK="$TEMPLATES_PACK/meta"
NOTES_PACK="$TEMPLATES_PACK/notes"
OBSIDIAN_PACK="$TEMPLATES_PACK/obsidian"
OBSIDIAN_RUNTIME="$VAULT/.obsidian"

PACK_TEMPLATES=(
  template.vault-daily.md
  template.vault-session.md
  template.vault-decision.md
  template.vault-project.md
)

ensure_file_from_template() {
  local target="$1" template="$2"
  [ -f "$target" ] && return 0
  [ -f "$template" ] || { echo "Missing template: $template" >&2; exit 1; }
  mkdir -p "$(dirname "$target")"
  cp "$template" "$target"
}

copy_if_missing() {
  local source="$1" dest="$2"
  [ -f "$dest" ] && return 0
  [ -f "$source" ] || { echo "Missing seed: $source" >&2; exit 1; }
  mkdir -p "$(dirname "$dest")"
  cp "$source" "$dest"
}

ensure_project_tree() {
  local slug="$1"
  slug="$(printf '%s' "$slug" | tr '[:upper:]' '[:lower:]')"
  case "$slug" in
    ''|*[!a-z0-9_-]*) echo "Project slug must be [a-z0-9_-]" >&2; exit 1 ;;
  esac
  local root="$PROJECTS_ROOT/$slug"
  mkdir -p "$root/daily" "$root/sessions" "$root/decisions"
  local hub="$root/hub.md"
  local hub_template="$NOTES_PACK/template.vault-project.md"
  if [ ! -f "$hub" ]; then
    [ -f "$hub_template" ] || { echo "Missing template: $hub_template" >&2; exit 1; }
    local iso
    iso="$(date +%Y-%m-%d)"
    sed "s/proj-SLUG/proj-$slug/g; s/TITLE/$slug/g; s/\"PROJECT\"/\"$slug\"/g; s/CREATED/$iso/g; s/UPDATED/$iso/g" "$hub_template" > "$hub"
    echo "INIT hub: $hub"
  fi
  local date iso daily_id daily_file daily_template
  date="$(date +%Y-%m-%d)"
  iso="$(date -Iseconds)"
  daily_id="daily-${date}__${slug}"
  daily_file="$root/daily/$date.md"
  daily_template="$NOTES_PACK/template.vault-daily.md"
  if [ ! -f "$daily_file" ]; then
    [ -f "$daily_template" ] || { echo "Missing template: $daily_template" >&2; exit 1; }
    sed "s/__VAULT_DAILY_ID__/$daily_id/g; s/__VAULT_DATE__/$date/g; s/__VAULT_ISO__/$iso/g; s/__VAULT_PROJECT__/$slug/g" "$daily_template" > "$daily_file"
    echo "INIT daily: $daily_file"
  fi
}

mkdir -p "$VAULT" "$PROJECTS_ROOT" "$AGENT"
[ -f "$VAULT/.gitkeep" ] || touch "$VAULT/.gitkeep"

ensure_file_from_template "$AGENT/tiers.json" "$META_PACK/tiers.template.json"
ensure_file_from_template "$AGENT/manifest.json" "$META_PACK/manifest.template.json"

if [ -d "$OBSIDIAN_PACK" ]; then
  mkdir -p "$OBSIDIAN_RUNTIME"
  for f in "$OBSIDIAN_PACK"/*; do
    [ -f "$f" ] || continue
    copy_if_missing "$f" "$OBSIDIAN_RUNTIME/$(basename "$f")"
  done
fi

if [ -n "$PROJECT" ]; then
  ensure_project_tree "$PROJECT"
else
  echo "SKIP project subtree - set VAULT_PROJECT or --project to seed projects/{slug}/"
fi

if [ "$VERIFY" -eq 1 ]; then
  [ -d "$PROJECTS_ROOT" ] || { echo "Verify failed: missing projects" >&2; exit 1; }
  for f in tiers.json manifest.json; do
    [ -f "$AGENT/$f" ] || { echo "Verify failed: missing _agent/$f" >&2; exit 1; }
  done
  for t in "${PACK_TEMPLATES[@]}"; do
    [ -f "$NOTES_PACK/$t" ] || { echo "Verify failed: missing templates/vault/notes/$t" >&2; exit 1; }
  done
  if [ -n "$PROJECT" ]; then
    slug="$(printf '%s' "$PROJECT" | tr '[:upper:]' '[:lower:]')"
    root="$PROJECTS_ROOT/$slug"
    for sub in daily sessions decisions; do
      [ -d "$root/$sub" ] || { echo "Verify failed: missing projects/$slug/$sub" >&2; exit 1; }
    done
    [ -f "$root/hub.md" ] || { echo "Verify failed: missing projects/$slug/hub.md" >&2; exit 1; }
  fi
fi

printf 'OK  vault bootstrap: %s\n' "$VAULT"
