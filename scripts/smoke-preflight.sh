#!/usr/bin/env bash
# Static preflight for DYNAMIC-AGENT-SMOKE — run before behavioral scenarios in Cursor.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/scripts/validate-skills.sh"
echo "OK smoke-preflight: validate-skills passed. Run behavioral scenarios in fresh chat after Reload Cursor — docs/DYNAMIC-AGENT-SMOKE.md"
