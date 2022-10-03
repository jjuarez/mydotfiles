#!/usr/bin/env bash

set -e -o pipefail

declare -r SSH="/usr/bin/ssh"
declare -r SOCKET_PREFIX=".ssh-tunnel"

DEBUG="false"

# Configuration
SSH_REMOTE_USER=""
SSH_REMOTE_HOST=""
SSH_REMOTE_PORT=""
SSH_LOCAL_PORT=""
SOCKET=""


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
  utils::exit "Usage: ${0} --network (qnet|openq) --command (start|stop|status)" 0
}

ssh::config() {
  local -r network="${1}"

  case ${network} in
     qnet) SSH_REMOTE_USER="fjjuarez"
           SSH_REMOTE_HOST="9.47.161.61" # eriecanal.cloud9.ibm.com
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8228
           SOCKET="/tmp/${SOCKET_PREFIX}-${SSH_LOCAL_PORT}" ;;

    openq) SSH_REMOTE_USER="runtimedeployusr"
           SSH_REMOTE_HOST="champlaincanal-nat.watson.ibm.com"
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8229
           SOCKET="/tmp/${SOCKET_PREFIX}-${SSH_LOCAL_PORT}" ;;
        *) return 1 ;;
  esac
}

ssh::start() {
  local -r socket="${1}"
  local ssh_extra_opts=""

  [[ -S "${socket}" ]] && utils::exit "A SSH tunnel is already running" 1

  [[ "${DEBUG}" == "true" ]] && ssh_extra_opts="-v"

  ${SSH} -fN \
    ${ssh_extra_opts} \
    -oStrictHostKeyChecking=no \
    -oUserKnownHostsFile=/dev/null \
    -oControlMaster=yes \
    -oPort="${SSH_REMOTE_PORT}" \
    -oControlPath="${socket}" \
    -oDynamicForward="localhost:${SSH_LOCAL_PORT}" \
    -oUser="${SSH_REMOTE_USER}" \
    ${SSH_REMOTE_HOST} &&
  utils::console "Remember to execute: \nexport HTTPS_PROXY=socks5://localhost:${SSH_LOCAL_PORT}\n"
}

ssh::stop() {
  local -r socket="${1}"

  [[ -S "${socket}" ]] || utils::exit "There's no SSH tunnel running" 2

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
  local network=""
  local command=""

  while [[ "${1}" =~ ^- && ! "${1}" == "--" ]]; do
    case "${1}" in
      -n | --network) shift
                      network="${1}"
                      ;;
      -c | --command) shift
                      command="${1}"
                      ;;
        -d | --debug) DEBUG="true"
                      ;;
         -h | --help) utils::help
                      ;;
    esac
    shift
  done

  [[ "${DEBUG}" == "true" ]] && utils::console "Target network: ${network}, command: ${command}"

  ssh::config "${network}" || utils::help
  case "${command}" in
         start) ssh::start "${SOCKET}" ;;
          stop) ssh::stop "${SOCKET}" ;;
        status) ssh::status "${SOCKET}" ;;
             *) utils::help ;;
  esac
}

#
# ::main::
#
main "${@}"
