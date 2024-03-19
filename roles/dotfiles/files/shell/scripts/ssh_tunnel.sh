#!/usr/bin/env zsh

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
declare -r DEFAULT_CHECK_COMMAND="hostname"

typeset -A CONFIG=(
  [qnet]="javier-juarez-martinez;elmira.watson.ibm.com;22;8123"
  [openq]="javier-juarez-martinez;champlaincanal-nat.watson.ibm.com;22;8124"
  [sk]="javier-juarez-martinez;9.116.12.201;22;8125"
  [ccf]="javier-juarez-martinez;ibmq-bastion.cloud9.ibm.com;22;8126"
  [bmt]="javier-juarez-martinez;bmt-jump.bromont.can.ibm.com;22;8127"
  [ehn]="javier-juarez-martinez;pauli.ehningen.de.ibm.com;22;8128"
)

# Configuration
CHECK_COMMAND=${CHECK_COMMAND:-${DEFAULT_CHECK_COMMAND}}
DEBUG="false"

SSH_REMOTE_HOST=""
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
  utils::exit "Usage: ${0} [-d|--debug] (-n|--network) (qnet|openq|ccf|sk|bmt|ehn) (-c|--command) (start|stop|status|check)" 0
}

ssh::config() {
  local -r network="${1}"

  case ${network} in
    qnet|openq|sk|ccf|bmt|ehn)
      SSH_REMOTE_USERNAME=$(echo ${CONFIG[$network]}|awk -F";" '{print $1 }')
      SSH_REMOTE_HOST=$(echo ${CONFIG[$network]}|awk -F";" '{print $2 }')
      SSH_REMOTE_PORT=$(echo ${CONFIG[$network]}|awk -F";" '{print $3 }')
      SSH_LOCAL_PORT=$(echo ${CONFIG[$network]}|awk -F";" '{print $4 }')
      SOCKET="${TEMPORAL_DIRECTORY}/${SOCKET_PREFIX}-${network}-${SSH_LOCAL_PORT}"
      ;;

    *) return 1 ;;
  esac
}

ssh::start() {
  local -r socket="${1}"
  local log_level="QUIET"

  [[ -S "${socket}" ]] && utils::exit "A SSH tunnel is already running" 1

  case "${DEBUG}" in
    true) log_level="DEBUG" ;;
  esac

  ${SSH} -Nf \
    -oStrictHostKeyChecking=no \
    -oUserKnownHostsFile=/dev/null \
    -oControlMaster=yes \
    -oPort="${SSH_REMOTE_PORT}" \
    -oControlPath="${socket}" \
    -oDynamicForward="localhost:${SSH_LOCAL_PORT}" \
    -oUser="${SSH_REMOTE_USERNAME}" \
    -oLogLevel="${log_level}" \
    ${SSH_REMOTE_HOST} &&
    utils::console "(${SSH_REMOTE_HOST}) Remember to execute: \nexport HTTPS_PROXY=socks5://localhost:${SSH_LOCAL_PORT}\n"
}

ssh::stop() {
  local -r socket="${1}"
  local log_level="QUIET"

  [[ -S "${socket}" ]] || utils::exit "There's no SSH tunnel running" 2

  case "${DEBUG}" in
    true) log_level="DEBUG" ;;
  esac

  ${SSH} -oLogLevel="${log_level}" -S "${SOCKET}" -O exit "${SSH_REMOTE_HOST}" >/dev/null 2>&1
}

ssh::status() {
  local -r socket="${1}"

  if [[ -S "${socket}" ]]; then
    utils::exit "The SSH tunnel is running\nexport HTTPS_PROXY='socks5://localhost:${SSH_LOCAL_PORT}'" 0
  else
    utils::exit "The SSH tunnel is stopped" 1
  fi
}

ssh::check() {
  local log_level="QUIET"

  [[ -S "${SOCKET}" ]] || utils::exit "There's no SSH tunnel running" 2

  case "${DEBUG}" in
    true) log_level="DEBUG" ;;
  esac

  ${SSH} -oLogLevel="${log_level}" -S "${SOCKET}" -O check ${SSH_REMOTE_HOST}

  if [[ "${?}" -eq 0  ]]; then
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
      -n|--network)
        shift
        network="${1}"
        ;;
      -c|--command)
        shift
        cmd="${1}"
        ;;
      -d|--debug)
        DEBUG="true"
        ;;
      -h|--help)
        utils::help
        ;;
    esac
    shift
  done

  ssh::config "${network}" || utils::help
  case "${cmd}" in
         start) ssh::start "${SOCKET}" ;;
          stop) ssh::stop "${SOCKET}" ;;
        status) ssh::status "${SOCKET}" ;;
         check) ssh::check ;;
             *) utils::help ;;
  esac
}

#
# ::main::
#
main "${@}"
