##
# Set of alias
for f in ~/etc/mydotfiles/bash/alias.d/*.alias; do
  . ${f}
done

##
# Completions
for f in ~/etc/mydotfiles/bash/completion.d/*.completion; do
  . ${f}
done

##
# User specific profiles
for f in ~/etc/mydotfiles/bash/profile.d/*.profile; do 
  . ${f}
done

##
# Other subsystems....
[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

