set -o pipefail

#
# Switches
#
IKSCC_FEATURE=${IKSCC_FEATURE:-"true"}
OPENSHIFT_USE_LINK=${OPENSHIFT_USE_LINK:-"true"}

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

[[ -s "${HOME}/.env.IBM.Cloud.account.sms" ]] || utils::panic "Warning: I couldn't load the IBMCloud Secret Manager endpoint list from: ${HOME}/.env.IBM.Cloud.account.sms" 3
source "${HOME}/.env.IBM.Cloud.account.sms"

#
# Tools
#
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)

#
# Status
#
CURRENT_ACCOUNT="none"


ibm::cloud::switch_account() {
  local -r account_name="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  case "${account_name}" in
    qcmaster)
      if [[ -n "${QCMASTER_IBMCLOUD_ID}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${QCMASTER_IBMCLOUD_ID}" -q >/dev/null 2>&1  # By default go to the QCMaster account
        export SECRETS_MANAGER_URL=${IBMCLOUD_SM_ENDPOINTS[qcmaster]}
      fi
      ;;

    qsstaging|staging)
      if [[ -n "${QCSTAGING_IBMCLOUD_ID}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${QCSTAGING_IBMCLOUD_ID}" -q >/dev/null 2>&1
        export SECRETS_MANAGER_URL=${IBMCLOUD_SM_ENDPOINTS[staging]}
      fi
      ;;

    qsproduction|production)
      if [[ -n "${QCPRODUCTION_IBMCLOUD_ID}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${QCPRODUCTION_IBMCLOUD_ID}" -q >/dev/null 2>&1
        export SECRETS_MANAGER_URL=${IBMCLOUD_SM_ENDPOINTS[production]}
      fi
      ;;

    experimental)
      if [[ -n "${QCEXPERIMENTAL_IBMCLOUD_ID}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${QCEXPERIMENTAL_IBMCLOUD_ID}" -q >/dev/null 2>&1
        export SECRETS_MANAGER_URL=${IBMCLOUD_SM_ENDPOINTS[experimental]}
      fi
      ;;

    *)
      echo "Valid accounts are: qcmaster, staging, producton, and experimental... switching by default to QCMaster"
      ibm::cloud::switch_account qcmaster
      ;;
  esac
}

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  "${IBMCLOUD_CLI}" login --no-region --sso -c "${QCMASTER_IBMCLOUD_ID}" &&
  ibm::cloud::switch_account qcmaster # To ensure that we're pointing to the right SM instance
}

ibm::k8s::_update_cluster() {
  local -r cluster_name=${1}

  if [[ -z "${IBMCLOUD_CLUSTERS[$cluster_name]}" ]]; then
    utils::panic "Unkown cluster: ${cluster_name}" 5
  else
    local account=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $2 }')
    local command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q"
    local kubeconfig_filename="${HOME}/.kube/${cluster_name}.yml"

    if [[ "${CURRENT_ACCOUNT}" != "${account}" ]]; then
      ibm::cloud::switch_account "${account}"
      CURRENT_ACCOUNT="${account}"
    fi

    echo "Cluster: ${cluster_name} (${account}:${kind})..."
    case ${kind} in
      openshift|ocp)
        if [[ "${OPENSHIFT_USE_LINK}" == "true" ]]; then
          command+=" --endpoint link"
        fi
        command+=" --admin"
      ;;
    esac

    case "${IKSCC_FEATURE}" in
      true)
        if [[ -x "${IKSCC}" ]]; then
          eval "${command}"|${IKSCC} -f - >! "${kubeconfig_filename}"
        else
          echo "Warning: No ${IKSCC} tool installed"
        fi
      ;;

      *)
        eval "${command}" >! "${kubeconfig_filename}"
      ;;
    esac
  fi
}

ibm::k8s::update() {
  local -r cluster_names="${@}"
  local cluster_list="${(k)IBMCLOUD_CLUSTERS}"

  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  if [[ -n "${cluster_names}" ]]; then
    cluster_list="${cluster_names}"
  fi

  for cluster in $(echo ${cluster_list} | tr ' ' '\n'); do
    ibm::k8s::_update_cluster ${cluster}
  done
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
