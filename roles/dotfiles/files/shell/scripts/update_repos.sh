#!/usr/bin/env bash

set -eu -o pipefail

declare -r WORKSPACE="${HOME}/Workspace/ibm/quantum/projects/infra"

REPOSITORIES=(
  cloud-deployment
  ops-datacenter
  cloud-helm-charts
  gitops-application-deployments
  utility-dockerfiles
)


util::console() {
  local message="${1}"

  [[ -n "${message}" ]] && echo -e "${message}"
}

util::die() {
  local message="${1}"
  local exit_code="${2:-0}"

  util::console "${message}"
  exit "${exit_code}"
}

util::is_git() {
  local -r repository="${1}"
  local result

  if [[ -d "${repository}" ]]; then
    # shellcheck disable=SC2164
    pushd "${repository}" > /dev/null
    result="$(git rev-parse --git-dir 2> /dev/null)"
    # shellcheck disable=SC2164
    popd > /dev/null

    [[ "${result}" == ".git" ]] && return 0
  fi

  return 1
}

command::do_update() {
  local -r repository=${1}
  local repository_dir="${WORKSPACE}/${repository}"
  local default_branch

  if util::is_git "${repository_dir}"; then
    util::console "Refreshing the ${repository} repository..."
    pushd "${repository_dir}" > /dev/null || util::die "Error: I couldn't jump into the directory: ${repository_dir}" 1
    default_branch=$(git branch --remote --list '*/HEAD'|awk -F"/" '{ print $NF }')
    git switch --quiet "${default_branch}"
    git fetch --quiet --append --prune
    git pull --quiet origin "${default_branch}"
    git-delete-merged-branches
    git-delete-squashed-branches
    git switch --quiet -
    popd || util::die "Error: I couldn't get out the directory: ${repository_dir}" 2
    return 0
  else
    util::console "This directory seems like not a git repository" 3
    return 1
  fi
}

#
# ::main::
#
for repository in "${REPOSITORIES[@]}"; do
  command::do_update "${repository}"
done
