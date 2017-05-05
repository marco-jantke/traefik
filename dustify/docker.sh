#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

PROJECT_DIR_REL='src/github.com/containous/traefik'

usage() {
  echo "usage: $(basename "$0") <Docker image tag>" >&2
}

### Check GOPATH.
if [[ "${GOPATH:-}" == "" ]]; then
  echo 'GOPATH is not set' >&2
  exit 1
fi

### Process input parameter(s).
if [[ $# -ne 1 ]]; then
  echo 'insufficient number of parameters' >&2
  usage
  exit 1
fi
readonly tag="$1"

### Build and push Docker image.
readonly image="docker-registry.hc.ag/dust/traefik:${tag}"
echo "building Docker image ${image}"
cd "${GOPATH}/${PROJECT_DIR_REL}"
REPO="${image}" make image
echo 'pushing Docker image'
docker push "${image}"
