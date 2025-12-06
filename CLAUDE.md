# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/). Stow creates symlinks from this repository to `$HOME`, keeping configurations version-controlled while maintaining their expected locations.

## Common Commands

**Initial setup / update all configs (new machine):**
```bash
./setup.sh
```

**Migration setup (existing machine with configs):**
```bash
./setup-override.sh
```
This backs up existing configs to `~/.dotfiles-backup/<timestamp>/` before running `setup.sh`.

**Stow a single package:**
```bash
stow -R -d ~/Projects/cb-dotfiles -t $HOME <package>
```

**Install Homebrew packages:**
```bash
brew bundle --file=Brewfile
```

## Architecture

### Stow Package Structure

Each top-level directory is a "stow package" that mirrors the target directory structure relative to `$HOME`:

- `zsh/` → zsh config using XDG directories (ZDOTDIR at `~/.config/zsh`)
- `git/` → git config at `~/.config/git/`
- `starship/` → starship prompt config at `~/.config/starship.toml`
- `gh/` → GitHub CLI config at `~/.config/gh/`
- `vim/` → vim config at `~/.vimrc`

### Key Design Decisions

- **XDG Base Directory compliance**: Most configs use `~/.config/` instead of cluttering `$HOME`
- **`.zshenv` as entry point**: Sets up XDG vars and ZDOTDIR, then zsh loads remaining config from `~/.config/zsh/`
- **Local overrides**: `~/.config/zsh/.zshrc.local` is sourced if present (not tracked in git)
- **Git credentials separate**: `user.name` and `user.email` are configured via `git config --global` during setup, not stored in repo

### Adding a New Package

1. Create a directory named after the package (e.g., `tmux/`)
2. Mirror the target directory structure inside it (e.g., `tmux/.config/tmux/tmux.conf`)
3. Add the package name to `STOW_PACKAGES` array in `setup.sh`
4. Add the target paths to `STOW_CONFLICTS` array in `setup-override.sh`
5. Run `stow -R -d ~/Projects/cb-dotfiles -t $HOME <package>`
