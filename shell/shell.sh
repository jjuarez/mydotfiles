# vi: ft=sh

##
# User specific profiles
for p in ${MYDOTFILES}/shell/profiles.d/*.profile; do 
  source ${p}
done 2>/dev/null

##
# Set of alias
[[ -f "${MYDOTFILES}/shell/aliases" ]] && source "${MYDOTFILES}/shell/aliases"

##
# General User environment
export EDITOR='vim'
export PAGER='most'
