#!/bin/sh
pushd ~
if [ $IS_DOCKER_LOCAL == "1" ]; then
    ln -s ~/dotfiles/dotbash_profile .bashrc
    ln -s ~/dotfiles/dotnav.docker .nav
else
    ln -s ~/dotfiles/dotbashrc .bashrc
    ln -s ~/dotfiles/dotbash_profile .bash_profile
    ln -s ~/dotfiles/dotnav .nav
fi

ln -s ~/dotfiles/bash_completions .bash_completions
ln -s ~/dotfiles/dotaliases .aliases
ln -s ~/dotfiles/dotvimrc .vimrc
ln -s ~/dotfiles/dotirbrc .irbrc
ln -s ~/dotfiles/git-completion.bash .git-completion.bash

touch ~/dotfiles/dotprivate
ln -s ~/dotfiles/dotprivate .private

ln -s dotfiles/ps1_functions .ps1_functions
ln -s dotfiles/dotvpn .vpn
popd
