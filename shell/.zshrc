# Configure shell
export CLICOLOR=1
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=1000000
export QUOTING_STYLE=literal
if which code &>/dev/null; then
    export EDITOR="code -w"
else
    export EDITOR=vi
fi
path+=(${HOME}/.binaries)
path+=(${HOME}/.homebrew/bin)
fpath+=(${HOME}/.zsh)
fpath+=(${HOME}/.zsh/pure)
fpath+=(${HOME}/.homebrew/share/zsh/site-functions)
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
prompt pure
# zstyle ':vcs_info:git:*' formats '%b'
setopt SHARE_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE
setopt PROMPT_SUBST
bindkey -e
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
