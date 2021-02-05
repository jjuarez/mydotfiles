#set -u -o pipefail
#set -x

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl" ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubecolor" ]] && alias k='kubecolor'

[[ -x "${HOMEBREW_PREFIX}/bin/kubie" ]] && alias kb='kubie'
[[ -x "${HOMEBREW_PREFIX}/bin/kubectx" ]] && alias kx='kubectx'
[[ -x "${HOMEBREW_PREFIX}/bin/kubens" ]] && alias kn='kubens'

k8s::backup_kubeconfig() {
  local -r date_format="%s"
  local -r kube_config="${HOME}/.kube/config"

  [[ -s "${kube_config}" ]] || return 0

  cp -f "${kube_config}" "${kube_config}.$(date +${date_format})"
}

k8s::get_all_kubeconfigs() {
  local -r cluster_ids=$(ibmcloud ks cluster ls --json|jq '.[] | .name'|sed -e 's/\"//g')

  [[ "${IBMCLOUD_SESSION_ACTIVE}" == "false" ]] || return 1

  for ci in ${cluster_ids}; do
    ibmcloud ks cluster config --cluster ${ci} -q &&
    cp -f "${HOME}/.kube/config" "${HOME}/.kube/${ci}.yaml"
  done
}

k8s::get_kubeconfig() {
  local cluster_id="${1}"

  [[ -n "${cluster_id}" ]] || return 1

  k8s::backup_kubeconfig
  ibmcloud ks cluster config --cluster "${cluster_id}" -q
  [[ -s "${HOME}/.kube/config" ]] && cp -f "${HOME}/.kube/config" "${HOME}/.kube/${cluster_id}.yaml"
}

