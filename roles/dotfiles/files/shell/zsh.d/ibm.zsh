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
    qc-master|qs-staging|qs-prod|qc-experimental)
      if [[ -n "${IBMCLOUD_ACCOUNT_IDS[${account_name}]}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${IBMCLOUD_ACCOUNT_IDS[${account_name}]}" --unset-resource-group --unset-region -q >/dev/null 2>&1  # By default go to the QCMaster account

        if [[ -n "${IBMCLOUD_SMES[${account_name}]}" ]]; then
          "${IBMCLOUD_CLI}" sm config set service-url "${IBMCLOUD_SMES[${account_name}]}" -q
        fi
      fi
    ;;

    *)
      echo "Valid accounts are: qc-master, qs-staging, qs-prod, and qc-experimental..."
    ;;
  esac
}

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no ${IBMCLOUD_CLI} installed" 4

  # To take the advantage of automatic OTPs
  "${IBMCLOUD_CLI}" config --sso-otp auto

  "${IBMCLOUD_CLI}" login --no-region --sso -c "${QCMASTER_IBMCLOUD_ID}" -q >/dev/null 2>&1
  ibm::cloud::switch_account qc-master # To ensure that we're pointing to the right SM instance
}

ibm::k8s::_update_cluster() {
  local -r cluster_name=${1}

  if [[ -z "${IBMCLOUD_CLUSTERS[$cluster_name]}" ]]; then
    utils::panic "Unkown cluster: ${cluster_name}" 5
  else
    local account=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $2 }')
    local endpoint_type=$(echo ${IBMCLOUD_CLUSTERS[$cluster_name]}|awk -F"|" '{ print $3 }')
    local command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q"
    local kubeconfig_filename="${HOME}/.kube/${cluster_name}.yml"

    if [[ "${CURRENT_ACCOUNT}" != "${account}" ]]; then
      ibm::cloud::switch_account "${account}"
      CURRENT_ACCOUNT="${account}"
    fi

    echo "Cluster: ${cluster_name} (${account}:${kind}:${endpoint_type})"
    case ${kind} in
      openshift|ocp)
        [[ "${OPENSHIFT_USE_LINK}" == "true" ]] && command+=" --endpoint link"
        command+=" --admin"
      ;;
    esac

    case ${endpoint_type} in
      private) command+=" --endpoint private" ;;
    esac

    case "${IKSCC_FEATURE}" in
      true)
        [[ -x "${IKSCC}" ]] && eval "${command}"|${IKSCC} -f - >! "${kubeconfig_filename}"
      ;;

      *)
        eval "${command}" >! "${kubeconfig_filename}" 2>/dev/null
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

ibm::cloud::rg_id() {
  local r rg_name="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's not ${IBMCLOUD_CLI} installed" 4

  if [[ -n "${rg_name}" ]]; then
    ${IBMCLOUD_CLI} resource group "${rg_name}" --output=json | jq -r '.[0].id'
  fi
}


# autoloads
autoload ibm:cloud::login
autoload ibm:cloud::switch_account
autoload ibm:cloud::rg_id
autoload ibm::k8s::update


# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibmcloud logout'
alias ic.sa='ibm::cloud::switch_account'
