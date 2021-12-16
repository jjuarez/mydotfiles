HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$(brew --prefix)}

utils::multi_source() {
  local -r files="${@}"

  for f in $(echo ${files}|tr ' ' '\n'); do
    [[ -f "${f}" ]] && source "${f}"
  done
}

# autoloads
autoload utils::multi_source

# aliases
alias msource='utils::multi_source'
alias jsontidy='pbpaste|jq '.'|pbcopy'

[[ -x "${HOMEBREW_PREFIX}/bin/kubectl"   ]] && alias k='kubectl'
[[ -x "${HOMEBREW_PREFIX}/bin/kubecolor" ]] && alias k='kubecolor' # Override
