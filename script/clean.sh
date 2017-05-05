#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; readonly SRCDIR

dir_is_non_empty() {
  local -r dir="$1"
  if [[ -n "$(ls -A "${dir}")" ]]; then
    return 0
  fi
  return 1
}

cd "${SRCDIR}/.."

if dir_is_non_empty dist; then rm -r dist/*; fi
if dir_is_non_empty static; then rm -r static/*; fi
if [[ -f autogen/gen.go ]]; then rm autogen/gen.go; fi
