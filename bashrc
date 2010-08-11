##
# Prompt
PS1="$(/usr/bin/vcprompt)\u@\h|\W$"

##
# Set of alias
for a in ~/etc/dotfiles/bash/alias.d/*.alias; do

  source ${a}
done 2>/dev/null

##
# Completions
for c in ~/etc/dotfiles/bash/completion.d/*.completion; do

  source ${c}
done 2>/dev/null

##
# User specific profiles
for p in ~/etc/dotfiles/bash/profile.d/*.profile; do 

  source ${p}
done 2>/dev/null
