#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

PROJECT_DIR_REL='src/github.com/containous/traefik'

### Check GOPATH.
if [[ "${GOPATH:-}" == "" ]]; then
  echo 'GOPATH is not set' >&2
  exit 1
fi

### Execute pipeline.
cd "${GOPATH}/${PROJECT_DIR_REL}"
echo 'running validations'
make validate
echo 'running unit tests'
make test-unit
echo 'pulling Docker images for integration tests'
make pull-images
# Run flaky integration tests up to 3 times.
succ=
for attempt in 1 2 3; do
  echo "running integration tests (attempt #${attempt})"
  if make test-integration; then
    succ=1
    break
  fi
done
if [[ -z "${succ}" ]]; then
  echo 'integration tests failed.' >&2
  exit 1
fi
