#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR
readonly CONFIGDIR="${SRCDIR}/configs"

# shellcheck source=lib.sh
source "${SRCDIR}/lib.sh"

echo "updating config"
kubectl create configmap traefik-config \
  --namespace traefik \
  --from-file="${CONFIGDIR}/traefik.dust.prod.toml" \
  --from-file="${CONFIGDIR}/marathon.dust.tmpl" \
  --dry-run \
  -o yaml | kubectl replace configmap traefik-config --namespace traefik -f -

echo "deleting DaemonSet Pods to make config update effective"
delete_traefik_pods
