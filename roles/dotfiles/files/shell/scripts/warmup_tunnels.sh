#!/usr/bin/env bash

set -u -o pipefail
#set -x

declare -r SSH="/usr/bin/ssh"
declare -r DEFAULT_CHECK_COMMAND="hostname"
declare -r DEFAULT_DEBUG="false"
declare -r DEFAULT_LOG_LEVEL="INFO"

declare -r QNET_JUMP_HOST="qnet.jumphost"
declare -r QNET_MUX_SOCKET="/tmp/ssh_mux_qnet.sock"
declare -r OPENQ_JUMP_HOST="openq.jumphost"
declare -r OPENQ_MUX_SOCKET="/tmp/ssh_mux_openq.sock"

# Configuration
CHECK_COMMAND=${CHECK_COMMAND:-${DEFAULT_CHECK_COMMAND}}
LOG_LEVEL=${LOG_LEVEL:-${DEFAULT_LOG_LEVEL}}
DEBUG=${DEBUG:-${DEFAULT_DEBUG}}


activate::qnet() {
  if [[ -S "${QNET_MUX_SOCKET}" ]]; then
    echo "There's already a socket for QNet"
    return 1
  fi

  echo "Activating QNet jumphost with 2FA..."
  ${SSH} -oLogLevel="${LOG_LEVEL}" "${QNET_JUMP_HOST}" "${CHECK_COMMAND}"
}

activate::openq() {
  if [[ -S "${OPENQ_MUX_SOCKET}" ]]; then
    echo "There's already a socket for OpenQ"
    return 2
  fi

  echo "Activating OpenQ jumphost with 2FA..."
  ${SSH} -oLogLevel="${LOG_LEVEL}" "${OPENQ_JUMP_HOST}" "${CHECK_COMMAND}"
}

setup() {
  case ${DEBUG} in
    true) LOG_LEVEL="DEBUG" ;;
  esac
}

main() {
  setup
  activate::qnet  "${LOG_LEVEL}"
  activate::openq "${LOG_LEVEL}"
}

#
# ::main::
#
main "${@}"
