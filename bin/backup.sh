#!/usr/bin/env bash

declare -r TAR="gtar" # GNU tar installed by home brew
declare -r DATE_FORMAT="%Y%m%d%H%M"
declare -r WORKSPACE="${HOME}/workspace"
declare -r DESTINATION_DIRECTORY="${HOME}/Dropbox/Backups/Clarity"

DATE=$(date +${DATE_FORMAT})
DIRECTORIES=(go src linuxacademy clarity/infrastructure clarity/documentation clarity/lab clarity/product)


command::do_backup( ) {
  local directory=${1}
  local complete_directory="${WORKSPACE}/${directory}"
  local tar_file_name="/tmp/${directory//\//-}-${DATE}.tar.gz"

  [[ -d "${complete_directory}" ]] && \
    ${TAR} -czvf ${tar_file_name} --exclude='.git' --exclude='.DS_Store' --exclude='.terraform' --exclude='.terragrunt-cache' --exclude='vendor' --exclude='node_modules' --exclude='.gradle' --exclude='*.class' --exclude='*.jar' --exclude='*.csv' --exclude='.code' --exclude='.idea' -C "${complete_directory}" . && \
    cp "${tar_file_name}" "${DESTINATION_DIRECTORY}/" && \
    rm -f "${tar_file_name}"
}


#
# ::main::
#
for d in "${DIRECTORIES[@]}"; do
  command::do_backup "${d}"
done