if test -x "/opt/homebrew/bin/brew"
    /opt/homebrew/bin/brew shellenv fish | source
end

if test -x "/home/linuxbrew/.linuxbrew/bin/brew"
    /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
end

# Prefer Home Manager packages to duplicate Homebrew packages.
fish_add_path --move --prepend --path \
    "$HOME/.nix-profile/bin" \
    "/etc/profiles/per-user/$USER/bin" \
    "/run/current-system/sw/bin"

if command -q direnv
    direnv hook fish | source
end

if status is-interactive
    atuin init fish --disable-up-arrow | source
end

abbr -a vim nvim
abbr -a vi nvim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if test (uname) = Darwin; and test -d "$HOME/Library/Android/sdk"
    set --export ANDROID_HOME "$HOME/Library/Android/sdk"
    fish_add_path "$ANDROID_HOME/platform-tools" "$ANDROID_HOME/emulator"
end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

if test (uname) = Darwin
    # Added by OrbStack: command-line tools and integration
    source "$HOME/.orbstack/shell/init2.fish" 2>/dev/null || :
end

# Added by LM Studio CLI (lms)
if test -d "$HOME/.lmstudio/bin"
    set -gx PATH $PATH "$HOME/.lmstudio/bin"
end

if test -f "$HOME/.claude/local/claude"
    alias claude="$HOME/.claude/local/claude"
end
