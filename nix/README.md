# Nix configuration

The flake pins one Nixpkgs revision for Home Manager and nix-darwin. Common
packages evaluate on `aarch64-darwin`, `aarch64-linux`, and `x86_64-linux`.

## Hosts

| Output | System | Manager |
|---|---|---|
| `darwinConfigurations.Mohameds-Mac-mini` | `aarch64-darwin` | nix-darwin with Home Manager |
| `darwinConfigurations.Mohameds-MacBook-Pro` | `aarch64-darwin` | nix-darwin with Home Manager |
| `homeConfigurations."mbassem@mbassem-workstation"` | `x86_64-linux` | Standalone Home Manager on Debian 13 |

The Linux output expects the checkout at `/home/mbassem/repos/dotfiles`.
The Mac mini output expects `/Users/mbassem/repos/dotfiles`, and the MacBook Pro
output expects `/Users/mohamedbassem/repos/dotfiles`. These paths matter for the
mutable out-of-store links and locally developed extensions.

## Layout

- `home/common.nix` imports configuration shared by every host.
- `home/packages.nix` owns cross-platform command-line packages.
- `home/files.nix` maps common configuration and scripts.
- `home/shells.nix` configures interactive shells and their pinned framework.
- `home/darwin.nix` and `home/linux.nix` contain platform-specific behavior.
- `darwin/` owns macOS system settings, fonts, and the declarative Homebrew set.
- `hosts/` binds modules to usernames, home directories, and platforms.

## Package ownership

Home Manager owns portable command-line and shell tooling shared across hosts.
Platform modules may omit packages when the operating system's implementation
provides required native integration.

nix-darwin delegates software to Homebrew when that is the supported or
existing distribution channel. Host modules may add platform applications and
system defaults. This integration is additive: cleanup, upgrades, and automatic
updates stay disabled during activation, and undeclared installations are left
alone.

Versioned language runtimes, project-specific toolchains, privileged system
extensions, and software requiring interactive installation remain outside the
system configuration.

## Mutable and unmanaged paths

Home Manager must not own histories, caches, credentials, SSH material, TPM
checkouts, or application data. Configuration that applications rewrite during
normal use relies on out-of-store links, and locally developed extensions stay
in the writable checkout.

Tracked files are not necessarily installed; modules explicitly select the
configuration relevant to each host. Third-party shell components come from
the revisions pinned by `flake.lock`, while personal shell code stays in the
repository.
