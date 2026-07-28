#!/usr/bin/env bash
# rename-check.sh — fail if forbidden Waypoint identifiers remain outside exempt paths.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

EXEMPT=(
  --glob '!FORK.md'
  --glob '!NOTICE'
  --glob '!LICENSE'
  --glob '!CHANGELOG.md'
  --glob '!.changelog/**'
  --glob '!scripts/rename-check.sh'
  --glob '!scripts/rename-apply.sh'
)

fail=0

check() {
  local label="$1"
  local pattern="$2"
  shift 2
  if rg -q "$pattern" "${EXEMPT[@]}" "$@" . 2>/dev/null; then
    echo "FAIL: $label still present:"
    rg "$pattern" "${EXEMPT[@]}" "$@" . | head -15
    echo "..."
    fail=1
  else
    echo "OK: $label"
  fi
}

# Core module import (exclude hashicorp/waypoint-hzn, waypoint-helm, waypoint-examples, .git URLs)
check "HashiCorp waypoint core module imports" 'github\.com/hashicorp/waypoint"' --type go
check "HashiCorp waypoint core module imports (slash)" 'github\.com/hashicorp/waypoint/' --type go

check "HashiCorp plugin SDK imports" 'github\.com/hashicorp/waypoint-plugin-sdk' --type go
check "WAYPOINT_ env vars in Go" 'WAYPOINT_' --type go
check "legacy gRPC package path" 'hashicorp\.waypoint' --glob '*.go' --glob '*.proto' --glob '*.ts' --glob '*.js'
check "waypoint.hcl in Go/TS/UI" 'waypoint\.hcl' --glob '*.go' --glob '*.ts' --glob '*.hbs' --glob '*.yaml'

if rg -q 'Usage: waypoint' internal/cli/ 2>/dev/null; then
  echo "FAIL: CLI still uses Usage: waypoint"
  fail=1
else
  echo "OK: CLI usage strings"
fi

if [[ -f Makefile ]] && rg -q 'cmd/waypoint|o \./waypoint' Makefile 2>/dev/null; then
  echo "FAIL: Makefile still references waypoint binary paths"
  fail=1
else
  echo "OK: Makefile binary paths"
fi

if rg -q 'identifier  = "waypoint/' builtin/ 2>/dev/null; then
  echo "FAIL: builtin plugin metadata still uses waypoint/ identifiers"
  rg 'identifier  = "waypoint/' builtin/ | head -10
  fail=1
else
  echo "OK: plugin metadata identifiers"
fi

if rg -q 'waypoint-plugin-' internal/plugin/ --glob '*.go' 2>/dev/null; then
  echo "FAIL: plugin discovery still references waypoint-plugin- binary prefix"
  rg 'waypoint-plugin-' internal/plugin/ --glob '*.go' | head -10
  fail=1
else
  echo "OK: plugin binary prefix"
fi

if rg -q '"waypoint/workspace"' internal/ pkg/ --glob '*.go' 2>/dev/null; then
  echo "FAIL: system label still uses waypoint/workspace"
  rg '"waypoint/workspace"' internal/ pkg/ --glob '*.go' | head -10
  fail=1
else
  echo "OK: system label namespace"
fi

if [[ "$fail" -ne 0 ]]; then
  echo ""
  echo "rename-check: one or more forbidden Waypoint identifiers remain."
  exit 1
fi

echo ""
echo "rename-check: all checks passed."
