BREW_PREFIX=$(brew --prefix)

[[ -x "${BREW_PREFIX}/bin/kubectl" ]] && alias k='kubectl'
[[ -x "${BREW_PREFIX}/bin/kubectx" ]] && alias kx='kubectx'
[[ -x "${BREW_PREFIX}/bin/kubens"  ]] && alias kn='kubens'
