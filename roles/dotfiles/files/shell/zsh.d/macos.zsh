#set -u -o pipefail
#set -x

[[ -z "${NETWORK_SERVICE_NAME}" ]] && declare -r NETWORK_SERVICE_NAME="Wi-Fi"


macos::get_dns() {
  networksetup -getdnsservers ${NETWORK_SERVICE_NAME}
}

macos::set_dns() {
  local -r provider="${1:-google}"

  case ${provider} in
    cloudflare)
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} empty &&
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} 1.1.1.1 1.0.0.1 &&
      sudo killall -HUP mDNSResponder
      ;;
    google)
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} empty &&
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} 8.8.8.8 8.8.4.4 &&
      sudo killall -HUP mDNSResponder
      ;;
    opendns)
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} empty &&
      sudo networksetup -setdnsservers ${NETWORK_SERVICE_NAME} 208.67.222.222 208.67.220.220
      sudo killall -HUP mDNSResponder
      ;;
  esac
}

# autoloads
autoload macos::get_dns
autoload macos::set_dns

# aliases
alias gdns='macos::get_dns'
alias sdns='macos::set_dns'
