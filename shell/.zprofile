echo ">>> .zprofile"

[[ -s "${HOME}/.rvm/scripts/rvm" ]] && {

  source "${HOME}/.rvm/scripts/rvm"
  PATH=${HOME}/.rvm/bin:${PATH}
}
