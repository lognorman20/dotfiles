# ls when changing directories
chpwd() ls
export CLICOLOR=1

# vim mode in terminal
bindkey -v
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# aliases

## general
alias b="cd ../"
alias bb="cd ../.."

## git
alias gs='git status'
alias gl='git log --graph --oneline --decorate --color'
alias gco='git checkout'

# searching previous commands
bindkey '^R' history-incremental-search-backward
source <(fzf --zsh)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

setopt prompt_subst

git_branch_prompt() {
  local branchName

  branchName="$(git branch --show-current 2>/dev/null)"

  if [[ -n "$branchName" ]]; then
    echo "(${branchName}) "
  fi
}

PROMPT='%F{yellow}$(git_branch_prompt)%f%F{green}%n@%m%f %F{cyan}%1~%f %% '
