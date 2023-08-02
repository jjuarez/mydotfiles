#!/usr/bin/env zsh

set -e -o pipefail

declare -r SSH="/usr/bin/ssh"
declare -r DEFAULT_CHECK_COMMAND="hostname"
declare -r DEFAULT_DEBUG="false"

# Configuration
CHECK_COMMAND=${CHECK_COMMAND:-${DEFAULT_CHECK_COMMAND}}
DEBUG=${DEBUG:-${DEFAULT_DEBUG}}


utils::console() {
  local -r message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}" >&2
}

main() {
  local log_level="QUIET"

  case ${DEBUG} in
    true) log_level="DEBUG" ;;
  esac

  for jh in openq qnet; do
    utils::console "Warmup ${jh} jumphost with 2FA..."
    ${SSH} -oLogLevel=${log_level} ${jh}.jumphost ${CHECK_COMMAND}
  done
}

#
# ::main::
#
main "${@}"
