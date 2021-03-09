#set -u -o pipefail
#set -x
IBMCLOUD_SESSION_ACTIVE="${IBMCLOUD_SESSION_ACTIVE:-'false'}"

ibm::cloud::login() {
  local icCommandStatus=0

  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 1
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 1

  [[ "${IBMCLOUD_SESSION_ACTIVE}" == "true" ]] && {
    ibmcloud target
    return 0
  }

  ibmcloud login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q &&
  export IBMCLOUD_SESSION_ACTIVE="true"
}

ibm::cloud::logout() {
  [[ "${IBMCLOUD_SESSION_ACTIVE}" == "true" ]] || return 1
  ibmcloud logout -q &&
  export IBMCLOUD_SESSION_ACTIVE="false"
}

# ::alias::
alias ic='ibmcloud'
alias icli='ibm::cloud::login'
alias iclo='ibm::cloud::logout'
alias ict='ibmcloud target'
