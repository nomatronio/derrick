#!/bin/bash

set -euo pipefail

# publish_ghcr.sh loads per-arch docker tarballs produced by hashicorp/actions-docker-build,
# pushes them to GHCR, and publishes a multi-arch manifest for the given version tag.
#
# Usage:
#   ./publish_ghcr.sh <version> <github_sha> <image_name> <docker_target>
#
# image_name is the GHCR image path suffix (e.g. "derrick" or "derrick-odr").
# docker_target is the Dockerfile target name (e.g. "crt" or "odr-crt").

function usage {
  echo "Usage: $0 <version> <github_sha> <image_name> <docker_target>"
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

  local ghcr_image="ghcr.io/nomatronio/${image_name}"
  local src_image="docker.io/nomatronio/${image_name}:${version}"
  local arch_tags=()

  for arch in amd64 arm64; do
    local tar_name="derrick_${docker_target}_linux_${arch}_${version}_${github_sha}.docker.tar"
    if [[ ! -f "${tar_name}" ]]; then
      echo "ERROR: expected tarball ${tar_name} not found"
      exit 1
    fi

    docker load < "${tar_name}"
    local arch_tag="${ghcr_image}:${version}-${arch}"
    docker tag "${src_image}" "${arch_tag}"
    docker push "${arch_tag}"
    arch_tags+=( "${arch_tag}" )
  done

  docker manifest rm "${ghcr_image}:${version}" >/dev/null 2>&1 || true
  docker manifest create "${ghcr_image}:${version}" "${arch_tags[@]}"
  docker manifest push "${ghcr_image}:${version}"
  echo "Published ${ghcr_image}:${version}"
}

main "$@"
