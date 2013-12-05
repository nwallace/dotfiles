#!/bin/bash

main() {
  initial_dir=`pwd`
  cd ~
  if [ ! -d .ssh ]; then
    ssh-keygen
  fi
  setup_oh-my-zsh
  setup_vim
  setup_dotfiles
  cd $initial_dir
}

setup_oh-my-zsh() {
  git clone git@github.com:robbyrussell/oh-my-zsh.git .oh-my-zsh
}

setup_vim() {
  mkdir -p .vim/bundle .vim/autoload .tmp
  curl -Sso .vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  git clone git@github.com:kien/ctrlp.vim.git .vim/bundle/ctrlp
  git clone git@github.com:SirVer/ultisnips.git .vim/bundle/ultisnips
  git clone git@github.com:tpope/vim-rails.git .vim/bundle/vim-rails
}

setup_dotfiles() {
  mkdir projects
  git clone git@github.com:nwallace/dotfiles projects/dotfiles
  ln -sf `pwd`/projects/dotfiles/.vimrc .vimrc
  ln -sf `pwd`/projects/dotfiles/.zshrc .zshrc
  ln -sf `pwd`/projects/dotfiles/.gitconfig .gitconfig
  ln -sf `pwd`/projects/dotfiles/nathan.zsh-theme .oh-my-zsh/themes
}

main

