#!/usr/bin/env zsh

: '
This shell script will help you to user the SSH privates keys used in the tunnels and DTB

# Usage:

## Requirements
 - Having the SSH private keys in the ${HOME}/.ssh directory

'

set -eu -o pipefail

declare -r DEFAULT_TEMPORAL_DIRECTORY="/private/tmp"  # The default on macOS
declare -r TEMPORAL_DIRECTORY="${TEMPORAL_DIRECTORY:-${DEFAULT_TEMPORAL_DIRECTORY}}"
declare -A SSH_PRIVATE_KEYS=(
  [id_rsa.qnet]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.qnet"
  [id_rsa.openq]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.openq"
  [id_rsa.ccf]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.ccf"
  [id_rsa.sk]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.sk"
  [d_rsa.bmt]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.bmt"
)


check() {
  for ssh_key in ${(k)SSH_PRIVATE_KEYS}; do
    local dst_filename="${TEMPORAL_DIRECTORY}/${ssh_key}"

    [[ ! -f "${dst_filename}" ]] && echo "There's no ${dst_filename}"
  done
}


clean() {
  for ssh_key in ${(k)SSH_PRIVATE_KEYS}; do
    local dst_filename="${TEMPORAL_DIRECTORY}/${ssh_key}"

    [[ -f "${dst_filename}" ]] && rm -fr "${dst_filename}"
  done
}


install() {
  for ssh_key src in ${(kv)SSH_PRIVATE_KEYS}; do
    local dst_filename="${TEMPORAL_DIRECTORY}/${ssh_key}"

    [[ -d "${dst_filename}" ]] && rm -fr "${dst_filename}"
    [[ -f "${src}" ]] && cp -avf "${src}" "${dst_filename}"
  done
}


#
# ::main::
#
COMMAND="${1:-'none'}"

case "${COMMAND}" in
    check) check ;;
    clean) clean ;;
  install) install ;;
        *) echo -e "Usage: ${0} (install|clean)" ;;
esac
