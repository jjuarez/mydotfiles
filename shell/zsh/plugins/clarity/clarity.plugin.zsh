# vi: set ft=zsh :

# set -eux -o pipefail 

# Clean the current AWS environment
clarity::aws_clean_credentials() {
  [[ -n "${AWS_PROFILE}"           ]] && unset AWS_PROFILE
  [[ -n "${AWS_DEFAULT_REGION}"    ]] && unset AWS_DEFAULT_REGION
  [[ -n "${AWS_ACCESS_KEY_ID}"     ]] && unset AWS_ACCESS_KEY_ID
  [[ -n "${AWS_SECRET_ACCESS_KEY}" ]] && unset AWS_SECRET_ACCESS_KEY
}

# Builds the MongoDB URI
clarity::mongodb_uri() {
  local environment=${1}

  case ${environment} in
    dev) echo "mongodb://int.mongodb-01.dev.clarity.ai:27017 --authenticationDatabase=admin --username=admin"
      ;;
    pre) echo "mongodb://int.mongodb-01.pre.clarity.ai:27017,int.mongodb-02.pre.clarity.ai:27017,int.mongodb-03.pre.clarity.ai:27017/?replicaSet=rs0 --authenticationDatabase=admin --username=admin"
      ;;
    stg) echo "mongodb://int.mongodb-01.stg.clarity.ai:27017,int.mongodb-02.stg.clarity.ai:27017,int.mongodb-03.stg.clarity.ai:27017/?replicaSet=rs0 --authenticationDatabase=admin --username=admin"
      ;;
    prod) echo "mongodb://int.mongodb-01.prod.clarity.ai:27017,int.mongodb-02.prod.clarity.ai:27017,int.mongodb-03.prod.clarity.ai:27017?replicaSet=rs0 --autheticationDatabase=admin --username=admin"
      ;;
    *) return 1
      ;;
  esac

  return 0
}

clarity::vpn_password() {
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

# ::alias:
alias awscc='clarity::aws_clean_credentials'
