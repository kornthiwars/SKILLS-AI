#!/usr/bin/env bash
# Quick static smoke checks for agent-skills
# Usage: ./scripts/smoke-skills.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

failures=0

pass() { printf 'PASS %s\n' "$1"; }
fail() { printf 'FAIL %s\n' "$1"; failures=$((failures + 1)); }

search_q() {
  local pattern="$1"
  local path="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -q "$pattern" "$path"
  else
    grep -Eq "$pattern" "$path"
  fi
}

check_file() {
  local path="$1"
  [ -f "$path" ] && pass "$path exists" || fail "$path missing"
}

check_contains() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if search_q "$pattern" "$path"; then
    pass "$label"
  else
    fail "$label"
  fi
}

printf 'Running agent-skills smoke checks in %s\n\n' "$REPO_ROOT"

# Critical paths
check_file "ai-skills/README.md"
check_file "ai-rules/change-control-manifest.mdc"
check_file "ai-rules/vault-issues.mdc"
check_file "ai-rules/bilingual-th-en.mdc"
check_file "ai-rules/clean-code.mdc"
check_file "docs/SKILL-PATTERN.md"
check_file "docs/CHANGE-CONTROL.md"
check_file "docs/DYNAMIC-AGENT-SMOKE.md"
check_file "docs/th/README.md"
check_file "docs/th/SKILLS-TH.md"
check_file "scripts/change-control-check.sh"

# Production rule tree (minimum set)
for f in \
  ai-rules/core/execution-model.mdc \
  ai-rules/patching/patch-scope-control.mdc \
  ai-rules/patching/callee-redirect-cleanup.mdc \
  ai-rules/risk/risk-classification.mdc \
  ai-rules/workflow/stop-conditions.mdc; do
  check_file "$f"
done

rule_count="$(find ai-rules -name '*.mdc' | wc -l | tr -d ' ')"
if [ "${rule_count:-0}" -ge 25 ]; then
  pass "production rule tree present ($rule_count .mdc files)"
else
  fail "expected >= 25 .mdc rule files, found $rule_count"
fi

# Skills
missing_disable=""
for skill in ai-skills/*/SKILL.md; do
  if ! search_q '^disable-model-invocation:[[:space:]]*true$' "$skill"; then
    missing_disable+="$skill"$'\n'
  fi
done
if [ -z "$missing_disable" ]; then
  pass "all skills disable-model-invocation=true"
else
  fail "skills missing disable-model-invocation"
fi

missing_guardrails=""
for skill in ai-skills/*/SKILL.md; do
  if ! search_q '^## Scope Guardrails$' "$skill"; then
    missing_guardrails+="$skill"$'\n'
  fi
done
if [ -z "$missing_guardrails" ]; then
  pass "all skills include Scope Guardrails"
else
  fail "skills missing Scope Guardrails"
fi

check_contains "ai-skills/debug/SKILL.md" 'change-control-manifest' "debug references change-control manifest"
check_contains "ai-skills/git-push/SKILL.md" 'change-control-manifest' "git-push references change-control manifest"
check_contains "ai-rules/change-control-manifest.mdc" 'Patch budget' "manifest defines patch budget"
check_contains "AGENTS.md" 'change-control-manifest' "AGENTS.md lists change-control"
check_contains "AGENTS.md" 'awesome-agent-skills' "AGENTS.md links external catalog"
check_file "docs/EXTERNAL-PARITY.md"
check_file "ai-skills/workday-update/reference.md"
check_contains "ai-skills/builder-feature/SKILL.md" 'Plan-only iron law' "builder-feature plan-only gate"
check_file "templates/template.slice-brief.md"
check_file "templates/template.feature-plan.md"
check_contains "ai-skills/builder-feature/reference.md" 'template.slice-brief.md' "builder-feature links slice brief template"
check_file "docs/DYNAMIC-AGENT-SMOKE.md"
check_file "scripts/verify-dynamic-smoke-static.sh"

printf '\n'
if [ "$failures" -eq 0 ]; then
  printf 'Smoke checks passed.\n'
  if [ -x "scripts/verify-dynamic-smoke-static.sh" ]; then
    if ! ./scripts/verify-dynamic-smoke-static.sh; then
      failures=1
    fi
  fi
  if [ "$failures" -eq 0 ]; then
    exit 0
  fi
fi

printf 'Smoke checks failed: %d\n' "$failures"
exit 1
