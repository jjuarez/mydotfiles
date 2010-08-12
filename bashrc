##
# Set of alias
for f in ~/etc/mydotfiles/bash/alias.d/*.alias; do
  source ${f}
done

##
# Completions
for f in ~/etc/mydotfiles/bash/completion.d/*.completion; do
  source ${f}
done

##
# User specific profiles
for f in ~/etc/mydotfiles/bash/profile.d/*.profile; do 
  source ${f}
done

##
# Other subsystems....
[ -s ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm

