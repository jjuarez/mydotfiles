#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)

[[ -n "${DEFAULT_IBMCLOUD_DEBUG}"  ]] && readonly DEFAULT_IBMCLOUD_DEBUG="false"

typeset -A IBM_CLUSTERS
IBM_CLUSTERS[apis-dev]="Clusters Non-Prod|iks"
IBM_CLUSTERS[apis-dev-de]="Clusters Non-Prod - DE|iks"
IBM_CLUSTERS[apis-prod]="Clusters|iks"
IBM_CLUSTERS[apis-prod-de]="Clusters - DE|iks"
IBM_CLUSTERS[apps-staging-us]="Clusters Non-Prod|iks"
IBM_CLUSTERS[apps-prod-us]="Clusters|iks"
IBM_CLUSTERS[quantum-dc-ny-dev]="IBM Satellite Clusters Non-Prod|openshift"
IBM_CLUSTERS[sat-pok-qnet-staging]="IBM Satellite Clusters Non-Prod|openshift"
IBM_CLUSTERS[sat-pok-qnet-prod]="IBM Satellite Clusters|openshift"
IBM_CLUSTERS[experimental-us]="Experimental|iks"
IBM_CLUSTERS[dev-forum-22-tekton]="Support Services|openshift"


ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}"            ]] || return 1
  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 2
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 3
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 4

  case "${IBMCLOUD_DEBUG}" in
    true) ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" ;;
       *) ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q >/dev/null 2>&1 ;;
  esac
}

ibm::cloud::logout() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} logout -q >/dev/null 2>&1
}

ibm::cloud::target() {
  local -r resource_group="${1}"
  local -r region="${2:-${DEFAULT_IBMCLOUD_REGION}}"

  [[ -x "${IBMCLOUD_CLI}"   ]] || return 1

  case "${IBMCLOUD_DEBUG}" in
    true) [[ -n "${resource_group}" ]] && ${IBMCLOUD_CLI} target -g "${resource_group}" -r "${region}" || ${IBMCLOUD_CLI} target ;;
       *) [[ -n "${resource_group}" ]] && ${IBMCLOUD_CLI} target -g "${resource_group}" -r "${region}" -q >/dev/null || ${IBMCLOUD_CLI} target ;;
  esac
}

ibm::cloud::target_clean() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  ${IBMCLOUD_CLI} target -r '' -g '' -q >/dev/null
}

ibm::k8s::ksconfig() {
  local -r cluster_name="${1}"
  local -r kind="${2}"

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -x "${IKSCC}"        ]] || return 1
  [[ -n "${cluster_name}" ]] || return 5

  case ${kind} in
    openshift) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q --admin | ${IKSCC} -f - >! "${HOME}/.kube/${cluster_name}.yml" || return 7 ;;
          iks) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster_name} --output yaml -q | ${IKSCC} -f - >! "${HOME}/.kube/${cluster_name}.yml" || return 7 ;;
            *) echo "Unknown cluster kind: ${kind}"; return 8  ;;
  esac
}

ibm::k8s::update() {
  ibm::cloud::target_clean

  for cluster data in ${(kv)IBM_CLUSTERS}; do
    local resource_group=$(echo ${data}|awk -F"|" '{ print $1 }')
    local kind=$(echo ${data}|awk -F"|" '{ print $2 }')

    echo "Cluster=${cluster}, kind=${kind}, rg='${resource_group}'"
    ibm::k8s::ksconfig ${cluster} ${kind}
  done
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::cloud::target
autoload ibm::cloud::target_clean
autoload ibm::k8s::update

# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibm::cloud::logout'
alias ic.t='ibm::cloud::target'
alias ic.tc='ibm::cloud::target_clean'
alias ic.ks.up='ibm::k8s::update'
