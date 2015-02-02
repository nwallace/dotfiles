ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

plugins=(git zsh-syntax-highlighting lein bundler rake gem capistrano brew git-flow aws)

stty -ixon

export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

source $ZSH/oh-my-zsh.sh
source $HOME/bin/setup
source $HOME/bin/functions

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS="-RiMSx2FX" # search ignores case, long prompt, no wrap, tabstop 2, only page multi screen, don't clear on exit

if [ -d /usr/share/chruby ]; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi

if [ -d $HOME/.rvm ]; then
  source $HOME/.rvm/scripts/rvm
  export PATH="$PATH:$HOME/.rvm/bin"
fi

alias git='nocorrect git'
alias v='vim'
alias rails='nocorrect rails'
alias tma='tmux attach'
alias ping-g='ping -c1 www.google.com'
alias be='bundle exec'
alias rake='bundle exec rake'
