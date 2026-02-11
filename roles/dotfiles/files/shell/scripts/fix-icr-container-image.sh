#!/usr/bin/env bash

set -eu -o pipefail
#set -x

declare -r DEFAULT_PLATFORM="linux/amd64"
declare -r DEFAULT_ICR="icr.io"
declare -r DEFAULT_ICR_NS="qc-staging-ext-images"

declare -A ICR_NAMESPACES=(



PLATFORM="${PLATFORM:-${DEFAULT_PLATFORM}}"
ICR="${ICR:-${DEFAULT_ICR}}"
ICR_NS="${ICR_NS:-${DEFAULT_ICR_NS}}"


utils::console() {
  local -r message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}" >&2
}

utils::panic() {
  local -r message="${1}"
  local -ri exit_code=${2}

  utils::console "${message}"
  exit ${exit_code}
}

image::fix() {
  local -r image="${1}"
  local -r icr_image="${ICR}/${ICR_NS}/${image}"

  echo -e "ICR image: ${icr_image}"

  docker image pull --platform "${PLATFORM}" "${image}"
  docker image tag "${image}" "${icr_image}"
  docker image push --platform "${PLATFORM}" "${icr_image}"
}


#
# ::main::
#
if [ "${1:-'none'}" != "none" ]; then
  image::fix "${1}"
fi
