# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each top-level directory is a stow package. Running `stow -t $HOME <pkg>` mirrors the package's contents as symlinks under `$HOME`.

| Package | Contents |
|---|---|
| `aerospace` | `.aerospace.toml` |
| `bash` | `.bashrc`, `.bash_aliases` |
| `fish` | `.config/fish/` (config, functions) |
| `ghostty` | `.config/ghostty/config` |
| `git` | `.gitconfig`, `.gitignore` |
| `nvim` | `.config/nvim/` (init.lua, plugins, lua modules) |
| `scripts` | `.local/bin/tmux-sessionizer` |
| `tmux` | `.tmux.conf` |
| `vim` | `.vimrc` |
| `wezterm` | `.wezterm.lua` |
| `zsh` | `.zprezto/` (submodule), zsh runcoms |

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

## Usage on an existing machine

If you already have config files in place, use `--adopt` to let stow take ownership:

```bash
mkdir -p ~/.config ~/.local/bin
rm -rf ~/.zprezto  # remove old submodule clone if present
cd ~/repos/dotfiles
stow --adopt -t $HOME git tmux vim bash wezterm aerospace nvim fish ghostty scripts zsh
git diff       # check for local differences
git checkout . # restore repo versions if needed
```

## Adding a new config

1. Create a package directory: `mkdir -p <pkg>`
2. Place files mirroring the home directory structure (e.g., `<pkg>/.config/app/config`)
3. Add the package name to the `PACKAGES` array in `install.sh`
4. Run `stow -t $HOME <pkg>`
