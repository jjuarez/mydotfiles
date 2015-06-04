# vi: ft=sh

##
# User specific profiles
for prfl in ${MYDOTFILES}/shell/profiles.d/*.profile; do 
  source ${prfl}
done 2>/dev/null

##
# Set of alias
[ -f "${MYDOTFILES}/shell/aliases" ] && source ${MYDOTFILES}/shell/aliases

##
# General User environment
export EDITOR='vim'
export PAGER='most'
