# vi: set ft=zsh :
declare -r DEFAULT_NAMESPACE='default'
declare -r DEFAULT_AWS_PROFILE='default'
declare -r DEFAULT_ENVIRONMENT='dev'
declare -r DEFAULT_MONGODB_USER='admin'
declare -r DEFAULT_MONGODB_RS='rs0'
declare -r DEFAULT_MONGODB_AUTH_DB='admin'
declare -r K8S_DEFAULT_NS='clarity'

# Configuration
[[ -d "${HOME}/.helm" ]] || mkdir -p "${HOME}/.helm/clusters"
export HELM_ROOT="${HOME}/.helm"

# Dependencies
KCTL=$(which kubectl 2>/dev/null)
KCTX=$(which kubectx 2>/dev/null)
KNS=$(which kubens 2>/dev/null)
KOPS=$(which kops 2>/dev/null)
HELM=$(which helm 2>/dev/null)
OP=$(which op 2>/dev/null)

[[ -x "${KCTL}" ]] || return 1
[[ -x "${KCTX}" ]] || return 1
[[ -x "${KNS}"  ]] || return 1
[[ -x "${KOPS}" ]] || return 1
[[ -x "${HELM}" ]] || return 1
[[ -x "${OP}"   ]] || return 1


##
# Kubernetes
clarity::context() {
  local environment=${1}

  ${KCTX} ${environment}.clarity.ai 2>&1 >/dev/null
}


clarity::kops() {
  local environment=${1}

  case ${environment} in
    common.mgmt)
      export KOPS_STATE_STORE="s3://commonk8s-clarity-mgmt-pro"
      export AWS_PROFILE="mgmt"

      # Workaround kops does not work well with profiles
      [[ -s "${HOME}/.env.Clarity.tf.mgmt.pro" ]] || return 1
      source "${HOME}/.env.Clarity.tf.mgmt.pro"
      ;;

    k8s.stg)
      export KOPS_STATE_STORE="s3://k8s-clarity-saas-stg"
      export AWS_PROFILE="saas-stg"

      # Workaround kops does not work well with profiles
      [[ -s "${HOME}/.env.Clarity.tf.saas.stg" ]] || return 1
      source "${HOME}/.env.Clarity.tf.saas.stg"
      ;;

    dev|pre|prod)
      export KOPS_STATE_STORE="s3://kubernetes.${environment}.clarity.ai"
      export AWS_PROFILE="default"
      ;;

    *)
      return 1
      ;;
  esac
}


clarity::helm() {
  local environment=${1}

  [[ -d "${HELM_ROOT}/clusters/${environment}.clarity.ai" ]] || return 2

  case ${environment} in
    k8s.stg|common.mgmt|dev|pre|prod)
      [[ -d "${HELM_ROOT}/clusters/${environment}.clarity.ai" ]] || return 1
      export HELM_HOME="${HELM_ROOT}/clusters/${environment}.clarity.ai"
      ;;

    *)
      return 1
      ;;
  esac
}


clarity::k8s_load_configs() {
  local new_kubeconfig=""

  [[ -d "${HOME}/.kube" ]] || return 1

  new_kubeconfig=$(find ${HOME}/.kube -type f -iname "*.config" -print|tr '\n' ':'|sed -e 's/:$//g')

  [[ -n "${new_kubeconfig}" ]] || return 1

  export KUBECONFIG="${new_kubeconfig}"
}


clarity::k8s_switch() {
  local environment=${1:-${DEFAULT_ENVIRONMENT}}
  local namespace=${2:-${DEFAULT_NAMESPACE}}
  local test=${3:-'nope'}

  case "${environment}" in
    k8s.stg|common.mgmt|dev|pre|prod)
      clarity::context ${environment} ${namespace}
      clarity::kops ${environment}
      clarity::helm ${environment}
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
  local environment=${1:-${DEFAULT_ENVIRONMENT}}
  local user=${2:-${DEFAULT_MONGODB_USER}}
  local replica_set=${3:-${DEFAULT_MONGODB_RS}}
  local auth_db=${4:-${DEFAULT_MONGODB_AUTH_DB}}
  local hosts=""
  local mongodb_uri=""

  case ${environment} in
    dev)
      hosts="int.mongodb-01.dev.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/ --authenticationDatabase=${auth_db} --username=${user}"
      ;;

    pre)
      hosts="int.mongodb-01.pre.clarity.ai:27017,int.mongodb-02.pre.clarity.ai:27017,int.mongodb-03.pre.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/?replicaSet=${replica_set} --authenticationDatabase=${auth_db} --username=${user}"
      ;;

    prod)
      hosts="int.mongodb-01.prod.clarity.ai:27017,int.mongodb-02.prod.clarity.ai:27017,int.mongodb-03.prod.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/?replicaSet=${replica_set} --authenticationDatabase=${auth_db} --username=${user}"
      ;;

    *) return 1
      ;;
  esac

  echo ${mongodb_uri}

  return 0
}


##
# Handles the 1Password signin
clarity::op_signin() {
  [[ -s "${HOME}/.1password" ]] || return 1

  eval $(cat "${HOME}/.1password"|${OP} signin --account=clarity.1password.com 2>/dev/null)
}


clarity::vpn_password() {
  local vpn_password=""
  local vpn_totp=""

  [[ -z "${OP_SESSION_clarity}" ]] && clarity::op_signin

  vpn_password="$(${OP} get item 'Clarity VPN' 2>/dev/null|jq -r '.details.fields[1].value')"
  vpn_totp="$(${OP} get totp 'Clarity VPN' 2>/dev/null)"
  #
  # if [ -d "${HOME}/.openvpn" ]; then
  #   echo -e "javier.juarez\n${vpn_password}${vpn_totp}" >"${HOME}/.openvpn/credentials"
  #   chmod 0600 "${HOME}/.openvpn/credentials"
  # fi
  #
  echo -e "${vpn_password}${vpn_totp}"
}


##
# ::alias:
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias klc='clarity::k8s_load_configs'
alias ksw='clarity::k8s_switch'
alias awscc='clarity::aws_clean_credentials'

# Sites
alias _aws='open_command https://console.aws.amazon.com/console/home'
alias _runbooks='open_command https://gitlab.clarity.ai/documentation/runbooks'
alias _handbooks='open_command https://gitlab.clarity.ai/documentation/handbooks'

