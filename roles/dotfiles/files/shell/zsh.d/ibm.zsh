#
# Configurations
#
ACCOUNTS_CONFIG_FILE="${HOME}/.env.IBM.Cloud.account.ids"
CLUSTERS_CONFIG_FILE="${HOME}/.env.IBM.Cloud.clusters"

#
# Switches
#
IKSCC_FEATURE=${IKSCC_FEATURE:-"true"}
OPENSHIFT_USE_LINK=${OPENSHIFT_USE_LINK:-"true"}

#
# Tools
#
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)
KUBIE=$(command -v kubie 2>/dev/null)
KUBECTL=$(command -v kubectl 2>/dev/null)

#
# General utilities
#
utils::panic() {
  local -r message="${1}"
  local -r exit_code="${2}"

  [[ -n "${message}" ]] && echo "${message}"
  return "${exit_code}"
}

utils::checks() {
  [[ -x "${IBMCLOUD_CLI}" ]] || utils::panic "There's no IBM Cloud CLI tool installed" 4
  [[ -x "${KUBIE}" ]]        || utils::panic "There's no kubie tool installed" 4
  [[ -x "${KUBECTL}" ]]      || utils::panic "There's no kubectl tool installed" 4
}

#
# Specific utilities
#
ibm::cloud::switch_account() {
  local -r account_name="${1}"

  utils::checks

  case "${account_name}" in
    qc-master|qs-staging|qs-prod|qc-experimental)
      if [[ -n "${IBMCLOUD_ACCOUNT_IDS[${account_name}]}" ]]; then
        "${IBMCLOUD_CLI}" target -c "${IBMCLOUD_ACCOUNT_IDS[${account_name}]}" --unset-resource-group --unset-region -q >/dev/null 2>&1  # By default go to the QCMaster account

        if [[ -n "${IBMCLOUD_SMES[${account_name}]}" ]]; then
          "${IBMCLOUD_CLI}" sm config set service-url "${IBMCLOUD_SMES[${account_name}]}" -q
        fi

        CURRENT_ACCOUNT="${account_name}"  # Track the active account so callers can avoid redundant switches
      fi
    ;;

    *)
      echo "Valid accounts are: qc-master, qs-staging, qs-prod, and qc-experimental..."
    ;;
  esac
}

ibm::cloud::login() {
  utils::checks

  # To take the advantage of automatic OTPs
  "${IBMCLOUD_CLI}" config --sso-otp auto

  "${IBMCLOUD_CLI}" login --no-region --sso -c "${QCMASTER_IBMCLOUD_ID}" -q >/dev/null 2>&1
  ibm::cloud::switch_account qc-master # To ensure that we're pointing to the right SM instance
}

ibm::cloud::resource_group_id() {
  local -r rg_name="${1}"

  utils::checks

  if [[ -n "${rg_name}" ]]; then
    ${IBMCLOUD_CLI} resource group "${rg_name}" --output=json | jq -r '.[0].id'
  fi
}

ibm::k8s::_update_cluster() {
  local -r cluster_name=${1}

  if [[ -z "${IBMCLOUD_CLUSTERS[$cluster_name]}" ]]; then
    utils::panic "Unknown cluster: '${cluster_name}'" 5
  else
    local -a parts=("${(@s:|:)IBMCLOUD_CLUSTERS[$cluster_name]}")
    local account="${parts[1]}"
    local kind="${parts[2]}"
    local endpoint_type="${parts[3]}"
    local command="${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q"
    local kubeconfig_filename="${HOME}/.kube/${cluster_name}.yml"

    if [[ "${CURRENT_ACCOUNT}" != "${account}" ]]; then
      ibm::cloud::switch_account "${account}"
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

    setopt local_options pipefail  # so a failing ibmcloud in the IKSCC pipe is detected

    local tmp
    tmp=$(mktemp "${HOME}/.kube/.${cluster_name}.XXXXXX") || { utils::panic "Couldn't create temp file for ${cluster_name}" 6; return; }

    case "${IKSCC_FEATURE}" in
      true)
        if [[ -x "${IKSCC}" ]]; then
          if eval "${command}" | "${IKSCC}" -f - >| "${tmp}"; then
            mv -f "${tmp}" "${kubeconfig_filename}"
          else
            rm -f "${tmp}"; utils::panic "Failed to update kubeconfig for ${cluster_name}" 7
          fi
        else
          rm -f "${tmp}"
        fi
      ;;

      *)
        if eval "${command}" >| "${tmp}" 2>/dev/null; then
          mv -f "${tmp}" "${kubeconfig_filename}"
        else
          rm -f "${tmp}"; utils::panic "Failed to update kubeconfig for ${cluster_name}" 7
        fi
      ;;
    esac
  fi
}

ibm::k8s::update() {
  local list_of_clusters="${@}"

  utils::checks

  if [[ -z "${list_of_clusters}" ]]; then
    list_of_clusters="${(k)IBMCLOUD_CLUSTERS}"
  fi

  for cluster in $(echo "${list_of_clusters}" | tr ' ' '\n'); do
    ibm::k8s::_update_cluster ${cluster}
  done
}

ibm::k8s::check() {
  utils::checks

  for context_file in $(find "${HOME}/.kube" -type f -iname "*.yml" -print); do
    context=$(basename -s .yml ${context_file})
    echo "Cluster: ${context}: $(${KUBIE} exec ${context} default ${KUBECTL} get --raw='/readyz' --request-timeout=5s)"
  done
}

ibm::k8s::wipeout() {
  [[ -d "${HOME}/.kube/cache"      ]] && rm -fr "${HOME}/.kube/cache"
  [[ -d "${HOME}/.kube/http-cache" ]] && rm -fr "${HOME}/.kube/http-cache"
  [[ -s "${HOME}/.kube/config"     ]] && rm -f "${HOME}/.kube/config"

  find "${HOME}/.kube" -type f -iname "*.yml" -delete
}


#
# ::main::
#

# Aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibmcloud logout'
alias ic.sa='ibm::cloud::switch_account'
alias ic.rgid='ibm::cloud::resource_group_id'

# Load configurations — must be sourced at top level so the `typeset -A`
# declarations in the config files land in global scope, not a function-local
# one (sourcing inside a function makes the arrays vanish when it returns).
for _cfg in "${CLUSTERS_CONFIG_FILE}" "${ACCOUNTS_CONFIG_FILE}"; do
  if [[ -s "${_cfg}" ]]; then
    source "${_cfg}"
  else
    echo "Warning: couldn't load IBM Cloud config from: ${_cfg}" >&2
  fi
done
unset _cfg
