#set -u -o pipefail
#set -x
declare QAPI_BRANCHES=(master testing staging production)


git::qapi_update() {
  git fetch --all --prune

  for branch in "${QAPI_BRANCHES[@]}"; do
    git checkout ${branch} &&
    git pull origin ${branch}
  done
}

# ::alias::
