#!/usr/bin/env bash
# Rewrite builtin plugin protoc go:generate directives for source_relative output.
set -euo pipefail

declare -A INCLUDES=(
  ["builtin/pack/main.go"]="-I."
  ["builtin/files/files.go"]="-I."
  ["builtin/exec/main.go"]="-I."
  ["builtin/docker/main.go"]="-I. -I../../thirdparty/proto/opaqueany"
  ["builtin/nomad/nomad.go"]="-I. -I../../thirdparty/proto"
  ["builtin/k8s/k8s.go"]="-I. -I../../thirdparty/proto"
  ["builtin/azure/aci/aci.go"]="-I."
  ["builtin/k8s/apply/plugin.go"]="-I."
  ["builtin/k8s/helm/plugin.go"]="-I."
  ["builtin/nomad/canary/plugin.go"]="-I. -I../../../thirdparty/proto"
  ["builtin/nomad/jobspec/plugin.go"]="-I. -I../../../thirdparty/proto"
  ["builtin/aws/lambda/lambda.go"]="-I. -I../../../thirdparty/proto"
  ["builtin/aws/ecs/main.go"]="-I. -I../../../thirdparty/proto"
  ["builtin/aws/alb/main.go"]="-I. -I../../../thirdparty/proto"
  ["builtin/google/cloudrun/cloudrun.go"]="-I. -I../../../thirdparty/proto/opaqueany"
  ["builtin/aws/ami/main.go"]="-I."
  ["builtin/aws/ecr/ecr.go"]="-I."
  ["builtin/aws/ec2/main.go"]="-I."
  ["builtin/aws/lambda/function_url/plugin.go"]="-I. -I../../../../thirdparty/proto"
)

for file in "${!INCLUDES[@]}"; do
  inc="${INCLUDES[$file]}"
  gen="//go:generate protoc ${inc} --go_out=paths=source_relative:. --go-grpc_out=paths=source_relative:. plugin.proto"
  perl -i -pe "s|^//go:generate protoc.*plugin\\.proto\$|${gen}|" "$file"
done
