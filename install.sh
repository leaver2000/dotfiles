#! /bin/bash
# sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
sudo apt-get update -y
sudo apt-get install zsh -y
# update to python 3.10
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get install python3.10 -y
sudo apt-get install python3.10-venv -y
# create a virtual venv
python3.10 -m venv ~/.venv
export PATH="${HOME}/.venv/bin:${PATH}"