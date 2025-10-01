#!/usr/bin/env bash

set -u -o pipefail
#set -x

#
# Configuration defaults
#
declare -r DEFAULT_CHECK_COMMAND="hostname"
declare -r DEFAULT_CLEANUP="false"
declare -r DEFAULT_DEBUG="false"
declare -r DEFAULT_LOG_LEVEL="INFO"

declare -r SSH="/usr/bin/ssh"
declare -r QNET_JUMP_HOST="qnet.jumphost"
declare -r QNET_SOCKET="/tmp/ssh_mux_qnet.sock"
declare -r OPENQ_JUMP_HOST="openq.jumphost"
declare -r OPENQ_SOCKET="/tmp/ssh_mux_openq.sock"

#
# Configuration
#
CHECK_COMMAND=${CHECK_COMMAND:-${DEFAULT_CHECK_COMMAND}}
LOG_LEVEL=${LOG_LEVEL:-${DEFAULT_LOG_LEVEL}}
CLEANUP=${CLEANUP:-${DEFAULT_CLEANUP}}
DEBUG=${DEBUG:-${DEFAULT_DEBUG}}

utils::console() {
  local -r message="${1}"

  if [[ -n "${message}" ]]; then
    echo -e "${message}"
  fi
}

utils::setup() {
  case ${DEBUG} in
    true) LOG_LEVEL="DEBUG" ;;
  esac
}

utils::cleanup() {
  if [[ -S "${OPENQ_SOCKET}" ]]; then
    rm -f "${OPENQ_SOCKET}"
  fi

  if [[ -S "${QNET_SOCKET}" ]]; then
    rm -f "${QNET_SOCKET}"
  fi
}

activate::ssh_tunnel() {
  local -r jump_host="${1}"
  local -r jump_host_socket="${2}"

  if [[ -S "${jump_host_socket}" ]]; then
    if [[ "${DEBUG}" == "true" ]]; then
      utils::console "There's already a socket for: ${jump_host}"
    fi
    return 0
  fi

  utils::console "Activating the ${jump_host} jumphost with 2FA... "
  ${SSH} -oLogLevel="${LOG_LEVEL}" "${jump_host}" "${CHECK_COMMAND}"
}

main() {
  utils::setup

  case ${CLEANUP} in
    true) utils::cleanup ;;
  esac

  activate::ssh_tunnel "${OPENQ_JUMP_HOST}" "${OPENQ_SOCKET}"
  activate::ssh_tunnel "${QNET_JUMP_HOST}" "${QNET_SOCKET}"
}

#
# ::main::
#
main "${@}"
