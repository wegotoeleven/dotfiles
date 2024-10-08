# Configure shell
export PATH=${HOME}/.binaries:${HOME}/.homebrew/bin:${PATH}
export FPATH=${HOME}/.zsh:${HOME}/.homebrew/share/zsh/site-functions:${FPATH}
export CLICOLOR=1  # Enable colour output in macOS ls
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=1000000
export QUOTING_STYLE=literal
export EDITOR="code -w"
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
prompt wego
zstyle ':vcs_info:git:*' formats '(%b) '
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # Enable colour output in GNU ls
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE
setopt PROMPT_SUBST
bindkey "${terminfo[kcuu1]}" up-line-or-search
bindkey "${terminfo[kcud1]}" down-line-or-search

# Do some sourcing
if [[ -e "${HOME}/.zshrc-extra" ]]; then
    source "${HOME}/.zshrc-extra"
fi
if [[ -e "${HOME}/.aliases" ]]; then
    source "${HOME}/.aliases"
fi

# Functions
precmd() {
    vcs_info
}