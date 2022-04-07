#set -u -o pipefail
#set -x


python::clean() {
  find . -type f -iname "*.py[co]" -delete
  find . -type d -iname "__pycache__" -delete
}

python::venv::activate() {
  local venv_directory="./venv"

  [[ -d ./.venv ]] && venv_directory="./.venv"
  deactivate &>/dev/null; source "${venv_directory}/bin/activate"
}

# autoloads
autoload python::clean

# aliases
alias pyclean='python::clean'
alias ae='python::venv::activate'
alias de='deactivate'
