#set -u -o pipefail
#set -x

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
  local -r region="${1:-'us-south'}"
  local -r resource_group="${X:-'RIS2-ETX'}"

  [[ -n "${IBMCLOUD_API_KEY}" ]] || return 1
  ibmcloud login -r ${region} -g ${respource_group}
}



# ::alias::
alias ic='ibmcloud'
alias w3i='ibm::w3i::password'
