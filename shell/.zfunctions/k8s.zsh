#set -u -o pipefail
#set -x

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl" ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubecolor" ]] && alias k='kubecolor'

[[ -x "${HOMEBREW_PREFIX}/bin/kubie" ]] && alias kb='kubie'


k8s::get_kubeconfig() {
  local cluster_id="${1}"

  [[ -n "${cluster_id}" ]] || return 1

  ibmcloud ks cluster config --cluster "${cluster_id}" -q
  [[ -s "${HOME}/.kube/config" ]] && cp -f "${HOME}/.kube/config" "${HOME}/.kube/${cluster_id}.yaml"
}

k8s::secret_encode() {
  local raw_secret="${1}"

  [[ -n "${raw_secret}" ]] || return 1

  echo -n "${raw_secret}"|base64|tee|pbcopy
}

alias k8sse='k8s::secret_encode' 
