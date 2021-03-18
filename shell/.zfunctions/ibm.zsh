#set -u -o pipefail
#set -x
IBMCLOUD_CLI=$(command -v ibmcloud 2>/dev/null)

ibm::cloud::login() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 1
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 1

  ${IBMCLOUD_CLI} login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q &&
  export IBMCLOUD_SESSION_ACTIVE='true'
}

ibm::cloud::logout() {
  [[ -x "${IBMCLOUD_CLI}" ]] || return 1

  ${IBMCLOUD_CLI} logout -q
}

# ::alias::
alias ic='ibmcloud'
alias icli='ibm::cloud::login'
alias iclo='ibm::cloud::logout'
alias ict='ibmcloud target'
