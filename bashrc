##
# General environment
PS1="\h@\u:\W $(vcprompt)"

##
# Set of alias
for my_alias in ~/etc/mydotfiles/bash/alias.d/*.alias; do

  source ${my_alias}
done 2>/dev/null

##
# Completions
for my_completion in ~/etc/mydotfiles/bash/completion.d/*.completion; do

  source ${my_completion}
done 2>/dev/null

##
# User specific profiles
for my_profile in ~/etc/mydotfiles/bash/profile.d/*.profile; do 

  source ${my_profile}
done 2>/dev/null

## 
# Command warppers
for my_command in ~/etc/mydotfiles/bash/command.d/*.command; do

  source ${my_command}
done 2>/dev/null

##
# Other subsystems....
[ -s ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm

