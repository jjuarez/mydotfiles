#!/usr/bin/env bash

set -eu -o pipefail
#set -x

declare -r DEFAULT_FOO="Foo value"
FOO="${FOO:-${DEFAULT_FOO}}"


utils::console() {
  local -r message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}" >&2
}

utils::panic() {
  local -r message="${1}"
  local -ri exit_code=${2:-0}

  utils::console "${message}"
  exit ${exit_code}
}

#
# ::main::
#
utils::console "Your code goes here!"
