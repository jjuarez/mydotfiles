#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 2
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 3
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

ibm::k8s::update_kubeconfig() {
  local cluster_name="${1}"
  local resource_group="${2:-'Clusters Non-Prod'}"

  [[ -x "${IBMCLOUD_CLI}"   ]] || return 1
  [[ -n "${cluster_name}"   ]] || return 4

  ${IBMCLOUD_CLI} target -g "${resource_group}" -q >/dev/null 2>&1 &&
  ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" -q &&
    cp -f "${HOME}/.kube/config" "${HOME}/.kube/${cluster_name}.yml" &&
    rm -f "${HOME}/.kube/config" &&
    echo -e "${cluster_name} kubeconfig updated!"
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::k8s::ls
autoload ibm::k8s::update_kubeconfig

# aliases
alias ic='ibmcloud'
alias icli='ibm::cloud::login'
alias iclo='ibm::cloud::logout'
alias ict='ibmcloud target'
alias kls='ibm::k8s::ls'
alias kku='ibm::k8s::update_kubeconfig'
