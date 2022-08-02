#set -u -o pipefail
#set -x

# IBMCLOUD_DEBUG="true"
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)
IKSCC=$(command -v ikscc 2>/dev/null)

typeset -A IBM_CLUSTERS
IBM_CLUSTERS[apis-dev]="Clusters Non-Prod|iks"
IBM_CLUSTERS[apis-prod]="Clusters|iks"
IBM_CLUSTERS[apps-prod-us]="Clusters|iks"
IBM_CLUSTERS[apps-staging-us]="Clusters Non-Prod|iks"
IBM_CLUSTERS[experimental-us]="Experimental|iks"
IBM_CLUSTERS[quantum-dc-ny-dev]="IBM Satellite Clusters Non-Prod|openshift"
IBM_CLUSTERS[sat-pok-qnet-prod]="IBM Satellite Clusters|openshift"
IBM_CLUSTERS[sat-pok-qnet-staging]="IBM Satellite Clusters Non-Prod|openshift"
#IBM_CLUSTERS[cicd-production]="Infrastructure Core|openshift"


ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}"     ]] || return 1
  [[ -n "${IBMCLOUD_API_KEY}" ]] || return 2
  [[ -n "${IBMCLOUD_REGION}"  ]] || IBMCLOUD_REGION='us-south'

  case "${IBMCLOUD_DEBUG}" in
    true) ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} ;;
       *) ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -q >/dev/null 2>&1 ;;
  esac
}

ibm::cloud::logout() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  case "${IBMCLOUD_DEBUG}" in
    true) ${IBMCLOUD_CLI} logout ;;
       *) ${IBMCLOUD_CLI} logout -q >/dev/null 2>&1 ;;
  esac
}

ibm::cloud::target() {
  local -r resource_group=${1:-''}
  local -r region=${2:-''}

  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  case "${IBMCLOUD_DEBUG}" in
    true) ${IBMCLOUD_CLI} target -g "${resource_group}" -r "${region}" ;;
       *) ${IBMCLOUD_CLI} target -g "${resource_group}" -r "${region}" -q >/dev/null ;;
  esac
}

ibm::k8s::update() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1
  [[ -x "${IKSCC}"        ]] || return 1

  ${IBMCLOUD_CLI} target -r '' -g '' -q >/dev/null
  echo "Loading cluster configs..."
  for cluster data in ${(kv)IBM_CLUSTERS}; do
    local kind=$(echo ${data}|awk -F"|" '{ print $2 }')

    echo "${kind}: ${cluster}"
    case ${kind} in
      openshift) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q --admin | ${IKSCC} -f - >! "${HOME}/.kube/${cluster}.yml" || return 7 ;;
            iks) ${IBMCLOUD_CLI} ks cluster config --cluster ${cluster} --output yaml -q | ${IKSCC} -f - >! "${HOME}/.kube/${cluster}.yml" || return 7 ;;
              *) return 8 ;;
    esac
  done
}

# autoloads
autoload ibm::cloud::login
autoload ibm::cloud::logout
autoload ibm::cloud::target
autoload ibm::k8s::update

# aliases
alias ic='ibmcloud'
alias ic.li='ibm::cloud::login'
alias ic.lo='ibm::cloud::logout'
alias ic.t='ibm::cloud::target'
alias ic.ks.up='ibm::k8s::update'
