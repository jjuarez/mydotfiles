#set -u -o pipefail
#set -x


BROWSER=${BROWSER:-'Firefox'}
GIT_ORG=${GIT_ORG:-'IBM-Q-Software'}
GIT_REPO=${GIT_REPO:-'cloud-deployment'}


github::open_issue() {
  local -r git_issues="https://github.ibm.com/${GIT_ORG}/${GIT_REPO}/issues"
  local -r issue="${1}"

  [[ -n "${issue}" ]] || return 0
  case "${OSTYPE}" in
    darwin*) open -a "${BROWSER}" "${git_issues}/${issue}" ;;
          *) echo "There's no support for ${OSTYPE} yet..." ;;
  esac
}

# autoloads
autoload github::open_issue

# aliases
alias goi='github::open_issue'
