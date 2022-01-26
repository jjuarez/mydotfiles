HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

# autoloads

# aliases
alias jsontidy='pbpaste|jq '.'|pbcopy'

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl"   ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubecolor" ]] && alias k='kubecolor' # Override
