#
# Optional Features
#
ft::direnv() {
  [[ -x "$(brew --prefix)/bin/direnv" ]] && eval "$(direnv hook zsh)"
}

ft::krew() {
  [[ -d "${HOME}/.krew" ]] && export PATH="${HOME}/.krew/bin:${PATH}"
}

ft::tf() {
  if command -v tfenv 1>/dev/null 2>&1; then
    export PATH="${HOME}/.tfenv/bin:${PATH}"
  fi
}

ft::python() {
  export CFLAGS="-O2 -I$(brew --prefix openssl)/include"
  export LDFLAGS="-L$(brew --prefix openssl)/lib"

  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
}

ft::ruby() {
  if command -v rbenv 1>/dev/null 2>&1; then
    eval "$(rbenv init -)"
  fi
}

ft::java() {
  if command -v sdk 1>/dev/null 2>&1; then
    [[ -d "${HOME}/.sdkman" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
  fi
}

ft::go() {
  [[ -s "${HOME}/.gorc" ]] && source "${HOME}/.gorc"
}

ft::github() {
  [[ -d "${HOME}/.githubrc" ]] && source "${HOME}/.githubrc"
}

ft::travis() {
  [[ -d "${HOME}/.travis/travis.sh" ]] && source "${HOME}/.travis/travis.sh"
}

#
# ::main::
#
echo -en "Activating toggles: "
for feature activated in ${(kv)FTS}; do
  if [ "${activated}" = true ]; then
    echo -en "${feature} "
    ft::${feature}
  fi
done
echo -en "\n"