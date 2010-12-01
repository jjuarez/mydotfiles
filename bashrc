##
# General environment
PS1='\h@\u:\W $(vcprompt)'

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
[ -s ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm
