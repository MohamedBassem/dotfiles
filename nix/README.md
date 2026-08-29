# Nix configuration

The flake pins one Nixpkgs revision for Home Manager and nix-darwin. Common
packages evaluate on `aarch64-darwin`, `aarch64-linux`, and `x86_64-linux`.

## Hosts

| Output | System | Manager |
|---|---|---|
| `darwinConfigurations.Mohameds-Mac-mini` | `aarch64-darwin` | nix-darwin with Home Manager |
| `homeConfigurations."mbassem@mbassem-workstation"` | `x86_64-linux` | Standalone Home Manager on Debian 13 |

The Linux output expects the checkout at `/home/mbassem/repos/dotfiles`.
The Mac output expects `/Users/mbassem/repos/dotfiles`. These paths matter for
the mutable Neovim, Claude, and Herdr plugin links.

## Layout

- `home/common.nix` imports configuration shared by every host.
- `home/packages.nix` owns cross-platform command-line packages.
- `home/files.nix` maps common configuration and scripts.
- `home/shells.nix` configures Zsh and packaged Prezto.
- `home/darwin.nix` and `home/linux.nix` contain platform-specific behavior.
- `darwin/` owns macOS system settings, fonts, and the declarative Homebrew set.
- `hosts/` binds modules to usernames, home directories, and platforms.

## Package ownership

Home Manager installs the shared command-line tools, including Atuin, Neovim,
fzf, tmux, Zsh, and their supporting utilities. The Zsh module supplies Zsh,
so it does not also appear in `home.packages`. OpenSSH is installed only on
Linux because Apple's `ssh` provides `UseKeychain` and the Nixpkgs build does
not. Herdr is installed through Homebrew on macOS; Home Manager registers its
plugins and temporarily falls back to another installed copy when necessary.

nix-darwin keeps these vendor tools in Homebrew because that is their supported
or existing distribution path:

- Herdr, Hunk, and OpenCode
- Nixpacks, Sapling, and Serpl
- Restate, Restate Server, and Restate CLI

Homebrew cleanup, upgrades, and automatic updates stay disabled during system
activation. Packages installed outside this repository are left alone.

## Mutable and unmanaged paths

Home Manager must not own histories, caches, credentials, SSH material, TPM
checkouts, or application data. Neovim and Claude settings use out-of-store
links because normal use may rewrite them. The local Herdr plugins also remain
in the writable checkout.

The Fish configuration remains tracked for occasional use. Nix does not
install Fish, link its configuration, or manage `fish_variables`.

Home Manager installs Prezto from the Nixpkgs revision pinned by `flake.lock`.
Personal Zsh code lives in the repository under `zsh/`.
