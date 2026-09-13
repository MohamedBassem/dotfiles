nix := "nix --extra-experimental-features 'nix-command flakes'"
os := `uname -s`
# List available recipes
default:
    @just --list

# Show every flake output, including Linux outputs when run on macOS
show:
    {{ nix }} flake show --all-systems

# Evaluate every declared host, then run repository checks for this system
check:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ nix }} flake check --all-systems --no-build
    system="$({{ nix }} eval --impure --raw --expr builtins.currentSystem)"
    {{ nix }} build --no-link \
        ".#checks.$system.formatting" \
        ".#checks.$system.shellcheck" \
        ".#checks.$system.zsh-syntax"

# Format Nix files with the formatter pinned by the flake
fmt:
    {{ nix }} fmt

# Build this machine's configuration and show package differences
build:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ os }}" in
        Darwin) nh darwin build . --out-link result ;;
        Linux) nh home build . --out-link result ;;
        *) echo "Unsupported operating system: {{ os }}" >&2; exit 1 ;;
    esac

# Build and compare against the active configuration
alias diff := build

# Build this machine's configuration and confirm before activation
switch:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{ os }}" in
        Darwin) nh darwin switch . --ask --out-link result ;;
        Linux) nh home switch . --ask --out-link result ;;
        *) echo "Unsupported operating system: {{ os }}" >&2; exit 1 ;;
    esac

# Activate a nix-darwin configuration after confirmation
switch-darwin configuration:
    nh darwin switch . --hostname "{{ configuration }}" --ask

# Activate a standalone Home Manager configuration after confirmation
switch-home configuration:
    nh home switch . --configuration "{{ configuration }}" --ask

# Update every pinned input; review flake.lock and build affected devices afterward
update:
    {{ nix }} flake update

# List and roll back nix-darwin generations
generations-mac:
    darwin-rebuild --list-generations

rollback-mac:
    sudo darwin-rebuild switch --rollback

# List standalone Home Manager generations on Linux
generations-linux:
    home-manager generations
