#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR

cd "${SRCDIR}/.."

rm -rf dist/
rm -rf static/
if [[ -f autogen/gen.go ]]; then rm autogen/gen.go; fi
