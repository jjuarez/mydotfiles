GIT_USER='git'
GIT_GROUP='scm'
GIT_SERVER='git.sistemas.sgai.csic.es'
REPO_BASE="~/repositories"


##
# Create several repostiories
__git_create_repo() {

  local repo_name=""

  [ -z "${1}" ] && {
    
    echo "repo name missing" >&2
    return 126
  } || {

    [[ `basename "${1}" .git` == "${1}" ]] && repo_name="${1}.git" || repo_name="${1}"

    echo "Creating remote repository: ${GIT_USER}@${GIT_SERVER}:${REPO_BASE}/${repo_name}...":
    ssh ${GIT_USER}@${GIT_SERVER} "mkdir ${REPO_BASE}/${repo_name} && git --bare init --shared ${REPO_BASE}/${repo_name}"
  }
}


##
# Gitfy the current directory
git-that() {

  local repo_name="${PWD##*/}.git"

  __git_create_repo "${repo_name}"
  
  git init . && 
  git add  . &&
  git commit -am "This is the first automated commit" &&
  git remote add origin ${GIT_USER}@${GIT_SERVER}:${REPO_BASE}/${repo_name} &&
  git tag __GIT_THIS_INIT__ &&
  git push --tags origin master
}

