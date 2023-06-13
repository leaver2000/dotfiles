#!/bin/bash
# • fzf - a rust fuzzy finder
# • bfg - fuzzy finder
OH_MY_ZSH=$HOME/.oh-my-zsh
ZSH_RC=$HOME/.zshrc
THE_DIR=$HOME/.local
JAR_DIR=$THE_DIR/jar
BIN_DIR=$THE_DIR/bin
#
JQ_PATH=$BIN_DIR/jq
BFG_PATH=$JAR_DIR/bfg.jar
# helper functions
function echo_info(){ echo "[info] - $*"; }
function echo_skip(){ echo "[skip] - $*"; }
function echo_exit(){ echo "[exit] - $*"; }
# error handling
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo_exit ${last_command} command filed with exit code $?.' EXIT
# • install zsh
if [ -z $(which zsh) ]; then
  sudo apt-get update -y
  sudo apt-get install zsh -y
fi
# • install oh-my-zsh
if [ ! -d $OH_MY_ZSH ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
  cp ./zsh/.zshrc $ZSH_RC
fi
# • install minikube
if [ -z $(which minikube) ]; then
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64
fi
# • install kubectl
if [ -z $(which kubectl) ]; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install kubectl /usr/local/bin/kubectl
fi
# • install helm
if [ -z $(which helm) ]; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 --output get_helm.sh 
  chmod 700 get_helm.sh
  ./get_helm.sh
fi
# • bfg is a simpler, faster alternative to git-filter-branch for cleansing bad data out of your Git repository history
if [ ! -f $BFG_PATH ]; then
  curl https://repo1.maven.org/maven2/com/madgag/bfg/1.9.0/bfg-1.9.0.jar --output $BFG_PATH
  echo "alias bfg='java -jar ${BFG_PATH}'\n" >> $HOME/.zshrc
fi
# • jq is a lightweight and flexible command-line JSON processor.
if [ ! -f $JQ_PATH ]; then
  echo 🚀 jq not found installing
  curl -L https://github.com/jqlang/jq/releases/download/jq-1.6/jq-linux64 --output $JQ_PATH
  chmod +x $JQ_PATH
fi

exit 0