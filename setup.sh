#!/usr/bin/env bash
set -euo pipefail

# Determine the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stow packages to install
STOW_PACKAGES=(zsh git starship gh vim)

echo "Dotfiles directory: $DOTFILES_DIR"
echo "Target directory: $HOME"
echo ""

# ------------------------------------------------------------------------------
# 1. Install Homebrew if not present
# ------------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session (Apple Silicon vs Intel)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
fi

# ------------------------------------------------------------------------------
# 2. Install packages from Brewfile
# ------------------------------------------------------------------------------
echo ""
echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ------------------------------------------------------------------------------
# 3. Create XDG directories if they don't exist
# ------------------------------------------------------------------------------
echo ""
echo "Ensuring XDG directories exist..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.cache"

# ------------------------------------------------------------------------------
# 4. Stow packages (symlink configs to $HOME)
# ------------------------------------------------------------------------------
echo ""
echo "Stowing packages..."
for package in "${STOW_PACKAGES[@]}"; do
    echo "  Stowing $package..."
    stow -R -d "$DOTFILES_DIR" -t "$HOME" "$package"
done

# ------------------------------------------------------------------------------
# 5. Install NVM (Node Version Manager)
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
    echo ""
    echo "Installing NVM..."
    # Use PROFILE=/dev/null to skip shell config modification
    # (already configured in stowed .zshrc)
    PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'

    # Source NVM for current session
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install latest LTS Node.js
    echo "Installing Node.js LTS..."
    nvm install --lts
else
    echo ""
    echo "NVM already installed."
fi

# ------------------------------------------------------------------------------
# 6. Configure git user (not stored in repo)
# ------------------------------------------------------------------------------
echo ""
echo "Configuring git user..."

# Check if git user is already configured
existing_name=$(git config --global user.name 2>/dev/null || echo "")
existing_email=$(git config --global user.email 2>/dev/null || echo "")

if [[ -n "$existing_name" && -n "$existing_email" ]]; then
    echo "  Git user already configured:"
    echo "    Name:  $existing_name"
    echo "    Email: $existing_email"
    read -p "  Keep existing config? [Y/n] " keep_existing
    if [[ "$keep_existing" =~ ^[Nn]$ ]]; then
        existing_name=""
        existing_email=""
    fi
fi

if [[ -z "$existing_name" || -z "$existing_email" ]]; then
    read -p "  Enter your name for git commits: " git_name
    read -p "  Enter your email for git commits: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"

    echo "  Git user configured:"
    echo "    Name:  $git_name"
    echo "    Email: $git_email"
fi

# ------------------------------------------------------------------------------
# 7. Configure Claude Code MCP servers
# ------------------------------------------------------------------------------
if command -v claude &>/dev/null; then
    echo ""
    echo "Configuring Claude Code MCP servers..."
    claude mcp add --scope user --transport http linear-server https://mcp.linear.app/mcp
    claude mcp add --scope user playwright npx @playwright/mcp@latest
else
    echo ""
    echo "Claude Code not found - skipping MCP server configuration."
    echo "Run 'brew bundle' and re-run this script to configure MCP servers."
fi

# ------------------------------------------------------------------------------
# 8. Post-install reminders
# ------------------------------------------------------------------------------
echo ""
echo "Setup complete!"
echo ""
echo "Post-install steps:"
echo "  - Run 'gh auth login' to authenticate with GitHub"
echo "  - Run 'az login' to authenticate with Azure"
echo "  - Run 'claude' to authenticate Claude Code on initial launch"
echo "  - Run '/mcp' within Claude Code to authenticate MCP server(s)"
echo "  - Restart your shell or run 'source ~/.zshenv' to apply zsh config"
