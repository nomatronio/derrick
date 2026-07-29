#!/usr/bin/env bash

set -e -u -o pipefail

set -x

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Configure Kubernetes"

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Confirm k8s is working
echo "Confirm kubernetes is working:"
kubectl cluster-info


echo "Boot up the registry to use:"
docker run -d -p 5000:5000 --restart=always --name registry.localhost registry:2

DERRICK="$(pwd)/derrick"

test -e "$DERRICK"

cd ci/sinatra || exit 1

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Derrick init"
"$DERRICK" init

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Derrick build"
"$DERRICK" build

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Derrick deploy"
# If the registry isn't working and the pods are therefore unable to pull, we get stuck in an infinite wait
timeout 1m "$DERRICK" deploy

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Derrick release"
"$DERRICK" release

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Derrick deployment list"
# Smoke test list methods
"$DERRICK" deployment list
"$DERRICK" deployment list -V
"$DERRICK" deployment list -json

## Let things get going.
sleep 10

[[ -n "$GITHUB_ACTION" ]] && echo "::group::Check deployed sinatra service"

PORT=$(kubectl get service sinatra -o jsonpath="{.spec.ports[0].nodePort}")

test "$(curl -s "localhost:$PORT")" = "Welcome to Derrick!"
