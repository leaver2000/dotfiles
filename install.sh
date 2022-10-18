#! /bin/bash
export PATH="${HOME}/venv/bin:${PATH}"
apt update -y
apt install zsh -y
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended