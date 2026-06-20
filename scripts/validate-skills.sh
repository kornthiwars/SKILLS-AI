#!/usr/bin/env bash
# Static validation for ai-skills/* — frontmatter, version, paths, line budget, doc sync.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="$REPO_ROOT/ai-skills"
APPENDIX_TH="$REPO_ROOT/docs/th/APPENDIX-TH.md"
errors=0
warnings=0
checked=0

fail() {
  echo "ERROR: $1" >&2
  errors=$((errors + 1))
}

warn() {
  echo "WARN: $1" >&2
  warnings=$((warnings + 1))
}

check_abs_paths() {
  local rel=$1 file=$2
  if grep -qE '/Users/[A-Za-z0-9_-]+|C:\\Users\\|/home/[a-z][a-z0-9_-]*/' "$file" 2>/dev/null; then
    fail "$rel: machine-specific absolute path"
  fi
}

extract_frontmatter() {
  local file=$1
  awk 'BEGIN{p=0} /^---$/{p++; if(p==1) next; if(p==2) exit} p==1{print}' "$file"
}

description_length() {
  local file=$1
  python3 - "$file" <<'PY'
import pathlib, sys
text = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
if not text.startswith("---"):
    print(0)
    sys.exit(0)
parts = text.split("---", 2)
if len(parts) < 3:
    print(0)
    sys.exit(0)
fm = parts[1]
lines = fm.splitlines()
desc_parts = []
i = 0
while i < len(lines):
    if lines[i].startswith("description:"):
        rest = lines[i][len("description:"):].strip()
        if rest and rest not in (">-", ">", "|"):
            desc_parts.append(rest)
        i += 1
        while i < len(lines) and (lines[i].startswith(" ") or lines[i].startswith("\t")):
            desc_parts.append(lines[i].strip())
            i += 1
        break
    i += 1
print(len("".join(desc_parts)))
PY
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

  ref_md="$skill_dir/reference.md"
  if [ ! -f "$ref_md" ]; then
    fail "$rel: missing reference.md (required for all skills)"
  fi

  lines=$(wc -l < "$skill_md" | tr -d ' ')
  if [ "$lines" -gt 500 ]; then
    fail "$rel: $lines lines (max 500)"
  fi

  ref_lines=0
  if [ -f "$ref_md" ]; then
    ref_lines=$(wc -l < "$ref_md" | tr -d ' ')
  fi
  if [ "$lines" -gt 200 ] && [ "$ref_lines" -lt 50 ]; then
    warn "$rel: $lines lines but reference.md has $ref_lines lines (progressive disclosure — expand reference.md)"
  fi

  check_abs_paths "$rel" "$skill_md"
  if [ -f "$ref_md" ]; then
    check_abs_paths "ai-skills/$dir_name/reference.md" "$ref_md"
  fi

  if ! head -n 1 "$skill_md" | grep -q '^---$'; then
    fail "$rel: missing YAML frontmatter"
    continue
  fi

  fm=$(extract_frontmatter "$skill_md")

  name=$(echo "$fm" | grep -E '^name:' | head -1 | sed 's/^name:[[:space:]]*//')
  if [ -z "$name" ]; then
    fail "$rel: missing name:"
  elif [ "$name" != "$dir_name" ]; then
    fail "$rel: name '$name' != folder '$dir_name'"
  fi

  if ! echo "$fm" | grep -qE '^description:'; then
    fail "$rel: missing description:"
  else
    desc_len=$(description_length "$skill_md")
    if [ "$desc_len" -gt 1024 ]; then
      fail "$rel: description length $desc_len (max 1024)"
    fi
  fi

  if ! echo "$fm" | grep -qE '^compatibility:'; then
    fail "$rel: missing compatibility:"
  fi

  skill_version=""
  if ! echo "$fm" | grep -qE '^metadata:'; then
    fail "$rel: missing metadata:"
  elif ! skill_version=$(echo "$fm" | grep -E '^[[:space:]]+version:[[:space:]]+"[^"]+"' | head -1 | sed -E 's/^[[:space:]]+version:[[:space:]]+"([^"]+)".*/\1/'); then
    fail "$rel: missing metadata.version"
  elif [ -z "$skill_version" ]; then
    fail "$rel: missing metadata.version"
  fi

  if ! echo "$fm" | grep -qE '^disable-model-invocation:[[:space:]]*true'; then
    fail "$rel: disable-model-invocation must be true"
  fi

  if [ "$dir_name" = "builder-feature" ]; then
    if ! grep -q 'template.feature-plan.md' "$skill_md"; then
      fail "$rel: must link templates/template.feature-plan.md (plan mode contract)"
    fi
  fi
done

if [ -f "$APPENDIX_TH" ]; then
  python3 - "$SKILLS_ROOT" "$APPENDIX_TH" <<'PY' || errors=$((errors + 1))
import pathlib, re, sys

skills_root = pathlib.Path(sys.argv[1])
appendix = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
errors = []

def skill_version(skill_md: pathlib.Path):
    text = skill_md.read_text(encoding="utf-8")
    m = re.search(r"^metadata:\s*\n(?:[ \t].*\n)*?[ \t]+version:\s*\"([^\"]+)\"", text, re.M)
    return m.group(1) if m else None

canon = {}
for skill_md in sorted(skills_root.glob("*/SKILL.md")):
    ver = skill_version(skill_md)
    if ver:
        canon[skill_md.parent.name] = ver

for line in appendix.splitlines():
    m = re.match(r"^\| ([a-z][a-z0-9-]+) \|", line)
    if not m:
        continue
    skill = m.group(1)
    if skill == "Skill":
        continue
    cols = [c.strip() for c in line.split("|")]
    if len(cols) < 5:
        continue
    # §1 version table only — Invoke column is `/skill`; skip vault tier / usage tables
    if not re.match(r"^/", cols[2]):
        continue
    appendix_ver = cols[3]
    if skill not in canon:
        errors.append(f"docs/th/APPENDIX-TH.md: skill '{skill}' in version table but no ai-skills/{skill}/SKILL.md")
        continue
    if canon[skill] != appendix_ver:
        errors.append(
            f"docs/th/APPENDIX-TH.md: {skill} version '{appendix_ver}' != SKILL.md metadata.version '{canon[skill]}'"
        )

for e in errors:
    print(f"ERROR: {e}", file=sys.stderr)
sys.exit(1 if errors else 0)
PY
else
  warn "docs/th/APPENDIX-TH.md missing — skip version sync check"
fi

if [ "$errors" -gt 0 ]; then
  echo "validate-skills: $errors error(s), $warnings warning(s)" >&2
  exit 1
fi

echo "OK validate-skills: $checked skill(s)${warnings:+, $warnings warning(s)}"
