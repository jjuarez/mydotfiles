# vi: set ft=zsh :
declare -A K8S_ENVIRONMENTS=(
  [dev]=x
  [pre]=x
  [prod]=x
)

declare CORP="clarity"
declare WORKSPACE="${HOME}/workspace/${CORP}"

[[ -d "${WORKSPACE}" ]] || return 1

declare -A directories
directories[infra]="${WORKSPACE}/devops/infrastructure"
directories[cm]="${WORKSPACE}/devops/cm/ansible"
directories[tf]="${WORKSPACE}/devops/infrastructure/terraform"
directories[product]="${WORKSPACE}/product"
directories[front]="${WORKSPACE}/product/frontend"
directories[back]="${WORKSPACE}/product/backend"

# Configuration
DNS=${DNS:-'clarity.ai'}
HELM_ROOT="${HOME}/.helm"

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
# Shortcut
clarity::shortcut() {
  local dir=${1}

  [[ -d "${directories[$dir]}" ]] && cd "${directories[$dir]}"
}

##
# Kubernetes
clarity::valid_environment() {
  local environment=${1}

  [[ -n "${K8S_ENVIRONMENTS[$environment]}" ]]
}

clarity::context() {
  local environment=${1}
  local namespace=${2}

  ${KCTX} ${environment}.${DNS} 2>&1 >/dev/null
  ${KNS} ${namespace} 2>&1 >/dev/null
}

clarity::kops() {
  local environment=${1}

  export KOPS_STATE_STORE="s3://kubernetes.${environment}.${DNS}"
}

clarity::helm() {
  local environment=${1}

  [[ -d "${HELM_ROOT}/clusters/${environment}.${DNS}" ]] || return 2

  export HELM_HOME="${HELM_ROOT}/clusters/${environment}.${DNS}"
}

clarity::test_cluster() {
  local test=${1}

  [[ "${test}" == "test" ]] && {
    echo "\nKubectl version:"
    ${KCTL} cluster-info

    echo "\nCustom namespaces:"
    ${KCTL} get namespaces --no-headers | grep -vE '(default|ingress|kube\-*)'

    echo "\nKops cluster:"
    ${KOPS} get cluster

    echo "\nHelm version:"
    ${HELM} version --tls
  }
}

# ::main::
clarity::k8s_load_configs() {
  local new_kubeconfig=""

  [[ -d "${HOME}/.kube" ]] || return 1

  new_kubeconfig=$(find ${HOME}/.kube -type f -iname "*config" -print|tr '\n' ':'|sed -e 's/:$//g')

  [[ -n "${new_kubeconfig}" ]] || return 1

  export KUBECONFIG="${new_kubeconfig}"
}

clarity::k8s_switch() {
  local environment=${1:-dev}
  local namespace=${2:-clarity}
  local test=${3:-nope_thanks}

  if clarity::valid_environment ${environment}; then
    clarity::context ${environment} ${namespace}
    clarity::kops ${environment}
    clarity::helm ${environment}
    clarity::test_cluster ${test}
  else
    return 1
  fi
}

##
# Issues
clarity::open_issue() {
  local issue_id=${1}
  local url=${2:-'https://gitlab.clarity.ai/infrastructure/ops/issues'}

  echo "Issue id: ${issue_id}"
  echo "URL: ${url}"

  if [[ ${issue_id} =~ '^[0-9]+$' ]]; then
    echo "Go to to issue: ${issue_id}..."
    open_command "${url}/${issue_id}"
  else
    (>&2 echo "Error: No issue id")
    open_command "${url}"
  fi
}

##
# Convert the AWS name of the host to a useful IP address
clarity::aws2ip() {
  local aws_internal_name="${1}"
  local aws_internal_ip_address=""

  [[ -n "${aws_internal_name}" ]] || return 1

  aws_internal_ip_address=$(echo -n "${aws_internal_name}"|cut -d"." -f1)
  echo -n "${aws_internal_ip_address}"|sed -e 's/^ip\-//g'|sed -e 's/\-/\./g'
}

##
# Builds the MongoDB URI
clarity::mongodb_uri() {
  local environment=${1:-'dev'}
  local user=${2:-'admin'}
  local replica_set=${3:-'rs0'}
  local auth_db=${4:-'admin'}
  local hosts=""
  local mongodb_uri=""

  case ${environment} in
    dev|development)
      hosts="int.mongodb-01.dev.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/ --authenticationDatabase=${auth_db} --username=${user}"
      ;;
    pre|preproduction|staging)
      hosts="int.mongodb-01.pre.clarity.ai:27017,int.mongodb-02.pre.clarity.ai:27017,int.mongodb-03.pre.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/?replicaSet=${replica_set} --authenticationDatabase=${auth_db} --username=${user}"
      ;;
    pro|prod|production)
      hosts="int.mongodb-01.prod.clarity.ai:27017,int.mongodb-02.prod.clarity.ai:27017,int.mongodb-03.prod.clarity.ai:27017"
      mongodb_uri="mongodb://${hosts}/?replicaSet=${replica_set} --authenticationDatabase=${auth_db} --username=${user}"
      ;;
    *) return 1 ;;
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

##
# Gather the VPN password with OTP
clarity::vpn_password() {
  local vpn_password=""
  local vpn_totp=""

  [[ -z "${OP_SESSION_clarity}" ]] && clarity::op_signin
  [[ -z "${OP_SESSION_clarity}" ]] && return 1

  vpn_password="$(${OP} get item 'Clarity VPN' 2>/dev/null|jq -r '.details.fields[1].value')"
  vpn_totp="$(${OP} get totp 'Clarity VPN' 2>/dev/null)"

  if [ -d "${HOME}/.openvpn" ]; then
    echo -e "javier.juarez\n${vpn_password}${vpn_totp}" >"${HOME}/.openvpn/credentials"
    chmod 0600 "${HOME}/.openvpn/credentials"
  fi

  echo -e "${vpn_password}${vpn_totp}"
}


##
# ::alias:
alias kx='kubectx'
alias kn='kubens'
alias klc='clarity::k8s_load_configs'
alias ksw='clarity::k8s_switch'
alias ipa='clarity::aws2ip'
# Shortcuts
alias _infra='clarity::shortcut infra'
alias _cm='clarity::shortcut cm'
alias _tf='clarity::shortcut tf'
alias _product='clarity::shortcut product'
alias _front='clarity::shortcut front'
alias _back='clarity::shortcut back'
# Sites
alias _issue='clarity::open_issue' ${@}
alias _aws='open_command https://console.aws.amazon.com/console/home'
alias _calendar='open_command https://calendar.google.com'
alias _docs='open_command https://gitlab.clarity.ai/documentation'
alias _runbooks='open_command https://gitlab.clarity.ai/documentation/runbooks'
alias _handbooks='open_command https://gitlab.clarity.ai/documentation/handbooks'

