#!/usr/bin/env bash

declare -r WORKSPACE="${HOME}/Workspace"
declare -r DESTINATION_DIRECTORY="${HOME}/Dropbox/Backups/IBM"
declare BACKUP_DRYRUN

TAR="$(brew --prefix)/bin/gtar"
DATE=$(date +"%Y-%m-%d-%H:%M")
BACKUP_DIRECTORIES=(
  codelytv
  ibm
  src
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

command::do_backup( ) {
  local -r directory=${1}
  local complete_directory="${WORKSPACE}/${directory}"
  local tar_file_name="/tmp/${directory//\//-}-${DATE}.tgz"

  if [[ -d "${complete_directory}" ]]; then
    if [[ "${BACKUP_DRYRUN}" = "true" ]]; then
      util::console "[dry-run] Backing up: ${complete_directory}"
    else
      util::console "Backing up: ${complete_directory}"
      "${TAR}" -czf "${tar_file_name}" \
         --exclude='.DS_Store' \
         --exclude='.terraform' --exclude='.terragrunt-cache' \
         --exclude='vendor' \
         --exclude='pkg/mod' \
         --exclude='node_modules' \
         --exclude='.gradle' --exclude='*.class' --exclude='*.jar' \
         --exclude='*.csv' \
         --exclude='.code' --exclude='.vscode' --exclude='.idea' --exclude='.swp' \
         --exclude='.po' --exclude='.pc' --exclude='.pco' --exclude='__pycache__' \
         --exclude='rishavc-roberta-base.tar.gz' \
         -C "${complete_directory}" . && \
      cp -a "${tar_file_name}" "${DESTINATION_DIRECTORY}/" &&
      rm -f "${tar_file_name}"
    fi
  fi
}

#
# ::main::
#
[[ -x "${TAR}" ]] || util::die "This scrip needs GNU tar executable" 1

BACKUP_DRYRUN=${BACKUP_DRYRUN:-'false'}

for directory in "${BACKUP_DIRECTORIES[@]}"; do
  command::do_backup "${directory}"
done
