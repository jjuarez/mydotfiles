##
# Set of alias
for a in ~/etc/mydotfiles/bash/alias.d/*.alias; do

  source ${a}
done 2>/dev/null

##
# Completions
for c in ~/etc/mydotfiles/bash/completion.d/*.completion; do

  source ${c}
done 2>/dev/null

##
# User specific profiles
for p in ~/etc/mydotfiles/bash/profile.d/*.profile; do 

  source ${p}
done 2>/dev/null
