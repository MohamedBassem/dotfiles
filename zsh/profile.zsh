typeset -gU cdpath fpath mailpath path

if [[ "$OSTYPE" == darwin* ]]; then
  path=(
    /opt/homebrew/opt/sqlite/bin(N)
    /opt/{homebrew,local}/{,s}bin(N)
    $path
  )

  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
  path=(/Applications/Obsidian.app/Contents/MacOS(N) $path)
fi
