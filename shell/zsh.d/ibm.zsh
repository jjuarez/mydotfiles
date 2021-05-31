#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)

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
     ${IBMCLOUD_CLI} target -q
  fi
}

ibm::k8s::list() {
  local -r resource_group="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} ks cluster ls -q 2>/dev/null
}

ibm::k8s::update_kubeconfig() {
  local cluster_name="${1}"

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -n "${cluster_name}" ]] || return 5

  BLUEMIX_CS_TIMEOUT=300 ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" --output yaml -q >! "${HOME}/.kube/${cluster_name}.yml" &&
  echo "${cluster_name} updated!"
}

ibm::k8s::update_kubeconfig_fzf() {
  [[ -x "${IBMCLOUD_CLI}"            ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 4

  ${IBMCLOUD_CLI} ks cluster ls -q|grep ${IBMCLOUD_RESOURCE_GROUP}|awk '/./ { print $1 }'|fzf|xargs -I % sh -c 'ibmcloud ks cluster config --cluster % --output yaml -q >${HOME}/.kube/%.yml'
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::cloud::target
autoload ibm::k8s::list
autoload ibm::k8s::update_kubeconfig
autoload ibm::k8s::update_kubeconfig_fzf

# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibm::cloud::logout'
alias ic.t='ibm::cloud::target'
alias ic.kls='ibm::k8s::list'
alias ic.kku='ibm::k8s::update_kubeconfig'
alias ic.kkui='ibm::k8s::update_kubeconfig_fzf'
