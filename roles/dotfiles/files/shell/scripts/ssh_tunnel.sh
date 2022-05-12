#!/usr/bin/env bash

set -eu -o pipefail

declare -r SSH="/usr/bin/ssh"
declare -r SOCKET_PREFIX=".ssh-tunnel"

SSH_REMOTE_USER="fjjuarez"
SSH_REMOTE_HOST="9.47.161.61"  # The VPN DNS doesn't work very well eriecanal.cloud9.ibm.com"
SSH_REMOTE_PORT=22
SSH_LOCAL_PORT=8228
SOCKET="/tmp/${SOCKET_PREFIX}-${SSH_LOCAL_PORT}"


utils::console() {
  local -r message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}" >&2
}

utils::exit() {
  local -r message="${1}"
  local -ri exit_code="${2}"

  utils::console "${message}"
  exit "${exit_code}"
}

utils::help() {
  utils::exit "Usage: ${0} (up|down|status)" 0
}


ssh::up() {
  local -r socket="${1}"

  [[ -S "${socket}" ]] && utils::exit "A SSH tunnel is already running" 1

  ${SSH} -fN \
    -oStrictHostKeyChecking=no \
    -oUserKnownHostsFile=/dev/null \
    -oControlMaster=yes \
    -oPort="${SSH_REMOTE_PORT}" \
    -oControlPath="${SOCKET}" \
    -oDynamicForward="localhost:${SSH_LOCAL_PORT}" \
    -oUser="${SSH_REMOTE_USER}" \
    ${SSH_REMOTE_HOST} &&
  utils::console "Remember to execute: 'export HTTPS_PROXY=socks5://localhost:${SSH_LOCAL_PORT}'"
}

ssh::down() {
  local -r socket="${1}"

  [[ -S "${socket}" ]] || utils::console "There's no SSH tunnel running" 2

  ${SSH} -S ${SOCKET} -O exit ${SSH_REMOTE_HOST} >/dev/null 2>&1
}

ssh::status() {
  local -r socket="${1}"

  if [[ -S "${socket}" ]]; then 
    utils::exit "The SSH tunnel is running" 0
  else
    utils::exit "The SSH tunnel is stopped" 1
  fi
}

main() {
  local -r command=${1:-'none'}
  
  case "${command}" in
        up) ssh::up "${SOCKET}" ;;
      down) ssh::down "${SOCKET}" ;;
    status) ssh::status "${SOCKET}" ;;
         *) utils::help ;;
  esac
}

main "${@}"
