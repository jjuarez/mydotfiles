#!/usr/bin/env bash

declare -r WORKSPACE="${HOME}/Workspace/ibm/quantum/projects/infra"

REPOSITORIES=(
  cloud-deployment
  ops-datacenter
  cloud-helm-charts
  gitops-application-deployments
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

  [ ! -d "${repository}" ] && echo .git || git rev-parse --git-dir > /dev/null 2>&1
}

command::do_update() {
  local -r repository=${1}
  local repository_dir="${WORKSPACE}/${repository}"
  local default_branch

  if util::is_git "${repository_dir}"; then
    pushd "${repository_dir}" || util::die "Error: I couldn't jump into the directory: ${repository_dir}" 1
    default_branch=$(git branch --remote --list '*/HEAD' | awk -F/ '{ print $NF }')
    # git::refresh
    git switch "${default_branch}"
    git fetch --append --prune
    git pull origin "${default_branch}"
    git-delete-merged-branches
    git-delete-squashed-branches
    git switch -
    popd || util::die "Error: I couldn't get out the directory: ${repository_dir}" 2
    return 0
  else 
    return 1
  fi
}

#
# ::main::
#
for repository in "${REPOSITORIES[@]}"; do
  command::do_update "${repository}"
done
