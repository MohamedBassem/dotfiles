# Dotfiles

macOS and Debian dotfiles managed by mise. Shared packages and file links live in
[mise/config.toml](mise/config.toml); `mise/config.<profile>.toml` adds host settings.
Keep the checkout at `~/repos/dotfiles`.

## Setup

macOS needs Xcode Command Line Tools. Install mise independently of Nix:

```sh
curl -fsSL https://mise.run | MISE_VERSION=v2026.10.0 sh
export PATH="$HOME/.local/bin:$PATH"
cd ~/repos/dotfiles
host=mac-mini # choose a profile from the table
```

Before the first bootstrap, back up existing configs. Use `tar -h` to save the
contents of Nix-managed symlinks. Move any existing `~/.config/mise` aside, and
preserve custom SSH hosts in `~/.ssh/config.local`.

Link the configuration and save this machine's profile:

```sh
mkdir -p ~/.config/mise
ln -s "$PWD"/mise/config*.toml "$HOME/.config/mise/"
printf 'env = ["%s"]\n' "$host" > ~/.config/mise/miserc.local.toml
mise bootstrap --dry-run --force-dotfiles
mise bootstrap --force-dotfiles
```

`--force-dotfiles` replaces conflicting managed files. Open a fresh terminal,
then verify the links and tools:

```sh
mise dot status --missing
mise doctor
```

On Debian, start the services after bootstrap. They require the existing vault
at `~/vaults/MainVault` and launcher at `~/.t3/runtime/service-launcher.mjs`.

```sh
systemctl --user daemon-reload
systemctl --user enable --now obsidian-sync.service t3code.service
```

## Daily use

```sh
mise bootstrap --dry-run           # preview changes
mise bootstrap                     # apply configuration
mise upgrade                       # update versioned tools
mise bootstrap packages upgrade    # update packages
```

Existing Homebrew-owned casks still need Homebrew for upgrades.

## Sapling

Submit a stack, or create a shared working copy:

```sh
sl submit-stack --draft
cd "$(sl worktrees add issue-123 remote/main)"
sl worktrees list
sl worktrees remove issue-123
```

Stack submission uses the `github/gh-stack` extension. Working copies default to
a sibling directory; set `SL_SHARE_WORKTREE_ROOT` to choose another location.
