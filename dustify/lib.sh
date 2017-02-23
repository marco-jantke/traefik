#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

delete_traefik_pods() {
  # shellcheck disable=SC2046
  kubectl delete --namespace traefik \
    $(kubectl get pods --selector k8s-app=traefik-ingress-lb --namespace traefik -o=name | paste -d' ' -s -)
}
