# Package list is defined once in install.sh (canonical source)
packages := `sed -n 's/^PACKAGES=(\(.*\))$/\1/p' install.sh`

# List available recipes
default:
    @just --list

# Full machine setup (brew, submodules, stow, fonts, gitconfig.local)
install:
    ./install.sh

# Symlink one or more packages into $HOME (e.g. `just stow nvim tmux`)
stow +pkgs: _guard-dirs
    stow -v -t "$HOME" {{ pkgs }}

# Relink packages after adding/removing files (prunes stale links)
restow +pkgs: _guard-dirs
    stow -v -R -t "$HOME" {{ pkgs }}

# Remove the symlinks for one or more packages
unstow +pkgs:
    stow -v -D -t "$HOME" {{ pkgs }}

# Take ownership of existing files in $HOME — review with `git diff` after!
adopt +pkgs: _guard-dirs
    stow -v --adopt -t "$HOME" {{ pkgs }}

# Stow every package
stow-all: (stow packages)

# Restow every package
restow-all: (restow packages)

# Dry-run stow of every package to surface conflicts
check:
    stow -n -v -t "$HOME" {{ packages }}

# Pre-create shared dirs so stow never tree-folds them into the repo
# (app runtime state and credentials must stay outside the repo)
_guard-dirs:
    @mkdir -p ~/.config ~/.local/bin ~/.config/hunk ~/.config/herdr ~/.config/sapling ~/.claude ~/Library/Preferences/sapling
