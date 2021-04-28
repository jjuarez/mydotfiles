#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 1
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || echo -e "Warning: No IBMCloud resource group specified"

  ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q >/dev/null 2>&1
}

ibm::cloud::logout() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} logout -q >/dev/null 2>&1
}

ibm::k8s::ls() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} ks cluster ls -q 2>/dev/null
}

ibm::k8s::gakc() {
  local resource_group_id_prev=""

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  for cluster_info in $(${IBMCLOUD_CLI} ks cluster ls --output json -q|jq 'sort_by(.resourceGroup)'|jq '.[]|"\(.resourceGroup),\(.name)"'|tr -d '"'); do
    local resource_group_id=$(echo "${cluster_info}"|awk -F, '{ print $1 }')
    local cluster_name=$(echo "${cluster_info}"|awk -F, '{ print $2 }')

    if [ "${resource_group_id}" != "${resource_group_id_prev}" ]; then 
      ${IBMCLOUD_CLI} target -g "${resource_group_id}" -q >/dev/null 2>&1
      resource_group_id_prev="${resource_group_id}"
    fi

    ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" -q &&
      cp -f "${HOME}/.kube/config" "${HOME}/.kube/${cluster_name}.yml" &&
      rm -f "${HOME}/.kube/config" &&
      echo -e "Cluster configuration ${cluster_name} updated!"
  done
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::k8s::ls
autoload ibm::k8s::gakc

# ::aliases
alias ic='ibmcloud'
alias icli='ibm::cloud::login'
alias iclo='ibm::cloud::logout'
alias ict='ibmcloud target'
alias kls='ibm::k8s::ls'
