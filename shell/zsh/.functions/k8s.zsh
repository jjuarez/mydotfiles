BREW_PREFIX=$(brew --prefix)

[[ -x "${BREW_PREFIX}/bin/kubectx" ]] && alias kx='kubectx'
[[ -x "${BREW_PREFIX}/bin/kubens"  ]] && alias nx='kubens'
