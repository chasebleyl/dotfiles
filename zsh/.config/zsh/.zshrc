# .zshrc - sourced for interactive shells

# ------------------------------------------------------------------------------
# History
# ------------------------------------------------------------------------------
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Ensure history directory exists
[[ -d "$XDG_DATA_HOME/zsh" ]] || mkdir -p "$XDG_DATA_HOME/zsh"

# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ------------------------------------------------------------------------------
# Starship prompt
# ------------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# ------------------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------------------
export EDITOR="vim"
export VISUAL="vim"

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------------------------------------------------------
# NVM
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ------------------------------------------------------------------------------
# Android SDK (NOTE: may need to be updated if/when Android Studio is installed)
# ------------------------------------------------------------------------------
export ANDROID_HOME="$HOME/android-sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
# Add your aliases here

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------
# Add your functions here

# ------------------------------------------------------------------------------
# Local config (not tracked in git)
# ------------------------------------------------------------------------------
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
