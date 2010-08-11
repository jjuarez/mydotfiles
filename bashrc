##
# Set of alias
for a in ~/etc/mydotfiles/bash/alias.d/*.alias; do
  . ${a}
done

##
# Completions
for c in ~/etc/mydotfiles/bash/completion.d/*.completion; do
  . ${c}
done

##
# User specific profiles
for p in ~/etc/mydotfiles/bash/profile.d/*.profile; do 
  . ${p}
done

##
# Other subsystems....
[ -s ~/.rvm/scripts/rvm ] && . ~/.rvm/scripts/rvm

