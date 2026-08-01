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

# Create shared parent dirs to prevent stow from tree-folding them.
# App config dirs matter especially: if stow folds them, the apps
# write runtime state (including credentials) inside this repo.
mkdir -p ~/.config ~/.local/bin ~/.config/hunk ~/.config/herdr ~/.claude

# Remove old symlinks that would conflict with stow; abort on real files
conflicts=()
for target in \
  ~/.gitconfig ~/.gitignore \
  ~/.tmux.conf ~/.vimrc ~/.bashrc ~/.bash_aliases \
  ~/.wezterm.lua ~/.aerospace.toml \
  ~/.config/nvim ~/.config/fish ~/.config/ghostty ~/.config/hunk/config.toml \
  ~/.config/herdr/config.toml \
  ~/.local/bin/tmux-sessionizer \
  ~/.claude/settings.json ~/.claude/statusline-command.sh \
  ~/.zprezto ~/.zshrc ~/.zpreztorc ~/.zshenv ~/.zprofile ~/.zlogin ~/.zlogout; do
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    conflicts+=("$target")
  fi
done
if [ "${#conflicts[@]}" -gt 0 ]; then
  echo "Error: the following exist and are not symlinks (stow would fail on them)." >&2
  echo "Move them aside, or run 'stow --adopt' manually (see README):" >&2
  printf '  %s\n' "${conflicts[@]}" >&2
  exit 1
fi

# Stow each package
PACKAGES=(git tmux vim bash wezterm aerospace nvim fish ghostty scripts zsh hunk herdr claude)
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
  git_credential_helper="osxkeychain"
else
  git_ssl_backend="gnutls"
  git_credential_helper="cache"
fi
cat > ~/.gitconfig.local <<EOF
[http]
	sslBackend = $git_ssl_backend
[credential]
	helper = $git_credential_helper
EOF

# Install TPM
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Done!"
