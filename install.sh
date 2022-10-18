#! /bin/bash
export PATH="${HOME}/venv/bin:${PATH}"
sudo apt-get update -y
sudo apt-get install zsh -y
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended