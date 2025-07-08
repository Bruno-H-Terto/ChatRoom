# bin/sh -e
export DC="docker compose"
alias dcb="$DC build"
alias dcu="$DC up"
alias dcd="$DC down"
alias dce="$DC exec app bundle exec"

dcclean(){
  docker stop $(docker ps -aq)
  docker rmi -f $(docker images -aq)
  docker volume rm $(docker volume ls -qf dangling=true)
}
