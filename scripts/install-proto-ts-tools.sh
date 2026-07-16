#!/usr/bin/env bash
# Install protoc plugins required by `make gen/ts`.
set -euo pipefail

npm install -g protoc-gen-grpc-web@1.5.0 protoc-gen-js ts-protoc-gen

echo "Installed: protoc-gen-grpc-web, protoc-gen-js, protoc-gen-ts"
