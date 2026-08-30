# Prezto initializes completions, so add vendor functions first. PATH and the
# Homebrew environment are declared by Home Manager.
if [[ "$OSTYPE" == darwin* ]]; then
  fpath=(
    /opt/homebrew/share/zsh/site-functions(N)
    $HOME/.orbstack/shell/completions/zsh(N)
    $fpath
  )
elif [[ "$OSTYPE" == linux* ]]; then
  fpath=(/home/linuxbrew/.linuxbrew/share/zsh/site-functions(N) $fpath)
fi

# Drop macOS's launchd agent socket so the Prezto ssh module starts its own
# agent. Hosts with Secretive set SSH_AUTH_SOCK in .zshenv instead.
if [[ "$OSTYPE" == darwin* && "$SSH_AUTH_SOCK" == /var/run/com.apple.launchd.* ]]; then
  unset SSH_AUTH_SOCK
fi
