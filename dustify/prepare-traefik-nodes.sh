#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly ROLE_LABEL="dust/role=traefik"

traefik_nodes=($(kubectl get nodes -o=name | grep traefik)) || {
  echo "no Traefik nodes found." >&2
  exit 1
}
readonly traefik_nodes

for node in "${traefik_nodes[@]}"; do
  kubectl drain ${node} --force --ignore-daemonsets
  kubectl label nodes ${node} "${ROLE_LABEL}"
done
