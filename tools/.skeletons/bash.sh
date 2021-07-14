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
  local -ri exit_code="${1}"; shift
  local -r message="${1}"

  utils::console "${message}"
  exit "${exit_code}"
}

#
# ::main::
#
utils::console "Your code goes here!"
