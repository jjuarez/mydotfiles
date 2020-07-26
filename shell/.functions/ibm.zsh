#set -u -o pipefail
#set -x
declare -r IBMCLOUD_ENDPOINT_DEFAULT="cloud.ibm.com"
IBMCLOUD_SESSION="no"

# 1Password management
OP_CLI=$(which op 2>/dev/null)
OPASSWORD_IBM_DOMAIN="ibm"

ibm::w3i::password() {
  local password=""

  [[ -x "${OP_CLI}" ]] || return 1

  if [ -z "${OP_SESSION_ibm}" ]; then
    [[ -s "${HOME}/.1password" ]] || return 1
    eval $(cat "${HOME}/.1password"|${OP_CLI} signin --account=${OPASSWORD_IBM_DOMAIN} 2>/dev/null)
  fi

  password="$(${OP_CLI} get item 'IBM::w3id' 2>/dev/null|jq -r '.details.fields[1].value')"
  echo "${password}"

  return 0
}

ibm::cloud::login() {
  local -r region=${1:-"us-south"}
  local -r resource_group=${2:-"RIS2-ETX"}

  [[ -n "${IBMCLOUD_API_KEY}" ]] || return 1
  ibmcloud login -a ${IBMCLOUD_ENDPOINT_DEFAULT} -r ${region} -g ${resource_group} --quiet && export IBMCLOUD_SESSION="yes"
}

ibm::cloud::target() {
  local -r organization=${1:-"RIS2-ETX"}
  local -r space=${2:-"dev"}

  [[ "${IBMCLOUD_SESSION}" == "yes" ]] || return 1
  ibmcloud target -o ${organization} -s ${space} --quiet
}

# ::alias::
alias ic='ibmcloud'
alias w3i='ibm::w3i::password'
