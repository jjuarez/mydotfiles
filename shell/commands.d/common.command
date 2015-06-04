##
# Make a dir and change to it
mcd() { 

  local directory=${1}

  [ -d "${directory}" ] || exit 1 

  mkdir -p "${directory}" && cd "${directory}"
}

##
# Make an archive and deletes a folder
archive() {

  local directory=${1}

  [ -d "${directory}" ] || exit 1

  tar -czvf "${directory}"{.tar.gz,} && rm -fr "${directory}" &>/dev/null
}
