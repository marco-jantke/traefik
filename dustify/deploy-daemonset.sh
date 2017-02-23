#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR
readonly SPEC_FILE="${SRCDIR}/configs/kube-defs/traefik-controller-daemonset.yml"

# shellcheck source=lib.sh
source "${SRCDIR}/lib.sh"

usage() {
  echo "usage: $(basename "$0") [<git hash>]
<git hash>: the git hash to use as version [default: git rev-parse --short HEAD]" >&2
}

if [[ $# -gt 1 ]]; then
  echo "surplus parameters"
  usage
  exit 1
fi

git_hash=
if [[ $# -eq 1 ]]; then
  if [[ "$1" = "-h" ]]; then
    usage
    exit 1
  fi

  git_hash="$1"
else
  git_hash="$(git rev-parse --short HEAD)"
fi
readonly git_hash

echo "applying spec"
sed "s/%VERSION%/${git_hash}/" "${SPEC_FILE}" | kubectl apply --namespace traefik -f -

echo "deleting DaemonSet Pods to make spec update effective"
delete_traefik_pods
