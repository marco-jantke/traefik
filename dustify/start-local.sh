#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR
readonly PROJECTDIR="${SRCDIR}/.."
readonly CONFIGDIR="${SRCDIR}/configs"

usage() {
  echo "usage: $(basename "$0") -h | [-b] [-n <Kubernetes namespace>] [-- <Traefik arguments>]
  -h: this help screen
  -b: build Traefik prior to running
  -n <Kubernetes namespace>: restrict to the given namespace [default: don't use Kubernetes]
" >&2
exit 1
}

BUILD=
KUBE_NAMESPACE=
while getopts ":bhn:" opt; do
  case "${opt}" in
    b)
      BUILD=yes
      ;;
    h)
      usage
      ;;
    n)
      KUBE_NAMESPACE="${OPTARG}"
      ;;
    --)
      break
      ;;
    \?)
      echo "invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "option -$OPTARG requires an argument" >&2
      usage
      ;;
  esac
done
shift $((OPTIND-1))
readonly BUILD
readonly KUBE_NAMESPACE

if [[ "${BUILD}" ]]; then
  echo "building traefik backend..."
  (
  cd "${PROJECTDIR}"
  go generate
  go build -o dist/traefik ./cmd/traefik
  )
fi

kube_params=
if [[ "${KUBE_NAMESPACE}" ]]; then
  kube_params="--kubernetes --kubernetes.endpoint=http://127.0.0.1:8001 --kubernetes.namespaces=${KUBE_NAMESPACE} --kubernetes.filename=${CONFIGDIR}/kubernetes.dust.tmpl"
fi

"${PROJECTDIR}/dist/traefik" \
  --configfile="${CONFIGDIR}/traefik.dust.toml" \
  ${kube_params} \
  "$@"
