# Dotfiles

Personal dotfiles managed with Nix, Home Manager, and nix-darwin. The same
Home Manager modules cover macOS and Debian Linux.

## Hosts

| Flake output | Platform | Manager |
|---|---|---|
| `Mohameds-Mac-mini` | Apple Silicon macOS | nix-darwin with Home Manager |
| `mbassem@mbassem-workstation` | x86_64 Debian 13 | Standalone Home Manager |

Each host module declares its user, home directory, and checkout path. Mutable
links depend on the checkout being at `~/repos/dotfiles`.

## Install Nix

Install upstream Nix with the NixOS community installer. Flakes must be
enabled.

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer \
  | sh -s -- install --enable-flakes
```

Clone the repository at the declared path:

```bash
git clone git@github.com:MohamedBassem/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
```

## Check and build

The `just` recipes enable flakes explicitly, which also makes them work before
the first Home Manager activation on Debian.

```bash
just show
just check
just fmt
just build-mac    # run on the Mac
just build-linux  # run on the Debian workstation
```

Builds write to the Nix store and create ignored `result-mac` or
`result-linux` links. They do not activate anything.

## Activate

On a new Mac, build first so the pinned `darwin-rebuild` is available:

```bash
just build-mac
sudo ./result-mac/sw/bin/darwin-rebuild switch --flake '.#Mohameds-Mac-mini'
```

Later switches use:

```bash
just switch-mac
```

Bootstrap the Debian workstation with:

```bash
just build-linux
./result-linux/activate
```

Later switches use the Home Manager command installed by that first
activation:

```bash
just switch-linux
```

## Ownership

Static configuration and scripts link into `/nix/store`. Neovim, Claude
settings, and local Herdr plugins link into the writable checkout. Home Manager
does not own credentials, histories, caches, SSH material, TPM checkouts, or
application data.

The Fish configuration stays in `fish/` for occasional use, but Nix does not
install Fish or link that configuration into the home directory.

Home Manager installs Prezto from the Nixpkgs revision in `flake.lock`.
Personal Zsh code lives under `zsh/` as regular tracked files. Run
`nix flake update` to update Prezto along with the other pinned packages.

## Packages

Shared command-line tools come from Nix on both machines. macOS keeps Homebrew
for Hunk, Nixpacks, Sapling, Serpl, Restate, and OpenCode. nix-darwin does not
run Homebrew cleanup, upgrades, or automatic updates during activation. See
[`nix/README.md`](nix/README.md) for the module layout and package ownership.

Update all pinned inputs explicitly:

```bash
just update
just check
just build-mac    # run on the Mac
just build-linux  # run on the Debian workstation
```

## Add a host

Add a host module under `nix/hosts/`, then add its output in `flake.nix`.
Non-NixOS Linux machines use `lib.mkHome`; macOS machines use
`nix-darwin.lib.darwinSystem`. Test Linux configurations on their native host
before activation.

## Roll back

On macOS, list or activate the previous nix-darwin generation:

```bash
just generations-mac
just rollback-mac
```

On Linux, `home-manager generations` prints each generation's activation path.
Run the selected `activate` script to switch back.

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
