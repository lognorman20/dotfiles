# ls when changing directories
chpwd() ls
export CLICOLOR=1

# vim mode in terminal
bindkey -v
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# searching previous commands
bindkey '^R' history-incremental-search-backward
source <(fzf --zsh)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

## git
alias ga='git add'
alias gc='git commit'
alias gac='git add . && git commit -m'
alias gs='git status'
alias gl='git log --graph --oneline --decorate --color'
alias gd='git diff'
alias gco='git checkout'
