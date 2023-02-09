set -o pipefail
#set -x

IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)

typeset -A IBM_ACCOUNTS=(
  ["qc-master"]="3f0eacee15cc4551a4b51313a4a1f2d2"
  ["qs-staging"]="f3e7d1b7a7044d7abf45f5be9821782a"
  ["qs-production"]="b947c1c5e9344d64aed96696e4d76e0e"
)
typeset -A IBM_CLUSTERS=(
# Quantum Master
  [apis-dev]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apis-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apis-dev-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apis-prod-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apps-staging-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apps-staging-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apps-prod-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-staging]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-staging-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-production-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [experimental-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [sat-ykt-openq-dev]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [sat-pok-qnet-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [sat-pok-qnet-staging]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [cicd-production]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [cicd-tools]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
# Quantum Services - staging
  [qc-apis-staging-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|iks"
  [qc-apis-testing-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|iks"
  [qc-pok-qnet-staging]="f3e7d1b7a7044d7abf45f5be9821782a|openshift"
  [qc-simulators-staging-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|openshift"
# Quantum Services - production
  [sat-ccf-prod]="b947c1c5e9344d64aed96696e4d76e0e|openshift"
)


ibm::cloud::switch_account() {
  local -r account_id="${1}"

  [[ -n "${account_id}" ]] || return 1
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  case ${IBMCLOUD_DEBUG} in
    true) ${IBMCLOUD_CLI} target -c "${account_id}" ;;
       *) ${IBMCLOUD_CLI} target -c "${account_id}" -q >/dev/null 2>&1 ;;
  esac
}

ibm::k8s::update() {
  local current_account=""

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -x "${IKSCC}" ]] || return 1

  ${IBMCLOUD_CLI} target -g '' -r '' -q >/dev/null 2>&1

  for cluster data in ${(kv)IBM_CLUSTERS}; do
    local account=$(echo ${data}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${data}|awk -F"|" '{ print $2 }')

    if [[ -z "${current_account}" ]]; then
      ibm::cloud::switch_account "${account}" &&
      current_account="${account}"
    elif [[ "${current_account}" != "${account}" ]]; then
      ibm::cloud::switch_account "${account}" &&
      current_account="${account}"
    fi

    echo "Cluster: ${cluster} (${account},${kind})"

    case ${kind} in
      openshift) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q --admin --endpoint link | ${IKSCC} -f - >! "${HOME}/.kube/${cluster}.yml" || return 3 ;;
            iks) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q | ${IKSCC} -f - >! "${HOME}/.kube/${cluster}.yml" || return 3 ;;
              *) return 4 ;;
    esac
  done
}

# autoloads
autoload ibm::cloud::switch_account

# aliases
alias ic='ibmcloud'
alias ic.sa='ibm::cloud::switch_account'
