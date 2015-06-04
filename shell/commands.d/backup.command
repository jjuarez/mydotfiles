##
# Tartify the parameter directory
backup-that( ) {

  local target=${1}
  local date_format="%Y%m%d%H%M"
  local backup_pattern="backup-`date +${date_format}`"
 
  [ -f "${target}" ] && cp    "${target1}" "${target1}-${backup_pattern}"

  [ -d "${target}" ] && cp -r "${target1}" "${target1}-${backup_pattern}"
}
