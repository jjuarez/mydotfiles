#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
KUBECONFIG_FILTER_TOOL=$(command -v ikscc 2>/dev/null)

typeset -A IBM_CLUSTERS_RESOURCEGROUP
IBM_CLUSTERS_RESOURCEGROUP[apis-dev]="Clusters Non-Prod|iks"
IBM_CLUSTERS_RESOURCEGROUP[experimental-us]="Experimental|iks"
IBM_CLUSTERS_RESOURCEGROUP[apis-prod]="Clusters|iks"
IBM_CLUSTERS_RESOURCEGROUP[quantum-dc-ny-dev]="IBM Satellite Clusters Non-Prod|openshift"
IBM_CLUSTERS_RESOURCEGROUP[sat-pok-qnet-prod]="IBM Satellite Clusters|openshift"


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
    echo -e "You shoud specify a valid resource group..."
    ${IBMCLOUD_CLI} resource groups
  fi
}

ibm::k8s::ksconfig_iks() {
  local cluster_name="${1}"
  local filter=${2:-'yes'}

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -n "${cluster_name}" ]] || return 5

  echo "Updating IKS cluster: ${cluster_name}..."
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

  echo "Updating OpenShift cluster: ${cluster_name}..."
  ${IBMCLOUD_CLI} ks cluster config --cluster "${cluster_name}" --admin --output yaml -q >! "${HOME}/.kube/${cluster_name}.yml" || return 7
}

ibm::k8s::ksconfig_all() {
  for cluster data in ${(kv)IBM_CLUSTERS_RESOURCEGROUP}; do
    local rg=$(echo $data|awk -F"|" '{ print $1 }')
    local kind=$(echo $data|awk -F"|" '{ print $2 }')

    ibm::cloud::target ${rg} >/dev/null

    case ${kind} in
      iks|openshift) ibm::k8s::ksconfig_${kind} ${cluster} ;;
      *) echo "Unknown k8s cluster type: ${kind}..." ;;
    esac
  done
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::cloud::target
autoload ibm::k8s::ksconfig_iks
autoload ibm::k8s::ksconfig_openshift
autoload ibm::k8s::ksconfig_all

# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibm::cloud::logout'
alias ic.t='ibm::cloud::target'
alias ic.ksall='ibm::k8s::ksconfig_all'
