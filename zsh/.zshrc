ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

plugins=(git zsh-syntax-highlighting lein bundler rake gem capistrano git-flow)

stty -ixon

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS="-RiMSx2FX" # search ignores case, long prompt, no wrap, tabstop 2, only page multi screen, don't clear on exit

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

source "$ZSH/oh-my-zsh.sh"

export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

if [ -f "$HOME/bin/setup" ]; then
  source "$HOME/bin/setup"
fi

if [ -f "$HOME/bin/functions" ]; then
  source "$HOME/bin/functions"
fi

# start SSH agent, add default ID
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent` > /dev/null
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add > /dev/null

if [ -d /usr/share/chruby ]; then
  source /usr/share/chruby/chruby.sh
  source /usr/share/chruby/auto.sh
fi

if [ -d "$HOME/.rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

if [ -d "$HOME/.kiex" ]; then
  source "$HOME/.kiex/scripts/kiex"
fi

# enable termite to open new shells with ctrl+shift+t
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7 2>/dev/null
fi

which exa 2>&1 > /dev/null && alias ls=exa

alias please='sudo $(fc -ln -1)'
alias git='nocorrect git'
alias g='nocorrect git'
alias v="$EDITOR"
if [[ "$EDITOR" == nvim ]]; then
  alias view="$EDITOR -R"
fi
alias e="emacs"
alias rails='nocorrect rails'
alias tma='tmux attach'
alias ping-g='ping -c1 www.google.com'
alias be='bundle exec'
alias rake='bundle exec rake'
alias eclj="$EDITOR -Oc 'map ,t :w\|:!lein exec \$(ls *_test.clj)<cr>' *.clj"
alias dc='docker-compose'
alias urlencode='python2 -c "import urllib, sys; print urllib.quote_plus(  sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1], \"\")"'
alias urldecode='python2 -c "import urllib, sys; print urllib.unquote_plus(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read()[0:-1])"'
