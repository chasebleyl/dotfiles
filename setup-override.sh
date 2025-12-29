#!/usr/bin/env bash
set -euo pipefail

# Determine the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------------------
# Clean Install Script
# ------------------------------------------------------------------------------
# This script backs up and removes existing config files before running the
# standard setup. Use this when migrating from an existing configuration to
# this dotfiles repo.
#
# Backups are stored in: ~/.dotfiles-backup/<timestamp>/
# ------------------------------------------------------------------------------

# Backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Files/directories that conflict with stow symlinks
STOW_CONFLICTS=(
    "$HOME/.zshenv"
    "$HOME/.config/zsh"
    "$HOME/.config/git"
    "$HOME/.config/starship.toml"
    "$HOME/.config/gh"
    "$HOME/.vimrc"
    "$HOME/.jenv"
    "$HOME/.config/iterm2"
    "$HOME/Library/Application Support/Code/User"
)

# Legacy zsh files that become dead after ZDOTDIR is set
LEGACY_ZSH_FILES=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.zlogin"
    "$HOME/.zlogout"
)

# Combine all files to delete
ALL_CONFLICTS=("${STOW_CONFLICTS[@]}" "${LEGACY_ZSH_FILES[@]}")

# ------------------------------------------------------------------------------
# Display warning and list files to be backed up and removed
# ------------------------------------------------------------------------------
echo "============================================================"
echo "  CLEAN INSTALL - MIGRATION MODE"
echo "============================================================"
echo ""
echo "This script will BACK UP and REMOVE the following files/directories"
echo "if they exist, then run the standard setup:"
echo ""

files_to_delete=()
for path in "${ALL_CONFLICTS[@]}"; do
    if [[ -e "$path" || -L "$path" ]]; then
        files_to_delete+=("$path")
        if [[ -d "$path" && ! -L "$path" ]]; then
            echo "  [DIR]  $path"
        elif [[ -L "$path" ]]; then
            echo "  [LINK] $path"
        else
            echo "  [FILE] $path"
        fi
    fi
done

if [[ ${#files_to_delete[@]} -eq 0 ]]; then
    echo "  (No conflicting files found)"
    echo ""
    echo "No cleanup needed. Running standard setup..."
    echo ""
    exec "$DOTFILES_DIR/setup.sh"
fi

echo ""
echo "Backup location: $BACKUP_DIR"
echo "============================================================"
echo ""

# ------------------------------------------------------------------------------
# Confirm with user
# ------------------------------------------------------------------------------
read -p "Are you sure you want to back up and remove these files? [y/N] " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Aborted. No files were modified."
    exit 1
fi

echo ""

# ------------------------------------------------------------------------------
# Create backup directory
# ------------------------------------------------------------------------------
echo "Creating backup directory: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# ------------------------------------------------------------------------------
# Backup and remove conflicting files
# ------------------------------------------------------------------------------
echo "Backing up and removing conflicting files..."

for path in "${files_to_delete[@]}"; do
    # Get the path relative to $HOME for backup structure
    relative_path="${path#$HOME/}"
    backup_path="$BACKUP_DIR/$relative_path"
    backup_parent="$(dirname "$backup_path")"

    # Create parent directory in backup location
    mkdir -p "$backup_parent"

    if [[ -d "$path" && ! -L "$path" ]]; then
        echo "  Backing up directory: $path"
        cp -R "$path" "$backup_path"
        echo "  Removing directory: $path"
        rm -rf "$path"
    else
        echo "  Backing up: $path"
        cp -P "$path" "$backup_path"  # -P preserves symlinks
        echo "  Removing: $path"
        rm -f "$path"
    fi
done

echo ""
echo "Backup complete: $BACKUP_DIR"
echo "Cleanup complete. Running standard setup..."
echo ""

# ------------------------------------------------------------------------------
# Run standard setup
# ------------------------------------------------------------------------------
exec "$DOTFILES_DIR/setup.sh"
