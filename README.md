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

The default development shell provides `just`, the pinned formatter, and the
repository lint tools. Use it before the first activation:

```bash
nix develop -c just check
```

After activation, the shorter commands work directly. `just build` detects the
hostname and operating system, then builds the matching device alias. `just
show` lists those aliases under the flake's `packages` output.

```bash
just show
just check
just fmt
just build
```

`just check` evaluates every host and runs the formatter, ShellCheck, and Zsh
syntax checks for the current system. Builds write to the Nix store and create
an ignored `result-BUILD_ALIAS` link; they do not activate anything. An unknown
hostname fails instead of selecting another machine's configuration.

## Activate

`just switch` detects the host, builds its configuration, and activates it. On
macOS it runs the `darwin-rebuild` binary from the build result. On Linux it
runs the Home Manager activation script. It works before the first activation.

```bash
just switch
```

The explicit `switch-darwin CONFIGURATION` and `switch-home CONFIGURATION`
recipes remain available for troubleshooting.

## Ownership

Static files link into `/nix/store`. Personal commands are Nix packages with
their runtime tools declared alongside them. Configuration that applications
update at runtime links into the writable checkout. Home Manager does not own
private or stateful data such as credentials, histories, caches, or application
data.

## Packages

Shared packages come from Nix. macOS also uses Homebrew for packages managed
outside Nix. Activation does not run Homebrew cleanup, upgrades, or automatic
updates. See [`nix/README.md`](nix/README.md) for the module layout and package
ownership.

Home Manager configures Atuin, direnv with nix-direnv, eza, fzf, Neovim, and
zoxide for Bash and Zsh. Project-specific toolchains should use flake
development shells and `.envrc` files instead of adding more global runtimes.

Update all pinned inputs explicitly:

```bash
just update
just check
just build
```

## Add a host

Add a host module under `nix/hosts/`, add its manager output in `flake.nix`, and
expose the resulting derivation as `packages.<system>.<device>`. Non-NixOS
Linux hosts use `lib.mkHome`; macOS hosts use `nix-darwin.lib.darwinSystem`.
Add its hostname, build alias, and manager output to the mappings at the top of
the `justfile`. Test configurations on their native platform before activation.

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
