#set -u -o pipefail
#set -x

HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl"   ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubecolor" ]] && alias k='kubecolor'