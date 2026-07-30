#!/bin/bash

set -euo pipefail

# ensure_ecr_public_repos.sh creates ECR Public repositories if they do not exist.
# ECR Public does not auto-create repositories on docker push (unlike Docker Hub).

function ensure_repo() {
  local repo_name="$1"
  local catalog_file="$2"

  if aws ecr-public describe-repositories \
    --repository-names "${repo_name}" \
    --region us-east-1 >/dev/null 2>&1; then
    echo "ECR Public repository ${repo_name} already exists"
    return 0
  fi

  echo "Creating ECR Public repository ${repo_name}..."
  aws ecr-public create-repository \
    --repository-name "${repo_name}" \
    --catalog-data "file://${catalog_file}" \
    --region us-east-1
}

ensure_repo "derrick" ".github/ecr-public/derrick-catalog.json"
ensure_repo "derrick-odr" ".github/ecr-public/derrick-odr-catalog.json"
