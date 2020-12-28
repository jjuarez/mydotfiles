#set -u -o pipefail
#set -x
ibm::cloud::login() {
  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 1
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 1

  ibmcloud login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}" -q
}

# ::alias::
alias ic='ibmcloud'
alias icl='ibm::cloud::login'
alias ict='ibmcloud target'
