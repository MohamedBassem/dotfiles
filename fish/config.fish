if test -f "/opt/homebrew/bin/brew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

if test -f "/home/linuxbrew/.linuxbrew/bin/brew"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
end

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
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
