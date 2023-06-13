#!/bin/bash
# • fzf - a rust fuzzy finder
# • bfg - fuzzy finder
LOCAL=$HOME/.local
LOCAL_JAR=$LOCAL/jar

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
# install minikube
if [ -z $(which minikube) ]; then
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64
fi
# install kubectl
if [ -z $(which kubectl) ]; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install kubectl /usr/local/bin/kubectl
fi
# install helm
if [ -z $(which helm) ]; then
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
fi
# install zsh
if [ -z $(which zsh) ]; then
  sudo apt-get update -y
  sudo apt-get install zsh -y
fi
# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
  cp ./zsh/.zshrc ~/.zshrc
fi

if [ ! -f $LOCAL_JAR/bfg.jar ]; then
  curl https://repo1.maven.org/maven2/com/madgag/bfg/1.9.0/bfg-1.9.0.jar --output $LOCAL_JAR/bfg.jar
  echo "alias bfg='java -jar ${LOCAL_JAR}/bfg.jar'\n" >> $HOME/.zshrc
fi
  




exit 0