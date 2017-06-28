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

echo 'clean'
make clean

echo 'cleanup previous state'
make cleanup-integration-tests

echo 'running validations'
make validate

echo 'running unit tests'
make test-unit

echo 'pulling Docker images for integration tests'
make pull-images

echo 'running integration tests'
make test-integration
