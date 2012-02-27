# vim:sh

##
# User specific profiles
for prfl in ${MYDOTFILES}/shell/profile.d/*.profile; do 
  . ${prfl}
done 2>/dev/null

##
# Set of alias
[ -f "${MYDOTFILES}/shell/aliases" ] && . ${MYDOTFILES}/shell/aliases

##
# General User environment
export EDITOR='vim -N'
export PAGER=most
