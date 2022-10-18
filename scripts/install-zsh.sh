#! /bin/bash


wget -O zsh.tar.xz https://sourceforge.net/projects/zsh/files/latest/download

mkdir zsh && unxz zsh.tar.xz && tar -xvf zsh.tar -C zsh --strip-components 1

cd zsh

./configure --prefix=$HOME

make

make install

# sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"