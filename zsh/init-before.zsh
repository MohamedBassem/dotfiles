# Prezto initializes completions, so add vendor functions first. PATH and the
# Homebrew environment are declared in shell/environment.sh.
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

# Prezto's ssh module symlinks ~/.cache/prezto/ssh-agent.sock to $SSH_AUTH_SOCK.
# herdr exports its own link (herdr.sock.agent) that points back at Prezto's,
# so hand Prezto the real socket or the two links end up pointing at each other.
if [[ -n "$SSH_AUTH_SOCK" && -S "${SSH_AUTH_SOCK:A}" ]]; then
  export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:A}"
fi
