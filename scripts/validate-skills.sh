#!/usr/bin/env bash
# Static validation for ai-skills/* — frontmatter, version, paths, line budget.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/ai-skills"
errors=0
checked=0

fail() {
  echo "ERROR: $1" >&2
  errors=$((errors + 1))
}

check_abs_paths() {
  local rel=$1 file=$2
  if grep -qE '/Users/[A-Za-z0-9_-]+|C:\\Users\\|/home/[a-z][a-z0-9_-]*/' "$file" 2>/dev/null; then
    fail "$rel: machine-specific absolute path"
  fi
}

if [ ! -d "$SKILLS_ROOT" ]; then
  echo "Missing ai-skills at $SKILLS_ROOT" >&2
  exit 1
fi

for skill_dir in "$SKILLS_ROOT"/*/; do
  [ -d "$skill_dir" ] || continue
  dir_name="$(basename "$skill_dir")"
  skill_md="$skill_dir/SKILL.md"
  rel="ai-skills/$dir_name/SKILL.md"
  checked=$((checked + 1))

  if [ ! -f "$skill_md" ]; then
    fail "$rel: missing SKILL.md"
    continue
  fi

  lines=$(wc -l < "$skill_md" | tr -d ' ')
  if [ "$lines" -gt 500 ]; then
    fail "$rel: $lines lines (max 500)"
  fi

  check_abs_paths "$rel" "$skill_md"

  if ! head -n 1 "$skill_md" | grep -q '^---$'; then
    fail "$rel: missing YAML frontmatter"
    continue
  fi

  fm=$(awk 'BEGIN{p=0} /^---$/{p++; if(p==1) next; if(p==2) exit} p==1{print}' "$skill_md")

  name=$(echo "$fm" | grep -E '^name:' | head -1 | sed 's/^name:[[:space:]]*//')
  if [ -z "$name" ]; then
    fail "$rel: missing name:"
  elif [ "$name" != "$dir_name" ]; then
    fail "$rel: name '$name' != folder '$dir_name'"
  fi

  if ! echo "$fm" | grep -qE '^description:'; then
    fail "$rel: missing description:"
  fi

  if ! echo "$fm" | grep -qE '^compatibility:'; then
    fail "$rel: missing compatibility:"
  fi

  if ! echo "$fm" | grep -qE '^metadata:'; then
    fail "$rel: missing metadata:"
  elif ! echo "$fm" | grep -qE '^[[:space:]]+version:[[:space:]]+"[^"]+"'; then
    fail "$rel: missing metadata.version"
  fi

  if ! echo "$fm" | grep -qE '^disable-model-invocation:[[:space:]]*true'; then
    fail "$rel: disable-model-invocation must be true"
  fi

  ref_md="$skill_dir/reference.md"
  if [ -f "$ref_md" ]; then
    check_abs_paths "ai-skills/$dir_name/reference.md" "$ref_md"
  fi
done

if [ "$errors" -gt 0 ]; then
  echo "validate-skills: $errors error(s)" >&2
  exit 1
fi

echo "OK validate-skills: $checked skill(s)"
