# vi: set ft=zsh :

# set -eux -o pipefail 

clarity::_vpn_password() {
  local vpn_password=""
  local vpn_totp=""

  if [ -z "${OP_SESSION_clarity}" ]; then
    [[ -s "${HOME}/.1password" ]] || return 1
    eval $(cat "${HOME}/.1password"|op signin --account=clarity.1password.com 2>/dev/null)
  fi

  vpn_password="$(op get item 'Clarity VPN' 2>/dev/null|jq -r '.details.fields[1].value')"
  vpn_totp="$(op get totp 'Clarity VPN' 2>/dev/null)"

  echo "${vpn_password}${vpn_totp}"
}

# ::alias::
