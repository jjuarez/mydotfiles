##
# Tartify the parameter directory
backup-that(){

  local date_format="%Y%m%d%H%M"
  local backup_pattern="backup-`date +${date_format}`"
 
  [ -f "${1}" ] && cp "${1}" "${1}-${backup_pattern}"

  [ -d "${1}" ] && cp -r "${1}" "${1}-${backup_pattern}"
}
