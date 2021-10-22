#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
KUBECONFIG_FILTER_TOOL=$(command -v ikscc 2>/dev/null)

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}"            ]] || return 1
  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 2
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 3
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 4

  ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q >/dev/null 2>&1
}

ibm::cloud::logout() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} logout -q >/dev/null 2>&1
}

ibm::cloud::target() {
  local -r resource_group="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  if [[ -n "${resource_group}" ]]; then
    ${IBMCLOUD_CLI} target -g "${resource_group}" -q 
  else
    echo -e "You shoud specify a valid resource gruoup..."
    ${IBMCLOUD_CLI} resource groups
  fi
}

ibm::k8s::ksconfig() {
  local cluster_name="${1}"
  local filter=${2:-'yes'}

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -n "${cluster_name}" ]] || return 5

  echo "Updating ${cluster_name}..."
  if [[ "${filter}" == "yes" && -x "${KUBECONFIG_FILTER_TOOL}" ]]; then
    ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" --output yaml -q | ${KUBECONFIG_FILTER_TOOL} -f - >! "${HOME}/.kube/${cluster_name}.yml" || return 7
  else
    ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" --output yaml -q >! "${HOME}/.kube/${cluster_name}.yml" || return 7
  fi
}

ibm::k8s::ksconfig_openshift() {
  local cluster_name="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -n "${cluster_name}" ]] || return 5

  echo "Updating ${cluster_name}..."
  ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" --admin --output yaml -q >! "${HOME}/.kube/${cluster_name}.yml" || return 7
}

ibm::k8s::ksconfig_all() {
  ibm::cloud::target "Clusters Non-Prod" >/dev/null
  ibm::k8s::ksconfig "apis-dev"
  ibm::cloud::target "Experimental" >/dev/null
  ibm::k8s::ksconfig "experimental-us"
  ibm::cloud::target "IBM Satellite Clusters Non-Prod" >/dev/null
  ibm::k8s::ksconfig_openshift "quantum-dc-ny-dev"
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::cloud::target
autoload ibm::k8s::ksconfig
autoload ibm::k8s::ksconfig_all

# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibm::cloud::logout'
alias ic.t='ibm::cloud::target'
