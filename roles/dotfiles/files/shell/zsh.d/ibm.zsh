set -o pipefail

#
# Switches
#
[[ -z "${DEFAULT_IKSCC_FEATURE}" ]] && declare -r DEFAULT_IKSCC_FEATURE="true"
IKSCC_FEATURE=${IKSCC_FEATURE:-${DEFAULT_IKSCC_FEATURE}}

[[ -z "${DEFAULT_OPENSHIFT_USE_LINK}" ]] && declare -r DEFAULT_OPENSHIFT_USE_LINK="true"
OPENSHIFT_USE_LINK=${OPENSHIFT_USE_LINK:-${DEFAULT_OPENSHIFT_USE_LINK}}

#
# General utilities
#
utils::panic() {
  local -r message="${1}"
  local -r exit_code="${2}"

  [[ -n "${message}" ]] && echo "${message}"
  return "${exit_code}"
}

#
# Configurations
#
[[ -s "${HOME}/.env.IBM.Cloud.account.ids" ]] || utils::panic "Warning: I couldn't load the IBMCloud accound ids from: ${HOME}/.env.IBM.Cloud.account.ids" 1
source "${HOME}/.env.IBM.Cloud.account.ids"

[[ -s "${HOME}/.env.IBM.Cloud.clusters"    ]] || utils::panic "Warning: I couldn't load the IBMCloud cluster list from: ${HOME}/.env.IBM.Cloud.clusters" 2
source "${HOME}/.env.IBM.Cloud.clusters"

#
# Tools
#
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)
TEMPD=$(mktemp -d)


ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  "${IBMCLOUD_CLI}" login --no-region --sso -c "${QCMASTER_IBMCLOUD_ID}"
}

ibm::cloud::switch_account() {
  local -r account_name="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  case "${account_name}" in
       stg|staging) [[ -n "${QCSTAGING_IBMCLOUD_ID}"    ]] && "${IBMCLOUD_CLI}" target -c "${QCSTAGING_IBMCLOUD_ID}" -q >/dev/null 2>&1 ;;
    pro|production) [[ -n "${QCPRODUCTION_IBMCLOUD_ID}" ]] && "${IBMCLOUD_CLI}" target -c "${QCPRODUCTION_IBMCLOUD_ID}" -q >/dev/null 2>&1 ;;
            master) [[ -n "${QCMASTER_IBMCLOUD_ID}"     ]] && "${IBMCLOUD_CLI}" target -c "${QCMASTER_IBMCLOUD_ID}" -q >/dev/null 2>&1 ;;  # By default go to the QCMaster account
                 *) utils::panic "The valid account names are: str, pro, master" 6
  esac
}

ibm::k8s::_update_cluster() {
  local -r cluster_name=${1}

  if [[ -z "${IBMCLOUD_CLUSTERS[$cluster_name]}" ]]; then
    utils::panic "Unkown cluster: ${cluster_name}" 5
  else
    local account=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $2 }')
    local command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q"

    ibm::cloud::switch_account "${account}"

    echo "Cluster: ${cluster_name} (${account},${kind})... "
    case ${kind} in
      openshift)
        if [[ "${OPENSHIFT_USE_LINK}" == "true" ]]; then
          command+=" --endpoint link"
        fi
        command+=" --admin"
        ;;
    esac

    case "${IKSCC_FEATURE}" in
      true)
        if [[ -x "${IKSCC}" ]]; then
          eval "${command}"|${IKSCC} -f ->! "${HOME}/.kube/${cluster}.yml"
        else
          echo "Warning: No ${IKSCC} tool installed"
        fi
        ;;
      *)
        eval "${command}" >! "${HOME}/.kube/${cluster}.yml"
        ;;
    esac
  fi
}

ibm::k8s::update() {
  local -r cluster_name=${1}

  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  if [[ -n "${cluster_name}" ]]; then
    ibm::k8s::_update_cluster ${cluster_name}
  else
    for cluster in ${(k)IBMCLOUD_CLUSTERS}; do
      ibm::k8s::_update_cluster ${cluster}
    done
  fi
}

ibm::k8s::list() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  for cluster data in ${(kv)IBMCLOUD_CLUSTERS}; do
    local account=$(echo ${data}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${data}|awk -F"|" '{ print $2 }')

    echo "Cluster: ${cluster}, account: ${account}(${IBMCLOUD_ACCOUNTS_IDS[${account}]}), type: ${kind}"
  done
}


# autoloads
autoload ibm:cloud::login
autoload ibm:cloud::switch_account
autoload ibm::k8s::update
autoload ibm::k8s::list


# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibmcloud logout'
alias ic.t='ibmcloud target'
alias ic.sa='ibm::cloud::switch_account'
