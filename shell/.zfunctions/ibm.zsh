#set -u -o pipefail
#set -x
declare -r DEFAULT_IBMCLOUD_ENDPOINT="cloud.ibm.com"

IBMCLOUD_ENDPOINT="${IBMCLOUD_ENDOPOINT:-${DEFAULT_IBMCLOUD_ENDPOINT}}"

ibm::cloud::login() {
  [[ -n "${IBMCLOUD_API_KEY}"        ]] || return 1
  [[ -n "${IBMCLOUD_REGION}"         ]] || return 1
  [[ -n "${IBMCLOUD_RESOURCE_GROUP}" ]] || return 1

 #ibmcloud login -a ${IBMCLOUD_ENDPOINT_DEFAULT} -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}"
  ibmcloud login -r ${IBMCLOUD_REGION} -g "${IBMCLOUD_RESOURCE_GROUP}"
}

# ::alias::
alias ic='ibmcloud'
alias icl='ibm::cloud::login'
