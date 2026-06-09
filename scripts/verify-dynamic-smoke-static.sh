#!/usr/bin/env bash
# Static preflight for docs/DYNAMIC-AGENT-SMOKE.md scenarios (file content only)
# Usage: ./scripts/verify-dynamic-smoke-static.sh
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

printf 'Static preflight for dynamic agent smoke (content checks)\n\n'

# Scenario 1 — /debug mantra + repro discipline
if search_q 'First is reproducibility' "ai-skills/debug/SKILL.md" \
  && search_q 'Do not propose a fix' "ai-skills/debug/SKILL.md"; then
  pass 'scenario 1 — debug mantra and no fix before repro'
else
  fail 'scenario 1 — debug SKILL missing mantra/repro gates'
fi

# Scenario 2 — /git-push blocked without ยืนยัน
if search_q 'ยืนยัน' "ai-skills/git-push/SKILL.md" \
  && search_q 'Commit only on request' "ai-skills/git-push/SKILL.md"; then
  pass 'scenario 2 — git-push requires explicit commit consent'
else
  fail 'scenario 2 — git-push consent gates'
fi

# Scenario 3 — canonical paths (no examples/)
if search_q 'ai-skills/' "ai-skills/git-push/SKILL.md" \
  && ! search_q 'examples/' "ai-skills/git-push/SKILL.md"; then
  pass 'scenario 3 — git-push canonical paths without examples/'
else
  fail 'scenario 3 — git-push paths'
fi

# Scenario 4 — patch budget in manifest
if search_q 'Patch budget' "ai-rules/change-control-manifest.mdc" \
  && search_q 'Max files' "ai-rules/change-control-manifest.mdc"; then
  pass 'scenario 4 — change-control patch budget documented'
else
  fail 'scenario 4 — manifest patch budget'
fi

# Scenario 5 — vault-recall ≤3 wiki pages
if search_q '≤3' "ai-skills/vault-recall/reference.md"; then
  pass 'scenario 5 — vault-recall caps wiki page reads'
else
  fail 'scenario 5 — vault-recall read cap'
fi

# Scenario 6 — scrutinize agent-skills PR checklist
if search_q 'agent-skills skill / rule PRs' "ai-skills/scrutinize/SKILL.md" \
  && search_q 'metadata.version' "ai-skills/scrutinize/SKILL.md"; then
  pass 'scenario 6 — scrutinize skill PR checklist'
else
  fail 'scenario 6 — scrutinize PR checklist'
fi

# Scenario 7 — schema/prod gates
if search_q '/builder-schema' "ai-rules/architecture/schema-change-protection.mdc" \
  && search_q 'explicit prod confirmation' "ai-rules/architecture/schema-change-protection.mdc" \
  && search_q '/builder-schema' "ai-rules/risk/production-safety.mdc"; then
  pass 'scenario 7 — schema/prod gates'
else
  fail 'scenario 7 — schema/prod gates'
fi

# Scenario 8 — smoke script exists
if [ -x "scripts/smoke-skills.sh" ]; then
  pass 'scenario 8 — smoke-skills.sh present and executable'
else
  fail 'scenario 8 — smoke-skills.sh'
fi

# Scenario 9 — callee redirect cleanup (manifest + debug close-out)
if search_q 'callee-redirect-cleanup' "ai-rules/change-control-manifest.mdc" \
  && search_q 'Callee redirect cleanup' "ai-skills/debug/reference.md"; then
  pass 'scenario 9 — callee redirect gates in manifest and debug'
else
  fail 'scenario 9 — callee redirect cleanup gates'
fi

# Scenario 10 — builder-feature plan-only (no code)
if search_q 'Plan-only iron law' "ai-skills/builder-feature/SKILL.md" \
  && ! search_q '^paths:' "ai-skills/builder-feature/SKILL.md" \
  && search_q 'PLAN_READY' "ai-skills/builder-feature/SKILL.md" \
  && search_q 'UI-only express lane' "ai-skills/builder-feature/reference.md" \
  && search_q 'Never edit application files' "ai-skills/builder-feature/SKILL.md" \
  && search_q 'Slice brief intake' "ai-skills/builder-ui/reference.md" \
  && search_q 'workday/plans/' "ai-skills/vault-recall/reference.md" \
  && search_q 'Slice brief intake' "ai-skills/builder-api/reference.md" \
  && search_q 'Slice brief intake' "ai-skills/builder-schema/reference.md" \
  && search_q 'Slice brief intake' "ai-skills/builder-infrastructure/reference.md" \
  && search_q 'workday/plans/' "ai-skills/vault-recall/SKILL.md"; then
  pass 'scenario 10 — plan-only, slice intake all builders, vault plans in SKILL+ref'
else
  fail 'scenario 10 — builder-feature plan-only gates'
fi

# Scenario 11 — wiki auto-ingest (no ask-first)
if search_q 'Auto-ingest gate' "ai-rules/vault-issues.mdc" \
  && search_q 'Auto-ingest gate' "ai-skills/wiki-ingest/reference.md" \
  && search_q 'not a paraphrase' "ai-skills/wiki-ingest/reference.md" \
  && search_q 'auto-ingest' "ai-skills/vault-recall/SKILL.md"; then
  pass 'scenario 11 — wiki auto-ingest gate, anti-duplicate, vault-recall aligned'
else
  fail 'scenario 11 — wiki auto-ingest gates'
fi

# Scenario 12 — rule/skill precedence (P8-R)
if search_q 'Active skill precedence' "ai-rules/change-control-manifest.mdc" \
  && search_q 'until review complete; recommend only' "ai-rules/change-control-manifest.mdc" \
  && search_q 'Plan-only' "ai-rules/workflow/decision-tree.mdc" \
  && search_q 'change-control-manifest' "ai-skills/builder-feature/SKILL.md" \
  && search_q 'parent directories' "ai-skills/workday-init/reference.md" \
  && search_q 'html,css' "ai-rules/core/execution-model.mdc" \
  && search_q 'html,css' "ai-rules/core/diagnosis-first.mdc" \
  && search_q '/workday-init' "ai-rules/workflow/decision-tree.mdc" \
  && search_q '/workday-review' "ai-rules/change-control-manifest.mdc" \
  && search_q 'manual `/wiki-ingest` only' "ai-skills/wiki-ingest/reference.md"; then
  pass 'scenario 12 — skill precedence, plan-only routing, monorepo resolve, P9-P10 gates'
else
  fail 'scenario 12 — rule/skill precedence gates'
fi

printf '\n'
if [ "$failures" -eq 0 ]; then
  printf 'Static dynamic-smoke preflight passed.\n'
  printf 'Run behavioral scenarios in docs/DYNAMIC-AGENT-SMOKE.md in Cursor after rule changes.\n'
  exit 0
fi

printf 'Static dynamic-smoke preflight failed: %d\n' "$failures"
exit 1
