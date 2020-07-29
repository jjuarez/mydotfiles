#set -u -o pipefail
#set -x

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl" ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubectx" ]] && alias kx='kubectx'
[[ -x "${HOMEBREW_PREFIX}/bin/kubens"  ]] && alias kn='kubens'


iks::get_kubeconfigs() {
  local -r cluster_ids=$(ibmcloud ks cluster ls --json|jq '.[] | .name'|sed -e 's/\"//g')

  [[ -n "${IBMCLOUD_API_KEY}" ]] || return 1

  for ci in ${cluster_ids}; do
    ibmcloud ks cluster config --cluster ${ci}
  done
}


k8s::load_kubeconfigs() {
  local -r kubeconfig_dir="${1:-${HOME}/.kube}"
  local kubeconfig_files=$(find ${HOME}/.kube -type f -name "*.config.yml" -o -name "config")

  [[ -n "${kubeconfig_files}" ]] || return 1

  export KUBECONFIG_SAVE=${KUBECONFIG}
  export KUBECONFIG=$(echo ${kubeconfig_files}|tr '\n' ':')

  return 0
}


k8s::restore_kubeconfig() {
  [[ -n "${KUBECONFIG_SAVE}" ]] || return 1

  export KUBECONFIG=${KUBECONFIG_SAVE}
  unset KUBECONFIG_SAVE

  return 0
}
