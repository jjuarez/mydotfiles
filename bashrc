##
# General environment
PS1='\u@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;33m\]$(/usr/bin/vcprompt)\[\033[00m\]$ '

##
# bash history
export HISTTIMEFORMAT="$(hostname -s) %h/%d %H:%M:%S "
export HISTSIZE=2048

##
# Set of alias
for a in ${MYDOTFILES}/bash/alias.d/*.alias; do
  source ${a}
done 2>/dev/null

##
# Completions
for c in ${MYDOTFILES}/bash/completion.d/*.completion; do
  source ${c}
done 2>/dev/null

##
# User specific profiles
for p in ${MYDOTFILES}/bash/profile.d/*.profile; do 
  source ${p}
done 2>/dev/null

## 
# Command warppers
for c in ${MYDOTFILES}/bash/command.d/*.command; do
  source ${c}
done 2>/dev/null

##
# Other subsystems....
[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm
