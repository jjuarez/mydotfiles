# vim:sh

echo "shell.sh: BEGIN `date +%H%M%S`"

##
# User specific profiles
for p in ${MYDOTFILES}/shell/profile.d/*.profile; do 
  source ${p}
done 2>/dev/null

## 
# Command warppers
for c in ${MYDOTFILES}/shell/command.d/*.command; do
  source ${c}
done 2>/dev/null

##
# General environment
[ "${SHELL}" = "bash" ] && {

  PS1='\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$ '

  ##
  # bash history
  export HISTTIMEFORMAT="$(hostname -s) %h/%d %H:%M:%S "
  export HISTSIZE=2048
}

##
# Set of alias
[ -s "${MYDOTFILES}/shell/aliases" ] && source ${MYDOTFILES}/shell/aliases

##
# General User environment
export EDITOR='vim -N'
export PAGER=most


echo "shell.sh: END `date +%H%M%S`"
