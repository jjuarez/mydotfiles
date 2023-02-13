set -o pipefail
#set -x


python::clean() {
  find . -type f -iname "*.py[co]" -delete
  find . -type d -iname "__pycache__" -delete
}

python::venv::activate() {
  local -r default_venv_directory="venv"
  local venv_directory="./venv"

  if [[ -d "./.venv" ]]; then
    deactivate >/dev/null 2>&1
    source ./.venv/bin/activate
  elif [[ -d "./venv" ]]; then
    deactivate >/dev/null 2>&1
    source "${venv_directory}/bin/activate"
  fi
}

# autoloads
autoload python::clean
autoload python::venv::active

# aliases
alias pyclean='python::clean'
alias pyae='python::venv::activate'
alias pyde='deactivate'
alias ae='python::venv::activate'
alias de='deactivate'
