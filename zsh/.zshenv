# .zshenv - sourced on all shell invocations
# This file sets up XDG directories and ZDOTDIR

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Tell zsh where to find its config files
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
