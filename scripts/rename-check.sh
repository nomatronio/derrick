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

if [[ -f ui/package.json ]] && rg -q '"name": "waypoint"' ui/package.json 2>/dev/null; then
  echo "FAIL: ui/package.json still uses package name waypoint"
  fail=1
else
  echo "OK: ui package name"
fi

if [[ -f ui/tsconfig.json ]] && rg -q '"waypoint/' ui/tsconfig.json 2>/dev/null; then
  echo "FAIL: ui/tsconfig.json still uses waypoint path aliases"
  fail=1
else
  echo "OK: ui tsconfig path aliases"
fi

INSTALL_DIRS=(internal/serverinstall internal/runnerinstall internal/installutil internal/runner internal/ceb cmd/derrick-entrypoint)

if rg -q 'hashicorp/waypoint[^-]' "${INSTALL_DIRS[@]}" 2>/dev/null; then
  echo "FAIL: install/runtime still references hashicorp/waypoint images:"
  rg 'hashicorp/waypoint[^-]' "${INSTALL_DIRS[@]}" | head -10
  fail=1
else
  echo "OK: install/runtime default images"
fi

if rg -q '"waypoint-server"|"waypoint-runner"|"waypoint-ui"' "${INSTALL_DIRS[@]}" 2>/dev/null; then
  echo "FAIL: install/runtime still uses waypoint-* resource names:"
  rg '"waypoint-server"|"waypoint-runner"|"waypoint-ui"' "${INSTALL_DIRS[@]}" | head -10
  fail=1
else
  echo "OK: install/runtime resource names"
fi

if [[ "$fail" -ne 0 ]]; then
  echo ""
  echo "rename-check: one or more forbidden Waypoint identifiers remain."
  exit 1
fi

echo ""
echo "rename-check: all checks passed."
