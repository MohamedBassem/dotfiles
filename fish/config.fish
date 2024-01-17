eval "$(/opt/homebrew/bin/brew shellenv)"
direnv hook fish | source

if status is-interactive
    atuin init fish --disable-up-arrow | source
end

abbr -a vim nvim
abbr -a vi nvim
