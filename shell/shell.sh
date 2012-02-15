# vim:sh

##
# User specific profiles
for p in ${MYDOTFILES}/shell/profile.d/*.profile; do 
  . ${p}
done 2>/dev/null

##
# Set of alias
[ -f "${MYDOTFILES}/shell/aliases" ] && {
  
  echo "Loading aliases..."
  . ${MYDOTFILES}/shell/aliases
}

##
# General User environment
export EDITOR='vim -N'
export PAGER=most

