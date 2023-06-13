
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=(
    git
    docker
    minikube
    kubectl
    helm
    zsh-autosuggestions
    zsh-syntax-highlighting
    web-search
)

source $ZSH/oh-my-zsh.sh
export PATH="$PATH:$HOME/.cargo/bin/"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zsh-reload="source ~/.zshrc"
alias images="\
docker images --format 'table {{.Repository}}\t{{.ID}}\t{{.Tag}}\t{{.Size}}' | (read -r; printf \"%s\n\" "$REPLY"; sort -h -k7)"
alias containers="\
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' | (read -r; printf \"%s\n\" "$REPLY"; sort -h -k7)"
alias docker-login="docker login ironbank.dso.mil"
alias venv-new="python -m venv .venv && source .venv/bin/activate"
# a function to remove a glob pattern of repo names
function docker-remove-repo() {
    docker rmi $(docker images | grep $1 | awk '{print $3}')
}
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source /home/leaver/.config/broot/launcher/bash/br

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias wsl="wsl.exe"
alias powershell="powershell.exe"
function code-find() {
    code $(fzf)
}

function ff(){
  name=$(
    find "$1" \
    -not -path "*/__pycache__/*" \code
    | fzf --preview "batcat --color=always {}"
  )
  if [ -f "$name" ]; then   # open the file in vscode
    code "$name"
  elif [ -d "$name" ]; then # recurse into the directory
    ff "$name"
  else                      # exit if not a file or directory
    printf "• 🤷‍♂️ exiting...\n"
  fi
}

function grl(){
  # git-revision list object size
  # script to sort blobs by object size
  git rev-list --objects --all \
  | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
  | sed -n 's/^blob //p' \
  | sort --numeric-sort --key=2 \
  | cut -c 1-12,41- \
  | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
  echo 🚀 git rev-list object size
}
