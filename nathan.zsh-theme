autoload -U colors && colors

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
username() {
  echo $USERNAME | tr '[A-Z]' '[a-z]'
}
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%b%c%u%f]'
    } else {
        zstyle ':vcs_info:*' formats ' [%b%c%u%F{red}●%f]'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%{$fg[blue]%}$(username)%{$reset_color%}:%{$fg[green]%}%2~%{$reset_color%}${vcs_info_msg_0_} »%b '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
