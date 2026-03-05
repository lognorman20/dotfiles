## only run in interactive shells
case "$-" in
  *i*) ;;
  *) return ;;
esac

# vi mode
set -o vi

# ls when changing directories
cd() {
  builtin cd "$@" && ls
}

export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxegedabagaced

# use --color=auto for GNU ls (nix), fall back to -G for macOS ls
if ls --color=auto /dev/null >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

# colored prompt with git branch
__git_branch() {
  git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/ (&)/'
}
PS1='${IN_NIX_SHELL:+\[\e[0;35m\](nix)\[\e[0m\] }\[\e[0;32m\]\u@\h\[\e[0m\] \[\e[0;34m\]\W\[\e[0;33m\]$(__git_branch)\[\e[0m\] % '

# edit command line in $EDITOR
bind '"\C-x\C-e": edit-and-execute-command'
bind -m vi-command '"v": edit-and-execute-command'

# aliases

## general
alias b="cd ../"
alias bb="cd ../.."

## git
alias ga='git add'
alias gc='git commit'
alias gac='git add . && git commit -m'
alias gs='git status'
alias gl='git log --graph --oneline --decorate --color'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch -a'

## fact-machine-mono
alias fmreset='pnpm reset:all'
alias fmroot='cd ~/Documents/factmachine-monorepo'
alias fmsetup='pnpm dev:setup'
alias fmclean='pnpm clean:all'
alias fmdev='pnpm run dev'
alias fmbuild='pnpm build'
alias fmtest='pnpm test'

# aws
alias awsLogin='aws sso login --profile factmachine-devnet'

# sops
alias fmsops="/opt/homebrew/bin/sops"
alias fmworkerencrypt="fmsops -e gitops/clusters/factmachine-aws-devnet-us-east-2/dev/worker/worker-secrets.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/worker/worker-secrets.sops.yaml"
alias fmworkerdecrypt="fmsops -d gitops/clusters/factmachine-aws-devnet-us-east-2/dev/worker/worker-secrets.sops.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/worker/worker-secrets.yaml"
alias fmbackendencrypt="fmsops -e gitops/clusters/factmachine-aws-devnet-us-east-2/dev/backend/backend-secrets.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/backend/backend-secrets.sops.yaml"
alias fmbackenddecrypt="fmsops -d gitops/clusters/factmachine-aws-devnet-us-east-2/dev/backend/backend-secrets.sops.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/backend/backend-secrets.yaml"
alias fmadminbackendencrypt="fmsops -e gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin-backend/admin-backend-secrets.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin-backend/admin-backend-secrets.sops.yaml"
alias fmadminbackenddecrypt="fmsops -d gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin-backend/admin-backend-secrets.sops.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin-backend/admin-backend-secrets.yaml"
alias fmadminencrypt="fmsops -e gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin/admin-secrets.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin/admin-secrets.sops.yaml"
alias fmadmindecrypt="fmsops -d gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin/admin-secrets.sops.yaml > gitops/clusters/factmachine-aws-devnet-us-east-2/dev/admin/admin-secrets.yaml"
alias fmenv='eval "$(aws configure export-credentials --profile factmachine-devnet --format env)"'

# history
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
export HISTCONTROL="ignoredups:erasedups"

# keep history in sync across shells
__bash_history_sync() {
  history -a
  history -n
}
case "${PROMPT_COMMAND-}" in
  *__bash_history_sync*) ;;
  "") PROMPT_COMMAND="__bash_history_sync" ;;
  *) PROMPT_COMMAND="__bash_history_sync; ${PROMPT_COMMAND}" ;;
esac

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind -x '"\C-l": clear'

# fzf shell integration
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --bash)
fi

# pnpm
export PNPM_HOME="/Users/logno/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
