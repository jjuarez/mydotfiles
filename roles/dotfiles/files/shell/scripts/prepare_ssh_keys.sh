#!/usr/bin/env zsh

: '
This shell script will help you to user the SSH privates keys used in the tunnels and DTB

# Usage:

## Requirements
 - Having the SSH private keys in the ${HOME}/.ssh directory

'

set -eu -o pipefail

declare -r TEMPORAL_DIRECTORY=${TEMPORAL_DIRECTORY:-'/tmp'}
declare -A SSH_PRIVATE_KEYS=(
  [/tmp/id_rsa.qnet]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.qnet"
  [/tmp/id_rsa.openq]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.openq"
  [/tmp/id_rsa.ccf]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.ccf"
  [/tmp/id_rsa.sk]="${HOME}/.ssh/id_rsa.ibm.runtimedeployusr.sk"
)


main() {
  for dst src in ${(kv)SSH_PRIVATE_KEYS}; do
    [[ -f "${src}" ]] && cp -avf "${src}" "${dst}"
  done
}

#
# ::main::
#
main "${@}"
