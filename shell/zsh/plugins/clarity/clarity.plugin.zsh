# vi: set ft=zsh :

# set -eux -o pipefail 

# Configuration
[[ -d "${HOME}/.helm" ]] || mkdir -p "${HOME}/.helm/clusters"

##
# Kubernetes
clarity::kops() {
  local cluster=${1}

  case ${cluster} in
    mgmt)
      export KOPS_STATE_STORE="s3://commonk8s-clarity-mgmt-pro"
      export AWS_PROFILE="mgmt"

      [[ -s "${HOME}/.env.Clarity.tf.mgmt.pro" ]] || return 1
      source "${HOME}/.env.Clarity.tf.mgmt.pro"
      ;;

    stg)
      export KOPS_STATE_STORE="s3://k8s-clarity-saas-stg"
      export AWS_PROFILE="saas-stg"

      [[ -s "${HOME}/.env.Clarity.tf.saas.stg" ]] || return 1
      source "${HOME}/.env.Clarity.tf.saas.stg"
      ;;

    dev|pre|prod)
      # Back to the root account we have to clean the environment
      clarity::aws_clean_credentials
      export KOPS_STATE_STORE="s3://kubernetes.${cluster}.clarity.ai"
      export AWS_PROFILE="default"  # root account
      export KOPS_RUN_OBSOLETE_VERSION="yes"
      ;;

    *)
      return 1
      ;;
  esac
}

clarity::helm() {
  local cluster=${1}

  [[ -d "${HOME}/.helm/clusters/${cluster}" ]] || return 1

  case ${cluster} in
    stg|mgmt|dev|pre|prod)
      [[ -d "${HOME}/.helm/clusters/${cluster}" ]] || return 1
      export HELM_HOME="${HOME}/.helm/clusters/${cluster}"
      ;;

    *)
      return 1
      ;;
  esac
}

clarity::k8s_switch() {
  local cluster=${1}

  case "${cluster}" in
    dev|pre|prod)
      clarity::kops ${cluster}
      clarity::helm ${cluster}
      kubie ctx ${cluster}.clarity.ai -n clarity
      ;;

    mgmt)
      echo "Mgmt"
      clarity::kops ${cluster}
      clarity::helm ${cluster}
      kubie ctx common.${cluster}.clarity.ai -n clarity
      ;;

    stg)
      echo "stg"
      clarity::kops ${cluster}
      clarity::helm ${cluster}
      kubie ctx k8s.${cluster}.clarity.ai -n clarity
      ;;

    *)
      return 1
      ;;
  esac
}

##
# Clean the current AWS environment
clarity::aws_clean_credentials() {
  [[ -n "${AWS_PROFILE}"           ]] && unset AWS_PROFILE
  [[ -n "${AWS_DEFAULT_REGION}"    ]] && unset AWS_DEFAULT_REGION
  [[ -n "${AWS_ACCESS_KEY_ID}"     ]] && unset AWS_ACCESS_KEY_ID
  [[ -n "${AWS_SECRET_ACCESS_KEY}" ]] && unset AWS_SECRET_ACCESS_KEY
}

##
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

##
# Handles the 1Password signin
clarity::op_signin() {
  [[ -s "${HOME}/.1password" ]] || return 1

  eval $(cat "${HOME}/.1password"|op signin --account=clarity.1password.com 2>/dev/null)
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

##
# ::alias:
alias k='kubectl'
alias ksw='clarity::k8s_switch'
alias awscc='clarity::aws_clean_credentials'
