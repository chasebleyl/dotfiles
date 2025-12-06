# cb-dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's Included

| Package   | Description                          |
|-----------|--------------------------------------|
| `zsh`     | Zsh configuration with XDG support   |
| `git`     | Git config and global gitignore      |
| `starship`| Starship prompt configuration        |
| `gh`      | GitHub CLI configuration             |
| `vim`     | Vim configuration                    |

### Installed via Brewfile

- `zsh` - Shell
- `starship` - Cross-shell prompt
- `git` - Version control
- `gh` - GitHub CLI
- `git-crypt` - Transparent file encryption in git
- `azure-cli` - Azure command-line tools
- `stow` - Symlink farm manager
- `dotnet-sdk` - .NET SDK (cask)

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/cb-dotfiles.git ~/Projects/cb-dotfiles
cd ~/Projects/cb-dotfiles
```

### 2. Run the appropriate setup script

#### New Machine (no existing configs)

```bash
./setup.sh
```

This script will:
1. Install Homebrew (if not already installed)
2. Install all packages from the Brewfile
3. Create XDG directories (`~/.config`, `~/.local/share`, `~/.cache`)
4. Stow all packages (symlink configs to `$HOME`)
5. Install NVM and Node.js LTS
6. Prompt you to configure your git user name and email

#### Existing Machine (migrating from existing configs)

If you have existing configuration files that conflict with stow symlinks, use:

```bash
./setup-override.sh
```

This script will:
1. Display all conflicting files that will be affected
2. Back up those files to `~/.dotfiles-backup/<timestamp>/`
3. Remove the original files
4. Run the standard `setup.sh`

The backup location is printed during execution so you can recover files if needed.

## Post-Installation Steps

After running `setup.sh`, complete the following:

### Apply shell configuration

Either restart your terminal or run:

```bash
source ~/.zshenv
```

### Authenticate with GitHub CLI

```bash
gh auth login
```

Follow the prompts to authenticate via browser or token.

### Authenticate with Azure CLI

```bash
az login
```

This opens a browser for Azure authentication.

### Optional: Local zsh customizations

Create `~/.config/zsh/.zshrc.local` for machine-specific settings that won't be tracked in git:

```bash
touch ~/.config/zsh/.zshrc.local
```

## Updating

To re-run stow after making changes to the dotfiles:

```bash
./setup.sh
```

Or manually stow individual packages:

```bash
stow -R -d ~/Projects/cb-dotfiles -t $HOME <package>
```

## File Structure

```
cb-dotfiles/
├── Brewfile              # Homebrew packages
├── setup.sh              # Standard installation script
├── setup-override.sh     # Migration script (backs up existing configs)
├── zsh/
│   ├── .zshenv           # → ~/.zshenv
│   └── .config/zsh/
│       ├── .zprofile     # → ~/.config/zsh/.zprofile
│       └── .zshrc        # → ~/.config/zsh/.zshrc
├── git/
│   └── .config/git/
│       ├── config        # → ~/.config/git/config
│       └── ignore        # → ~/.config/git/ignore
├── starship/
│   └── .config/
│       └── starship.toml # → ~/.config/starship.toml
├── gh/
│   └── .config/gh/
│       └── config.yml    # → ~/.config/gh/config.yml
└── vim/
    └── .vimrc            # → ~/.vimrc
```

## Notes

- Git user credentials (`user.name`, `user.email`) are configured via `git config --global` and not stored in the repository
- The setup uses `stow -R` (restow) which requires no conflicting files to exist; use `setup-override.sh` to migrate from existing configs
- XDG Base Directory specification is used where possible to keep `$HOME` clean
- Backups from `setup-override.sh` are stored in `~/.dotfiles-backup/` with timestamps
