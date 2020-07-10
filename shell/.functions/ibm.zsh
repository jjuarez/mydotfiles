# vi: set ft=zsh :

# set -ux -o pipefail

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


ibm::ks::get_kubeconfigs() {
  local -r cluster_ids=$(ibmcloud ks cluster ls --json|jq '.[] | .name'|sed -e 's/\"//g')

  [[ -n "${IBMCLOUD_API_KEY}" ]] || return 1

  for ci in ${cluster_ids}; do
    ibmcloud ks cluster config --cluster ${ci}
  done
}


ibm::k8s::load_kubeconfigs() {
  local -r kubeconfig_dir="${1:-${HOME}/.kube}"
  local kubeconfig_files=$(find ${HOME}/.kube -type f -name "*.config" -o -name "config")

  [[ -n "${kubeconfig_files}" ]] || return 1

  export KUBECONFIG_SAVE=${KUBECONFIG}
  export KUBECONFIG=$(echo ${kubeconfig_files}|tr '\n' ':')

  return 0
}


ibm::k8s::restore_kubeconfig() {
  [[ -n "${KUBECONFIG_SAVE}" ]] || return 1

  export KUBECONFIG=${KUBECONFIG_SAVE}
  unset KUBECONFIG_SAVE

  return 0
}


# ::alias::
alias ic='ibmcloud'
alias w3i='ibm::w3i::password'
