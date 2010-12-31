#!/bin/sh
# This should be run from ~/.dotfiles. YOU fix the hardcodes if you don't like 'em.
cd
ln -s ~/.dotfiles/bash_completions .bash_completions
ln -s ~/.dotfiles/dotaliases .aliases
ln -s ~/.dotfiles/dotemacs.el .emacs
ln -s ~/.dotfiles/dotvimrc .vimrc
ln -s ~/.dotfiles/dotirbrc .irbrc
ln -s ~/.dotfiles/dotprofile .profile
ln -s ~/.dotfiles/git-completion.bash .git-completion.bash
ln -s ~/.dotfiles/dotprivate .private
ln -s ~/.dotfiles/dotnav .nav
cd ~/.dotfiles
