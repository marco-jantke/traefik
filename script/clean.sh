#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR

cd "${SRCDIR}/.."

if [[ -d dist/ ]]; then rm -r dist/; fi
if [[ -d static/ ]]; then rm -r static/; fi
if [[ -f autogen/gen.go ]]; then rm autogen/gen.go; fi
