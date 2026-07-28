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

if rg -q '"waypoint ' internal/cli/ 2>/dev/null; then
  echo "FAIL: CLI help still references \"waypoint \" command examples"
  rg '"waypoint ' internal/cli/ | head -10
  fail=1
else
  echo "OK: CLI help command examples"
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

if rg -q '/waypoint/docs/' website/content website/data embedJson/gen docs/gen 2>/dev/null; then
  echo "FAIL: docs still link to /waypoint/docs/"
  rg '/waypoint/docs/' website/content website/data embedJson/gen docs/gen | head -10
  fail=1
else
  echo "OK: docs site paths"
fi

if rg -q 'waypoint\.hcl' website/content embedJson/gen docs/gen 2>/dev/null; then
  echo "FAIL: docs still reference waypoint.hcl"
  rg 'waypoint\.hcl' website/content embedJson/gen docs/gen | head -10
  fail=1
else
  echo "OK: docs HCL filename"
fi

if rg -q 'pkg-name: \[ "waypoint"' .github/workflows/ 2>/dev/null; then
  echo "FAIL: CI build matrix still uses waypoint package name"
  rg 'pkg-name: \[ "waypoint"' .github/workflows/
  fail=1
else
  echo "OK: CI build matrix package names"
fi

if rg -q 'tar -cvf derrick\.tar \./waypoint|COPY dist/\$TARGETOS/\$TARGETARCH/waypoint' \
  .github/workflows/ Dockerfile CRT.Dockerfile 2>/dev/null; then
  echo "FAIL: CI/Docker still references waypoint binary artifact paths"
  rg 'tar -cvf derrick\.tar \./waypoint|COPY dist/\$TARGETOS/\$TARGETARCH/waypoint' \
    .github/workflows/ Dockerfile CRT.Dockerfile
  fail=1
else
  echo "OK: CI/Docker binary artifact paths"
fi

if rg -q 'Getenv\("DERRICK_BINARY", "waypoint"\)|DERRICK_BINARY:-\$TESTDIR/waypoint' test-e2e/ 2>/dev/null; then
  echo "FAIL: e2e tests still default to waypoint binary"
  rg 'Getenv\("DERRICK_BINARY", "waypoint"\)|DERRICK_BINARY:-\$TESTDIR/waypoint' test-e2e/
  fail=1
else
  echo "OK: e2e default binary paths"
fi

if rg -q 'waypoint/hashicorp/' .github/workflows/notify-integration-release-manual.yml 2>/dev/null; then
  echo "FAIL: integration release notify workflow still uses waypoint/hashicorp plugin ids"
  fail=1
else
  echo "OK: integration release plugin identifiers"
fi

if rg -q '\["waypoint", "cli-docs"\]' tools/gendocs/ 2>/dev/null; then
  echo "FAIL: gendocs still invokes waypoint cli-docs"
  fail=1
else
  echo "OK: gendocs CLI name"
fi

USER_FACING_GO=(
  internal/cli
  internal/serverinstall
  internal/runnerinstall
  internal/installutil
  cmd
  internal/ceb
)

if rg -q '"[^"]*Waypoint[^"]*"' "${USER_FACING_GO[@]}" --glob '*.go' --glob '!*_test.go' 2>/dev/null; then
  echo "FAIL: user-facing Go strings still contain Waypoint (double-quoted)"
  rg '"[^"]*Waypoint[^"]*"' "${USER_FACING_GO[@]}" --glob '*.go' --glob '!*_test.go' | head -10
  fail=1
else
  echo "OK: user-facing Go double-quoted strings"
fi

if rg -q '"waypoint [a-z]' internal/cli --glob '*.go' --glob '!*_test.go' 2>/dev/null; then
  echo "FAIL: CLI help still references waypoint subcommands in quotes"
  rg '"waypoint [a-z]' internal/cli --glob '*.go' --glob '!*_test.go' | head -10
  fail=1
else
  echo "OK: CLI subcommand references in help text"
fi

if [[ "$fail" -ne 0 ]]; then
  echo ""
  echo "rename-check: one or more forbidden Waypoint identifiers remain."
  exit 1
fi

echo ""
echo "rename-check: all checks passed."
