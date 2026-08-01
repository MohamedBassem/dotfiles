# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each top-level directory is a stow package. Running `stow -t $HOME <pkg>` mirrors the package's contents as symlinks under `$HOME`.

| Package | Contents |
|---|---|
| `aerospace` | `.aerospace.toml` |
| `bash` | `.bashrc`, `.bash_aliases` |
| `claude` | `.claude/` (settings, statusline command) |
| `fish` | `.config/fish/` (config, functions) |
| `ghostty` | `.config/ghostty/config` |
| `git` | `.gitconfig`, `.gitignore` |
| `herdr` | `.config/herdr/config.toml` |
| `hunk` | `.config/hunk/config.toml` |
| `nvim` | `.config/nvim/` (init.lua, plugins, lua modules) |
| `scripts` | `.local/bin/tmux-sessionizer` |
| `tmux` | `.tmux.conf` |
| `vim` | `.vimrc` |
| `wezterm` | `.wezterm.lua` |
| `zsh` | `.zprezto/` (submodule), zsh runcoms |

The canonical package list is the `PACKAGES` array in `install.sh`.

## Install

```bash
git clone --recursive git@github.com:MohamedBassem/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
./install.sh
```

The install script will:
1. Install Homebrew if missing
2. Install all packages from the `Brewfile`
3. Initialize git submodules
4. Stow all packages
5. Copy fonts to `~/Library/Fonts`

## Day-to-day usage (justfile)

```bash
just               # list recipes
just stow nvim     # symlink specific package(s)
just restow tmux   # relink after adding/removing files in a package
just unstow vim    # remove a package's symlinks
just stow-all      # stow every package
just check         # dry-run all packages to surface conflicts
```

The package list is read from the `PACKAGES` array in `install.sh`, so there is a single source of truth.

## Usage on an existing machine

If you already have config files in place, adopt them to let stow take ownership:

```bash
rm -rf ~/.zprezto  # remove old submodule clone if present
cd ~/repos/dotfiles
just adopt git tmux vim bash wezterm aerospace nvim fish ghostty scripts zsh hunk herdr claude
git diff       # check for local differences
git checkout . # restore repo versions if needed
```

## Adding a new config

1. Create a package directory: `mkdir -p <pkg>`
2. Place files mirroring the home directory structure (e.g., `<pkg>/.config/app/config`)
3. Add the package name to the `PACKAGES` array in `install.sh`
4. Run `just stow <pkg>`
