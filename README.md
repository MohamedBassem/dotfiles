# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Most top-level directories are Stow packages. Running `stow -t $HOME <pkg>`
mirrors a package's contents as symlinks under `$HOME`; `herdr-plugins` is the
exception and is registered through Herdr's local plugin linker.

| Package | Contents |
|---|---|
| `aerospace` | `.aerospace.toml` |
| `bash` | `.bashrc`, `.bash_aliases` |
| `claude` | `.claude/` (settings, statusline command) |
| `fish` | `.config/fish/` (config, functions) |
| `ghostty` | `.config/ghostty/config` |
| `git` | `.gitconfig`, `.gitignore` |
| `herdr` | `.config/herdr/config.toml` |
| `herdr-plugins` | Locally owned Herdr plugins (linked by `install.sh`) |
| `hunk` | `.config/hunk/config.toml` |
| `nvim` | `.config/nvim/` (init.lua, plugins, lua modules) |
| `sapling` | `sapling.conf` (GitHub stacked PR workflow) |
| `scripts` | Helper commands including `tmux-sessionizer` and `sl-share-worktree` |
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
5. Link the locally owned Herdr plugins (when Herdr is installed)
6. Copy fonts to `~/Library/Fonts`

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

## Sapling + GitHub stacked PRs

The `sapling` package configures Sapling's single-commit PR topology and adds a
`sl submit-stack` command. From the top commit of a stack, run:

```bash
sl submit-stack --draft
```

This first runs `sl pr submit --stack`, then registers the resulting PRs as a
native GitHub stack through the installed `github/gh-stack` extension. Re-run
the same command after amending or restacking commits; both submission and
stack linking are idempotent.

### Shared Sapling working copies

For native `.sl` repositories, `sl worktrees` wraps Sapling's hidden `share`
extension with safer defaults. It creates named copies under a managed sibling
directory and explicitly checks out the requested revision:

```bash
cd "$(sl worktrees add issue-123)"             # current commit
cd "$(sl worktrees add issue-456 remote/main)" # another revision
sl worktrees list
sl worktrees remove issue-123                   # prompts before removal
sl worktrees rm issue-456 --yes                 # non-interactive removal
```

Set `SL_SHARE_WORKTREE_ROOT` to choose a different parent directory. The list
command reports each copy's clean/dirty status, current commit, and commit
description. Removal only accepts managed, clean working copies belonging to
the current shared repository. It deletes the working-copy directory directly;
it does not use `sl unshare`, which is broken with the Git-compatible storage
used by current public `.sl` repositories.
