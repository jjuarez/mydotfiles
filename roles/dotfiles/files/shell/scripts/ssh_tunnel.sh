#!/usr/bin/env bash

: '
This shell script will help you to manage the needed SSH tunnels to acces host deployed in the OpenQ and QNet.

# Usage:

## Requirements
 - Having a functional installation of the SSH agent
 - Having your private SSH keys loaded in the SSH agent

## How to open a SSH tunnel to access to OpenQ network
 - ssh_tunnel.sh --network openq --command start
 - export the HTTPS_PROXY environment variable usign the value provided by the start command
 - Try a simple operation to reach, for example, the API endpoint of an OpenShift cluster doing: kubectl cluster-info, of course,
   before to execute this you should have access to the cluster, and having the kubeconfig configuration available.
'

set -e -o pipefail

declare -r SSH="/usr/bin/ssh"
declare -r SOCKET_PREFIX=".ssh-tunnel"
declare -r TEMPORAL_DIRECTORY=${TEMPORAL_DIRECTORY:-'/tmp'}

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
  utils::exit "Usage: ${0} [-d|--debug] (-n|--network) (qnet|openq|ccf) (-c|--command) (start|stop|status)" 0
}

ssh::config() {
  local -r network="${1}"

  case ${network} in
     qnet) SSH_REMOTE_USER="runtimedeployusr"
           SSH_REMOTE_HOST="saimaa.cloud9.ibm.com"
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8228
           SOCKET="${TEMPORAL_DIRECTORY}/${SOCKET_PREFIX}-qnet-${SSH_LOCAL_PORT}" ;;

    openq) SSH_REMOTE_USER="runtimedeployusr"
           SSH_REMOTE_HOST="champlaincanal-nat.watson.ibm.com"
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8229
           SOCKET="${TEMPORAL_DIRECTORY}/${SOCKET_PREFIX}-openq-${SSH_LOCAL_PORT}" ;;
      ccf) SSH_REMOTE_USER="runtimedeployusr"
           SSH_REMOTE_HOST="ibmq-bastion.cloud9.ibm.com"
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8230
           SOCKET="${TEMPORAL_DIRECTORY}/${SOCKET_PREFIX}-ccf-${SSH_LOCAL_PORT}" ;;
      sk)  SSH_REMOTE_USER="runtimedeployusr"
           SSH_REMOTE_HOST="9.116.12.201" # koshiba.sk.jb.ibm-com
           SSH_REMOTE_PORT=22
           SSH_LOCAL_PORT=8231
           SOCKET="${TEMPORAL_DIRECTORY}/${SOCKET_PREFIX}-sk-${SSH_LOCAL_PORT}" ;;
        *) return 1 ;;
  esac
}

ssh::start() {
  local -r socket="${1}"

  [[ -S "${socket}" ]] && utils::exit "A SSH tunnel is already running" 1

  case "${DEBUG}" in
    true)
      ${SSH} -Nf \
        -oStrictHostKeyChecking=no \
        -oUserKnownHostsFile=/dev/null \
        -oControlMaster=yes \
        -oPort="${SSH_REMOTE_PORT}" \
        -oControlPath="${socket}" \
        -oDynamicForward="localhost:${SSH_LOCAL_PORT}" \
        -oUser="${SSH_REMOTE_USER}" \
        -oLogLevel=DEBUG \
        ${SSH_REMOTE_HOST} &&
      utils::console "Remember to execute: \nexport HTTPS_PROXY=socks5://localhost:${SSH_LOCAL_PORT}\n"
    ;;

    *)
      ${SSH} -Nf \
        -oStrictHostKeyChecking=no \
        -oUserKnownHostsFile=/dev/null \
        -oControlMaster=yes \
        -oPort="${SSH_REMOTE_PORT}" \
        -oControlPath="${socket}" \
        -oDynamicForward="localhost:${SSH_LOCAL_PORT}" \
        -oUser="${SSH_REMOTE_USER}" \
        -oLogLevel=QUIET \
        ${SSH_REMOTE_HOST} &&
      utils::console "Remember to execute: \nexport HTTPS_PROXY=socks5://localhost:${SSH_LOCAL_PORT}\n"
    ;;
  esac
}

ssh::stop() {
  local -r socket="${1}"

  [[ -S "${socket}" ]] || utils::exit "There's no SSH tunnel running" 2

  ${SSH} -S "${SOCKET}" -O exit "${SSH_REMOTE_HOST}" >/dev/null 2>&1
}

ssh::status() {
  local -r socket="${1}"

  if [[ -S "${socket}" ]]; then 
    utils::exit "The SSH tunnel is running\nexport HTTPS_PROXY='socks5://localhost:${SSH_LOCAL_PORT}'" 0
  else
    utils::exit "The SSH tunnel is stopped" 1
  fi
}

main() {
  local network=""
  local cmd=""

  while [[ "${1}" =~ ^- && ! "${1}" == "--" ]]; do
    case "${1}" in
      -n | --network) shift
                      network="${1}"
                      ;;
      -c | --command) shift
                      cmd="${1}"
                      ;;
        -d | --debug) DEBUG="true"
                      ;;
         -h | --help) utils::help
                      ;;
    esac
    shift
  done

  [[ "${DEBUG}" == "true" ]] && utils::console "Target network: ${network}, command: ${cmd}"

  ssh::config "${network}" || utils::help
  case "${cmd}" in
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
