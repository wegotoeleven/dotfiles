##### Environment Variables

# Add custom binaries to the PATH
path+=(${HOME}/.binaries)

# Enable colored output
export CLICOLOR=1

# History configuration
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=100000       # Number of commands to keep in memory
export SAVEHIST=1000000      # Number of commands to save to file

# Quoting style for file names
export QUOTING_STYLE=literal

# Set default editor
if command -v code &>/dev/null; then
    export EDITOR="code -w"
else
    export EDITOR=vi
fi

##### Zsh Initialization

# Add custom theme directories to fpath
for THEME_DIR in ~/.zsh/themes/**/*(/); do
    fpath+="${THEME_DIR}"
done

# Load Zsh modules
autoload -Uz compinit && compinit        # Enable command completion
autoload -Uz promptinit && promptinit    # Enable prompt customization
autoload -Uz vcs_info                    # Enable VCS information in the prompt

# Set the prompt theme
prompt pure

##### Shell Options

# History options
setopt SHARE_HISTORY          # Share history across all sessions
setopt HIST_SAVE_NO_DUPS      # Avoid duplicate history entries
setopt HIST_EXPIRE_DUPS_FIRST # Expire older duplicates first
setopt PROMPT_SUBST           # Enable command substitution in prompt
setopt NO_HIST_NO_STORE       # Ensure history for the current session is included

##### Key Bindings

# Enable vi mode
set -o vi

# Arrow key history search
bindkey "${terminfo[kcuu1]}" up-line-or-search      # Search history with up arrow
bindkey "${terminfo[kcud1]}" down-line-or-search    # Search history with down arrow
bindkey "^R" history-incremental-search-backward    # Search history with Ctrl+R

##### Additional Configurations

# Source extra configuration files
for extra_file in "${HOME}/.zshrc-extra" "${HOME}/.aliases"; do
    [[ -e "${extra_file}" ]] && source "${extra_file}"
done

##### Functions

# Pre-command function to update VCS info
precmd() {
    vcs_info
}
