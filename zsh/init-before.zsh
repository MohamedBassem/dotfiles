# Prezto modules may call Homebrew commands, so initialize it first.
if [[ "$OSTYPE" == darwin* && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == linux* && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Homebrew prepends its own directories. Restore the intended precedence:
# language managers, Home Manager, system Nix, then Homebrew.
path=(
  $HOME/.volta/bin(N)
  $HOME/.bun/bin(N)
  $HOME/.nix-profile/bin(N)
  /etc/profiles/per-user/$USER/bin(N)
  /run/current-system/sw/bin(N)
  $path
)

# Prefer a Homebrew-managed ssh-agent over macOS's launchd socket.
if [[ "$OSTYPE" == darwin* && "$SSH_AUTH_SOCK" == /var/run/com.apple.launchd.* ]]; then
  unset SSH_AUTH_SOCK
fi
