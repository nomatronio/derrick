#!/bin/bash
set -eo pipefail

# Derrick end to end test runner

# Builtin plugins and the plugin SDK both register plugin.proto; warn instead of panic.
export GOLANG_PROTOBUF_REGISTRATION_CONFLICT="${GOLANG_PROTOBUF_REGISTRATION_CONFLICT:-warn}"

# shell spinner: https://www.shellscript.sh/tips/spinner/
spin()
{
  spinner="/|\\-/|\\-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 1
    done
  done
}

echo "Beginning Derrick end-to-end tests..."
echo

if [ "${E2E_PLATFORM}" != "Docker" ] && [ "${E2E_PLATFORM}" != "Kubernetes" ] && [ "${E2E_PLATFORM}" != "Ecs" ] && [ "${E2E_PLATFORM}" != "Nomad" ]; then
  echo "Environment variable 'E2E_PLATFORM' must be one of: 'Docker', 'Kubernetes', 'Ecs', 'Nomad'"
  exit 1
fi

# For running script outside of `test-e2e` folder
TESTDIR="${DERRICK_TESTE2E_DIR:-$(pwd)}"

echo "==> Installing dependencies..."
echo

make tools

# TODO: install packages for building waypoint and running supported platforms:
# - git, curl, (probably more)
# - golang
# - docker
# - k8s (potentially external Digital Ocean service?)
# - nomad (use the nomad dev mode scripts from waypoint-flightlist)

# Build env vars
export GOOS="$(go env GOOS)"
export GOARCH="$(go env GOARCH)"
export GOEXE="$(go env GOEXE)"
export OUTDIR="build/${GOOS}_${GOARCH}"

# Target working directory for the binary location if not specified
export DERRICK_BINARY="${DERRICK_BINARY:-$TESTDIR/derrick}"

if [ -z "$DERRICK_EXAMPLES_PATH" ]; then
  echo "DERRICK_EXAMPLES_PATH unset; setting to ${TESTDIR}/waypoint-examples"
  export DERRICK_EXAMPLES_PATH="${TESTDIR}/waypoint-examples"
fi

echo "==> Checking if Derrick binary is built..."
if [ -f "${DERRICK_BINARY}" ]; then
  "${DERRICK_BINARY}" version
  echo
else
  echo "==> Building derrick binary..."
  echo
  make
  echo
fi

# TODO: build waypoint OR download a package, add a switch for this
#   - add param for installing a certain derrick server, allow install from alpha package
#   - export proper vars for binary path and server image later on

# make tools
# git submodule update for grpc status from api common
# make

# Bring in test apps (potentially at a certain sha rather than `main`?)
# git clone --depth 1 git@github.com:hashicorp/waypoint-examples.git
if [ ! -d "$DERRICK_EXAMPLES_PATH" ]; then
  echo "==> Pulling in waypoint-examples for test..."
  echo

  git clone --depth 1 https://github.com/hashicorp/waypoint-examples "$TESTDIR/waypoint-examples"
else
  echo "==> Using existing waypoint-examples repo for test..."
  echo
fi

# Upstream examples still ship waypoint.hcl; Derrick expects derrick.hcl.
while IFS= read -r legacy_hcl; do
  example_dir=$(dirname "${legacy_hcl}")
  if [ ! -f "${example_dir}/derrick.hcl" ]; then
    cp "${legacy_hcl}" "${example_dir}/derrick.hcl"
  fi
done < <(find "$DERRICK_EXAMPLES_PATH" -name waypoint.hcl -print)

# 

echo
echo "==> Running Derrick end-to-end tests..."
echo

# TODO: allow for running all platforms, or only certain ones

# only spin for local devs running on machine to show tests aren't frozen
if [ -z "$CI" ]; then
  spin &
  SPIN_PID=$!
  trap 'kill -9 $SPIN_PID' $(seq 0 15)
fi

# Run Docker tests
go test -v "github.com/nomatronio/derrick/test-e2e" -run "$E2E_PLATFORM"
testResult=$?

# Set up Nomad
# Run Nomad tests

# Set up K8S/K3S
# Run K8S tests

# Set up ECS
# Run ECS tests

if [[ "$testResult" -eq 0 ]]; then
  echo
  echo "==> Cleaning up after finishing tests..."
  echo

  if [[ ! -d DERRICK_EXAMPLES_PATH ]]; then
    # Test clean up
    echo
    echo "* Cleaning up 'waypoint-examples'"
    echo

    rm -rf "$TESTDIR/waypoint-examples"
  fi
fi

# must be at end of script
if [ -z "$CI" ]; then
  kill -9 $SPIN_PID
fi
