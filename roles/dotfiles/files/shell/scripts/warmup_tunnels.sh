#!/usr/bin/env bash

set -eu -o pipefail
#set -x

declare -r SSH="/usr/bin/ssh"
declare -r DEFAULT_CHECK_COMMAND="hostname"
declare -r DEFAULT_DEBUG="false"

declare -r QNET_JUMP_HOST="qnet.jumphost"
declare -r QNET_MUX_SOCKET="/tmp/ssh_mux_qnet.sock"
declare -r OPENQ_JUMP_HOST="openq.jumphost"
declare -r OPENQ_MUX_SOCKET="/tmp/ssh_mux_openq.sock"

# Configuration
CHECK_COMMAND=${CHECK_COMMAND:-${DEFAULT_CHECK_COMMAND}}
DEBUG=${DEBUG:-${DEFAULT_DEBUG}}


activate::qnet() {
  local log_level="${1:-'QUIET'}"

  if [[ ! -S "${QNET_MUX_SOCKET}" ]]; then
    echo "Activating QNet jumphost with 2FA..."
    ${SSH} -oLogLevel="${log_level}" "${QNET_JUMP_HOST}" "${CHECK_COMMAND}" || return 1
  fi
}

activate::openq() {
  local log_level="${1:-'QUIET'}"

  if [[ ! -S "${OPENQ_MUX_SOCKET}" ]]; then
    echo "Activating OpenQ jumphost with 2FA..."
    ${SSH} -oLogLevel="${log_level}" "${OPENQ_JUMP_HOST}" "${CHECK_COMMAND}" || return 1
  fi
}


main() {
  local log_level="QUIET"

  case ${DEBUG} in
    true) log_level="DEBUG" ;;
  esac

  activate::qnet ${log_level}
  activate::openq ${log_level}
}


#
# ::main::
#
main "${@}"
