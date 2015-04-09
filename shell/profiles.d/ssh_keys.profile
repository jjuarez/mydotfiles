##
# Load all ssh keys deployed in the user home directory
for k in $(find ${HOME}/.ssh -type f -name "id_*.pub" -prune -o -name "id_*" -print); do

  echo "Adding SSH key: ${k}"
  /usr/bin/ssh-add ${k}
done
