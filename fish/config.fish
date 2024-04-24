eval "$(/opt/homebrew/bin/brew shellenv)"
direnv hook fish | source

if status is-interactive
    atuin init fish --disable-up-arrow | source
end

abbr -a vim nvim
abbr -a vi nvim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set --export ANDROID_HOME "$HOME/Library/Android/sdk"
