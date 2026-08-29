# Personal paths beyond Prezto's standard defaults.
typeset -gU cdpath fpath mailpath path
path=(
  $HOME/usr/bin(N)
  $HOME/.local/bin(N)
  $HOME/.cargo/bin(N)
  $HOME/.bun/bin(N)
  $HOME/.volta/bin(N)
  $HOME/.pulumi/bin(N)
  /usr/local/go/bin(N)
  $HOME/repos/go/bin(N)
  $path
)

if [[ "$OSTYPE" == darwin* ]]; then
  path=(
    /opt/homebrew/opt/sqlite/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    $path
  )

  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
  path=(/Applications/Obsidian.app/Contents/MacOS(N) $path)
fi
