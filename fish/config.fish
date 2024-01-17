eval "$(/opt/homebrew/bin/brew shellenv)"

if status is-interactive
    atuin init fish --disable-up-arrow | source
end

abbr -a vim nvim
abbr -a vi nvim

# Make Ctrl+c work like zsh
bind \cc 'custom_fish_cancel_commandline'
