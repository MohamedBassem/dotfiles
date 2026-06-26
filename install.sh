#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile (includes stow)
echo "Running brew bundle..."
brew bundle --file="$DOTFILES/Brewfile"

# Init git submodules (zprezto)
echo "Initializing submodules..."
git -C "$DOTFILES" submodule update --init --recursive

# Create shared parent dirs to prevent stow from tree-folding them
mkdir -p ~/.config ~/.local/bin

# Remove old symlinks/directories that would conflict with stow
for target in \
  ~/.gitconfig ~/.gitignore \
  ~/.tmux.conf ~/.vimrc ~/.bashrc ~/.bash_aliases \
  ~/.wezterm.lua ~/.aerospace.toml \
  ~/.config/nvim ~/.config/fish ~/.config/ghostty ~/.config/hunk/config.toml \
  ~/.local/bin/tmux-sessionizer \
  ~/.claude/settings.json ~/.claude/statusline-command.sh \
  ~/.zprezto ~/.zshrc ~/.zpreztorc ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogout; do
  [ -L "$target" ] && rm "$target"
  [ -e "$target" ] && echo "Warning: $target exists and is not a symlink, skipping removal"
done

# Stow each package
PACKAGES=(git tmux vim wezterm aerospace nvim fish ghostty scripts zsh hunk claude)
echo "Stowing packages: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
  stow -d "$DOTFILES" -t "$HOME" "$pkg"
done

# Copy fonts (macOS only)
if [ "$(uname)" = "Darwin" ] && [ -d "$DOTFILES/.fonts" ]; then
  echo "Installing fonts..."
  mkdir -p ~/Library/Fonts
  cp "$DOTFILES/.fonts/"* ~/Library/Fonts/
fi

# Generate OS-specific git config (not tracked; included by ~/.gitconfig)
echo "Writing ~/.gitconfig.local..."
if [ "$(uname)" = "Darwin" ]; then
  git_ssl_backend="secure-transport"
else
  git_ssl_backend="gnutls"
fi
cat > ~/.gitconfig.local <<EOF
[http]
	sslBackend = $git_ssl_backend
EOF

# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Done!"
