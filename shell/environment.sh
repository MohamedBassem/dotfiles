# Shared by Bash, Zsh, and non-interactive personal commands.
export DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/repos/dotfiles}"
export EDITOR=nvim VISUAL=nvim HGEDITOR=nvim
export GOPATH="$HOME/repos/go"
export BUN_INSTALL="$HOME/.bun" VOLTA_HOME="$HOME/.volta"
export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1 HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
case "$(uname -s)" in
  Darwin)
    export HOMEBREW_PREFIX=/opt/homebrew
    export PNPM_HOME="$HOME/Library/pnpm"
    ;;
  Linux)
    export HOMEBREW_PREFIX=/home/linuxbrew/.linuxbrew
    export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
    ;;
esac
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
# Drop inherited Nix paths, including paths added by system startup files.
dotfiles_clean_path=$(printf '%s' "$PATH" | /usr/bin/awk -v RS=: '
  $0 == "" || $0 ~ /^\/nix\// || $0 ~ /\/\.nix-profile\// ||
  $0 ~ /^\/etc\/profiles\/per-user\// || $0 ~ /^\/run\/current-system\// { next }
  !seen[$0]++ { printf "%s%s", separator, $0; separator = ":" }
')
PATH="$HOME/.local/bin:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin"
PATH="$PATH:$HOME/.volta/bin:$HOME/.bun/bin:$PNPM_HOME:$HOME/bin:$HOME/usr/bin:$HOME/.cargo/bin:$HOME/.pulumi/bin:$GOPATH/bin:$HOME/repos/google-cloud-sdk/bin"
if [ "$(uname -s)" = Darwin ]; then
  PATH="$PATH:$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/emulator:/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$HOMEBREW_PREFIX/opt/sqlite/bin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/Applications/Obsidian.app/Contents/MacOS:$HOME/.orbstack/bin"
fi
PATH="$PATH:$dotfiles_clean_path"
PATH=$(printf '%s' "$PATH" | /usr/bin/awk -v RS=: '
  $0 != "" && !seen[$0]++ { printf "%s%s", separator, $0; separator = ":" }
')
export PATH
unset dotfiles_clean_path
if [ -r "$HOME/.config/dotfiles/host.env" ]; then
  . "$HOME/.config/dotfiles/host.env"
fi
