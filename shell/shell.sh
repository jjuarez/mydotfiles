# vim:sh

##
# User specific profiles
for prfl in ${MYDOTFILES}/shell/profiles.d/*.profile; do 
  . ${prfl}
done 2>/dev/null


##
# User specific commands
for cmd in ${MYDOTFILES}/shell/commands.d/*.command; do
  . ${cmd}
done 2>/dev/null


##
# Set of alias
[ -f "${MYDOTFILES}/shell/aliases" ] && . ${MYDOTFILES}/shell/aliases


##
# General User environment
export EDITOR='vim'
export PAGER=most
