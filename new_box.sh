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
  mkdir -pv .vim/bundle .vim/autoload .tmp
  curl -Sso .vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
  git clone git@github.com:bling/vim-airline.git        .vim/bundle/airline
  git clone git@github.com:kchmck/vim-coffee-script.git .vim/bundle/coffee
  git clone git@github.com:kien/ctrlp.vim.git           .vim/bundle/ctrlp
  git clone git@github.com:tpope/vim-fugitive.git       .vim/bundle/fugitive
  git clone git@github.com:tpope/vim-rails.git          .vim/bundle/rails
  git clone git@github.com:SirVer/ultisnips.git         .vim/bundle/ultisnips
}

setup_dotfiles() {
  mkdir -v projects
  cur_dir="`pwd`"
  git clone git@github.com:nwallace/dotfiles projects/dotfiles
  ln -sf $cur_dir/projects/dotfiles/.vimrc           .vimrc
  ln -sf $cur_dir/projects/dotfiles/.vim/colors      .vim/colors
  ln -sf $cur_dir/projects/dotfiles/.zshrc           .zshrc
  ln -sf $cur_dir/projects/dotfiles/.gitconfig       .gitconfig
  ln -sf $cur_dir/projects/dotfiles/nathan.zsh-theme .oh-my-zsh/themes
  ln -sf $cur_dir/projects/dotfiles/UltiSnips        .vim/UltiSnips
}

main

