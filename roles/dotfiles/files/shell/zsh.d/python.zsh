#set -u -o pipefail
#set -x


python::clean() {
  find . -type f -name "*.py[co]" -delete
  find . -type d -name "__pycache__" -delete
}

# autoloads
autoload python::clean

# aliases
alias pyclean='python::clean'
