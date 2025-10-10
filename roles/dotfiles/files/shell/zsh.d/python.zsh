set -o pipefail
#set -x


python::venv::activate() {
  if [[ -d "./.venv" ]]; then
    deactivate >/dev/null 2>&1
    source ./.venv/bin/activate
    return 0
  elif [[ -d "./venv" ]]; then
    deactivate >/dev/null 2>&1
    source "./venv/bin/activate"
    return 0
  fi

  return 1
}

# autoloads
autoload python::venv::active

# aliases
alias pyae='python::venv::activate'
alias pyde='deactivate'
