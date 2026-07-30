#!/bin/bash

set -euo pipefail

# publish_docker_registries.sh loads per-arch docker tarballs produced by
# hashicorp/actions-docker-build and publishes multi-arch manifests to configured
# container registries (GHCR, ECR Public, Docker Hub).
#
# Usage:
#   ./publish_docker_registries.sh <version> <github_sha> <image_name> <docker_target>
#
# image_name is the repository suffix (e.g. "derrick" or "derrick-odr").
# docker_target is the Dockerfile target name (e.g. "crt" or "odr-crt").
#
# Optional environment variables:
#   PUBLISH_LATEST=true   Also tag and push :latest (recommended on main releases)
#   PUBLISH_GHCR=false    Skip GHCR (default: publish)
#   PUBLISH_ECR=false     Skip ECR Public (default: publish)
#   PUBLISH_DOCKERHUB=false Skip Docker Hub (default: publish)

function usage {
  echo "Usage: $0 <version> <github_sha> <image_name> <docker_target>"
}

function publish_manifest() {
  local registry_prefix="$1"
  shift
  local tags=( "$@" )

  docker manifest rm "${registry_prefix}:${version}" >/dev/null 2>&1 || true
  docker manifest create "${registry_prefix}:${version}" "${tags[@]}"
  docker manifest push "${registry_prefix}:${version}"
  echo "Published ${registry_prefix}:${version}"

  if [[ "${PUBLISH_LATEST:-false}" == "true" ]]; then
    docker manifest rm "${registry_prefix}:latest" >/dev/null 2>&1 || true
    docker manifest create "${registry_prefix}:latest" "${tags[@]}"
    docker manifest push "${registry_prefix}:latest"
    echo "Published ${registry_prefix}:latest"
  fi
}

function publish_registry() {
  local registry_prefix="$1"
  local arch_tags=()

  for arch in amd64 arm64; do
    local arch_tag="${registry_prefix}:${version}-${arch}"
    docker tag "${src_image}" "${arch_tag}"
    docker push "${arch_tag}"
    arch_tags+=( "${arch_tag}" )
  done

  publish_manifest "${registry_prefix}" "${arch_tags[@]}"
}

function ecr_public_registry_prefix() {
  local repo_name="$1"
  local uri

  uri=$(aws ecr-public describe-repositories \
    --repository-names "${repo_name}" \
    --region us-east-1 \
    --query 'repositories[0].repositoryUri' \
    --output text)

  if [[ -z "${uri}" || "${uri}" == "None" ]]; then
    echo "ERROR: could not resolve ECR Public URI for ${repo_name}" >&2
    exit 1
  fi

  # repositoryUri looks like public.ecr.aws/<registry-alias>/<repo>
  echo "${uri%/*}"
}

function main {
  local version="${1:-}"
  local github_sha="${2:-}"
  local image_name="${3:-}"
  local docker_target="${4:-}"

  if [[ -z "${version}" || -z "${github_sha}" || -z "${image_name}" || -z "${docker_target}" ]]; then
    usage
    exit 1
  fi

  local src_image="docker.io/nomatronio/${image_name}:${version}"

  for arch in amd64 arm64; do
    local tar_name="derrick_${docker_target}_linux_${arch}_${version}_${github_sha}.docker.tar"
    if [[ ! -f "${tar_name}" ]]; then
      echo "ERROR: expected tarball ${tar_name} not found"
      exit 1
    fi
    docker load < "${tar_name}"
  done

  if [[ "${PUBLISH_GHCR:-true}" == "true" ]]; then
    publish_registry "ghcr.io/nomatronio/${image_name}"
  fi

  if [[ "${PUBLISH_ECR:-true}" == "true" ]]; then
    local ecr_prefix
    ecr_prefix=$(ecr_public_registry_prefix "${image_name}")
    echo "Publishing to ECR Public at ${ecr_prefix}/${image_name}"
    publish_registry "${ecr_prefix}/${image_name}"
  fi

  if [[ "${PUBLISH_DOCKERHUB:-true}" == "true" ]]; then
    publish_registry "docker.io/nomatronio/${image_name}"
  fi
}

main "$@"
