#!/usr/bin/env bash

declare -r WORKSPACE="${HOME}/Workspace"
declare -r DESTINATION_DIRECTORY="${HOME}/Dropbox/Backups/IBM"
declare -r TAR="$(brew --prefix)/bin/gtar"

DATE=$(date +"%Y-%m-%d-%H:%M")
DIRECTORIES=(
  ibm/infrastructure
  ibm/projects
  ibm/src
  src
  go/src
  kike
  micifuz
  mundokids
)


command::do_backup( ) {
  local -r directory=${1}
  local complete_directory="${WORKSPACE}/${directory}"
  local tar_file_name="/tmp/${directory//\//-}-${DATE}.tgz"

  if [ -d "${complete_directory}" ]; then
    "${TAR}" -czf "${tar_file_name}" \
      --exclude='.DS_Store' \
      --exclude='.terraform' \
      --exclude='.terragrunt-cache' \
      --exclude='vendor' \
      --exclude='pkg/mod' \
      --exclude='node_modules' \
      --exclude='.gradle' --exclude='*.class' --exclude='*.jar' \
      --exclude='*.csv' \
      --exclude='.code' --exclude='.idea' \
      --exclude='.po' --exclude='.pc' --exclude='__pycache__' \
      -C "${complete_directory}" . && \
    cp -av "${tar_file_name}" "${DESTINATION_DIRECTORY}/" &&
    rm -f "${tar_file_name}"
  fi
}


# ::main::
[[ -x "${TAR}" ]] || exit 1

for d in "${DIRECTORIES[@]}"; do
  command::do_backup "${d}"
done
