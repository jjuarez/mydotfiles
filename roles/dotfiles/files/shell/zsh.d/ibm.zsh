set -o pipefail
#set -x

IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)

TEMPD=$(mktemp -d)

typeset -A IBM_CLUSTERS=(
# Quantum Master (dev)
  [apis-dev]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apis-dev-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [sat-ykt-openq-dev]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
# Quantum Master (staging)
  [apps-staging-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apps-staging-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-staging]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [sat-pok-qnet-staging]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [processing-staging-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
# Quantum Master (production)
  [apis-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apps-prod-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [apis-prod-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [processing-production-de]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
  [sat-pok-qnet-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [sat-shinkawasaki-sk-prod]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
# Quantum Master (cross)
  [cicd-production]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
  [experimental-us]="3f0eacee15cc4551a4b51313a4a1f2d2|iks"
# [cicd-tools]="3f0eacee15cc4551a4b51313a4a1f2d2|openshift"
# Quantum Services (production)
  [sat-ccf-prod]="b947c1c5e9344d64aed96696e4d76e0e|openshift"
  # Quantum Services (staging)
  [qc-apis-staging-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|iks"
  [qc-apis-testing-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|iks"
  [qc-pok-qnet-staging]="f3e7d1b7a7044d7abf45f5be9821782a|openshift"
  [qc-simulators-staging-us-east]="f3e7d1b7a7044d7abf45f5be9821782a|openshift"
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

ibm::k8s::save_configuration() {
  local -r cluster="${1}"
  local -r command="${2}"
  local local_file=""

  [[ -n "${cluster}" ]] || return 2
  [[ -n "${command}" ]] || return 2

  local_file="${TEMPD}/${cluster}.yml"

  if [[ -x "${IKSCC}" ]]; then
    # Cleanup
    eval "${command}" 2>/dev/null | ${IKSCC} -f - >! "${local_file}"
  else
    eval "${command}" 2>/dev/null >! "${local_file}"
  fi

  echo "saving: ${HOME}/.kube/${cluster}.yml"
  cp -f "${local_file}" "${HOME}/.kube/${cluster}.yml" &&
  rm -f "${local_file}"
}

ibm::k8s::update() {
  local current_account=""

  # set -x
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} target -g '' -r '' -q >/dev/null 2>&1

  for cluster data in ${(kv)IBM_CLUSTERS}; do
    local account=$(echo ${data}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${data}|awk -F"|" '{ print $2 }')
    local command=""

    if [[ -z "${current_account}" ]]; then
      ibm::cloud::switch_account "${account}" &&
      current_account="${account}"
    elif [[ "${current_account}" != "${account}" ]]; then
      ibm::cloud::switch_account "${account}" &&
      current_account="${account}"
    fi

    echo -n "Cluster: ${cluster} (${account},${kind})... "
    case ${kind} in
      openshift) command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q --admin --endpoint link" ;;
            iks) command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q" ;;
              *) echo "Unknown type of cluster" ;;
    esac
    ibm::k8s::save_configuration "${cluster}" "${command}"
  done
  # set +x
}

# autoloads
autoload ibm::cloud::switch_account

# aliases
alias ic='ibmcloud'
alias ic.sa='ibm::cloud::switch_account'
