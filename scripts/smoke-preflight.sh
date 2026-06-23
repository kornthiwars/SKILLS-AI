#!/usr/bin/env bash
# Static preflight for DYNAMIC-AGENT-SMOKE — run before behavioral scenarios in Cursor.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/scripts/validate-skills.sh"
echo "OK smoke-preflight: validate-skills passed."
echo "Next: Reload Cursor → fresh chat → DYNAMIC #1,#2,#9,#11,#12,#14,#16 — docs/DYNAMIC-AGENT-SMOKE.md"
