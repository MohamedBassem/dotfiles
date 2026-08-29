# Dotfiles

Personal dotfiles managed with Nix, Home Manager, and nix-darwin. The same
Home Manager modules cover macOS and Linux. Platform modules own shared
behavior, while `nix/hosts/` binds that behavior to a device, user, home
directory, and checkout path. The exact configured outputs are documented in
[`nix/README.md`](nix/README.md).

## Hosts

| Host | Build alias | Platform | Manager output |
|---|---|---|---|
| Mohamed's Mac mini | `mac-mini` | Apple Silicon macOS | `darwinConfigurations.Mohameds-Mac-mini` |
| Mohamed's MacBook Pro | `macbook-pro` | Apple Silicon macOS | `darwinConfigurations.Mohameds-MacBook-Pro` |
| Workstation | `workstation` | x86_64 Linux | `homeConfigurations."mbassem@mbassem-workstation"` |

## Install Nix

Install upstream Nix with the NixOS community installer. Flakes must be
enabled.

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer \
  | sh -s -- install --enable-flakes
```

Clone the repository at the path expected by the selected host module. The
default layout is:

```bash
git clone git@github.com:MohamedBassem/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
```

## Check and build

The `just` recipes enable flakes explicitly, which also makes them work before
the first activation. `just show` lists the platform-local device aliases under
the flake's `packages` output.

```bash
just show
just check
just fmt
just build device=DEVICE
```

Replace `DEVICE` with an alias available for the current platform. Builds write
to the Nix store and create an ignored `result-DEVICE` link; they do not
activate anything.

## Activate

For a new nix-darwin host, build first so the pinned `darwin-rebuild` is
available:

```bash
just build device=DEVICE
sudo ./result-DEVICE/sw/bin/darwin-rebuild switch \
  --flake "path:$PWD#DARWIN_CONFIGURATION"
```

Later switches use:

```bash
just switch-darwin DARWIN_CONFIGURATION
```

Bootstrap a standalone Home Manager host with:

```bash
just build device=DEVICE
./result-DEVICE/activate
```

Later switches use the Home Manager command installed by that first
activation:

```bash
just switch-home HOME_CONFIGURATION
```

`DARWIN_CONFIGURATION` and `HOME_CONFIGURATION` are the corresponding output
names shown by `just show`.

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

Shared command-line tools come from Nix on every host. macOS keeps Homebrew
for Hunk, Nixpacks, Sapling, Serpl, Restate, and OpenCode. nix-darwin does not
run Homebrew cleanup, upgrades, or automatic updates during activation. See
[`nix/README.md`](nix/README.md) for the module layout and package ownership.

Update all pinned inputs explicitly:

```bash
just update
just check
just build device=DEVICE
```

## Add a host

Add a host module under `nix/hosts/`, add its manager output in `flake.nix`, and
expose the resulting derivation as `packages.<system>.<device>`. Non-NixOS
Linux hosts use `lib.mkHome`; macOS hosts use `nix-darwin.lib.darwinSystem`.
Test configurations on their native platform before activation.

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
