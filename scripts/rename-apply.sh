#!/usr/bin/env bash
# Mechanical Waypoint → Derrick rename for the derrick open-core fork.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

EXCLUDE=(
  ! -path './.git/*'
  ! -path './thirdparty/*'
  ! -path './ui/node_modules/*'
  ! -path './website/node_modules/*'
  ! -path './.changelog/*'
  ! -name 'CHANGELOG.md'
  ! -name 'FORK.md'
  ! -name 'NOTICE'
  ! -name 'LICENSE'
  ! -name 'rename-apply.sh'
)

replace_in_tree() {
  local pattern="$1"
  local replacement="$2"
  find . -type f "${EXCLUDE[@]}" -print0 | xargs -0 sed -i '' -e "s|${pattern}|${replacement}|g" 2>/dev/null || true
}

echo "== Phase: protect historical tokens =="
replace_in_tree 'upstream-waypoint' '___UPSTREAM_WAYPOINT___'

echo "== Phase: directory renames =="
git mv cmd/waypoint cmd/derrick 2>/dev/null || true
git mv cmd/waypoint-entrypoint cmd/derrick-entrypoint 2>/dev/null || true
[ -d x/slack/cmd/waypoint-slack ] && git mv x/slack/cmd/waypoint-slack x/slack/cmd/derrick-slack
[ -f pkg/server/singleprocess/service_waypointhcl.go ] && git mv pkg/server/singleprocess/service_waypointhcl.go pkg/server/singleprocess/service_derrickhcl.go
[ -f pkg/serverhandler/handlertest/test_service_waypointhcl.go ] && git mv pkg/serverhandler/handlertest/test_service_waypointhcl.go pkg/serverhandler/handlertest/test_service_derrickhcl.go
[ -d ui/lib/waypoint-pb ] && git mv ui/lib/waypoint-pb ui/lib/derrick-pb
[ -d ui/lib/waypoint-client ] && git mv ui/lib/waypoint-client ui/lib/derrick-client
[ -d website/content/docs/waypoint-hcl ] && git mv website/content/docs/waypoint-hcl website/content/docs/derrick-hcl
[ -d website/content/docs/extending-waypoint ] && git mv website/content/docs/extending-waypoint website/content/docs/extending-derrick
[ -f ui/app/modifiers/utils/register-waypoint-hcl-mode.ts ] && git mv ui/app/modifiers/utils/register-waypoint-hcl-mode.ts ui/app/modifiers/utils/register-derrick-hcl-mode.ts

echo "== Phase: proto and API identity =="
replace_in_tree 'hashicorp\.waypoint' 'nomatron.derrick'
replace_in_tree 'hashicorp_waypoint' 'nomatron_derrick'
replace_in_tree 'service Waypoint' 'service Derrick'
replace_in_tree 'WaypointHclFmt' 'DerrickHclFmt'
replace_in_tree 'WaypointHcl' 'DerrickHcl'
replace_in_tree 'waypoint_hcl_format' 'derrick_hcl_format'
replace_in_tree 'waypoint_hcl' 'derrick_hcl'
replace_in_tree 'WaypointClient' 'DerrickClient'
replace_in_tree 'WaypointServer' 'DerrickServer'
replace_in_tree 'UnsafeWaypointServer' 'UnsafeDerrickServer'
replace_in_tree 'UnimplementedWaypointServer' 'UnimplementedDerrickServer'
replace_in_tree 'NewWaypointClient' 'NewDerrickClient'
replace_in_tree 'RegisterWaypointServer' 'RegisterDerrickServer'
replace_in_tree '_Waypoint_' '_Derrick_'
replace_in_tree 'isWaypointHcl' 'isDerrickHcl'
replace_in_tree 'projectWaypointHclMaxSize' 'projectDerrickHclMaxSize'
replace_in_tree 'onDemandRunnerWaypointHclMaxSize' 'onDemandRunnerDerrickHclMaxSize'
replace_in_tree 'TestServiceWaypointHclFmt' 'TestServiceDerrickHclFmt'

echo "== Phase: module paths =="
replace_in_tree 'github.com/hashicorp/waypoint-plugin-sdk' 'github.com/nomatronio/derrick-plugin-sdk'
replace_in_tree 'github.com/hashicorp/waypoint-hzn' 'github.com/nomatronio/derrick-hzn'
replace_in_tree 'github.com/hashicorp/waypoint' 'github.com/nomatronio/derrick'

echo "== Phase: env vars and config =="
replace_in_tree 'WAYPOINT_' 'DERRICK_'
replace_in_tree 'waypoint\.hcl' 'derrick.hcl'
replace_in_tree 'waypoint-hcl' 'derrick-hcl'
replace_in_tree '<waypoint-hcl>' '<derrick-hcl>'
replace_in_tree '\.waypoint/' '.derrick/'
replace_in_tree '\.waypoint"' '.derrick"'
replace_in_tree 'xdg.ConfigFile("waypoint' 'xdg.ConfigFile("derrick'
replace_in_tree 'ConfigFile("waypoint' 'ConfigFile("derrick'

echo "== Phase: CLI and binaries =="
replace_in_tree 'cliName = "waypoint"' 'cliName = "derrick"'
replace_in_tree 'Usage: waypoint' 'Usage: derrick'
replace_in_tree 'Getenv("WP_BINARY", "waypoint")' 'Getenv("DERRICK_BINARY", "derrick")'
replace_in_tree 'WP_BINARY' 'DERRICK_BINARY'
replace_in_tree 'waypoint-entrypoint' 'derrick-entrypoint'
replace_in_tree 'waypoint.exe' 'derrick.exe'
replace_in_tree 'bin/waypoint' 'bin/derrick'
replace_in_tree './cmd/waypoint-entrypoint' './cmd/derrick-entrypoint'
replace_in_tree './cmd/waypoint' './cmd/derrick'
replace_in_tree 'o ./waypoint ' 'o ./derrick '
replace_in_tree 'o ./waypoint$' 'o ./derrick'
replace_in_tree '/usr/bin/waypoint' '/usr/bin/derrick'
replace_in_tree '/kaniko/waypoint' '/kaniko/derrick'
replace_in_tree 'GOPATH)/bin/waypoint' 'GOPATH)/bin/derrick'
replace_in_tree 'waypoint-tools' 'derrick-tools'
replace_in_tree 'WAYPOINT_GOOS' 'DERRICK_GOOS'
replace_in_tree 'WAYPOINT_GOARCH' 'DERRICK_GOARCH'
replace_in_tree '"waypoint"' '"derrick"'

echo "== Phase: docker =="
replace_in_tree 'hashicorp/waypoint' 'nomatronio/derrick'
replace_in_tree 'addgroup waypoint' 'addgroup derrick'
replace_in_tree 'adduser -S -u 100 -G waypoint waypoint' 'adduser -S -u 100 -G derrick derrick'
replace_in_tree 'chown -R waypoint:waypoint' 'chown -R derrick:derrick'
replace_in_tree 'chown -R waypoint ' 'chown -R derrick '
replace_in_tree '/home/waypoint' '/home/derrick'
replace_in_tree 'USER waypoint' 'USER derrick'
replace_in_tree 'echo waypoint:' 'echo derrick:'

echo "== Phase: UI paths =="
replace_in_tree 'waypoint-pb' 'derrick-pb'
replace_in_tree 'waypoint-client' 'derrick-client'
replace_in_tree 'register-waypoint-hcl-mode' 'register-derrick-hcl-mode'

echo "== Phase: docs URLs =="
replace_in_tree 'waypointproject\.io' 'derrick.dev'
replace_in_tree 'developer\.hashicorp\.com/waypoint' 'derrick.dev/docs'
replace_in_tree 'extending-waypoint' 'extending-derrick'

echo "== Phase: product branding =="
replace_in_tree 'HashiCorp Waypoint' 'Derrick'
replace_in_tree 'Waypoint' 'Derrick'
replace_in_tree 'waypoint' 'derrick'

echo "== Phase: restore historical tokens =="
replace_in_tree '___UPSTREAM_WAYPOINT___' 'upstream-waypoint'
replace_in_tree 'upstream-dderrick' 'upstream-waypoint'

echo "== Phase: go.mod =="
sed -i '' 's|^module github.com/nomatronio/derrick$|module github.com/nomatronio/derrick|' go.mod
if ! grep -q 'replace github.com/nomatronio/derrick-plugin-sdk' go.mod; then
  printf '\nreplace github.com/nomatronio/derrick-plugin-sdk => ../derrick-plugin-sdk\n' >> go.mod
fi

echo "derrick rename-apply complete."
