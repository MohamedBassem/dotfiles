nix := "nix --extra-experimental-features 'nix-command flakes'"
os := `uname -s`
host := if os == "Darwin" { `scutil --get LocalHostName` } else { `hostname -s` }
device := if host == "Mohameds-Mac-mini" {
    "mac-mini"
} else if host == "Mohameds-MacBook-Pro" {
    "macbook-pro"
} else if host == "mbassem-workstation" {
    "workstation"
} else {
    ""
}
configuration := if host == "Mohameds-Mac-mini" {
    "Mohameds-Mac-mini"
} else if host == "Mohameds-MacBook-Pro" {
    "Mohameds-MacBook-Pro"
} else if host == "mbassem-workstation" {
    "mbassem@mbassem-workstation"
} else {
    ""
}

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

# Build this machine's configuration without activating it
build:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "{{ device }}" ]]; then
        echo "No Nix configuration is defined for {{ host }} ({{ os }})" >&2
        exit 1
    fi
    {{ nix }} build ".#{{ device }}" --out-link "result-{{ device }}"

# Build and activate this machine's configuration
switch: build
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "{{ configuration }}" ]]; then
        echo "No Nix configuration is defined for {{ host }} ({{ os }})" >&2
        exit 1
    fi
    case "{{ os }}" in
        Darwin)
            sudo "./result-{{ device }}/sw/bin/darwin-rebuild" switch --flake ".#{{ configuration }}"
            ;;
        Linux)
            "./result-{{ device }}/activate"
            ;;
        *)
            echo "Unsupported operating system: {{ os }}" >&2
            exit 1
            ;;
    esac

# Activate a nix-darwin configuration
switch-darwin configuration:
    sudo darwin-rebuild switch --flake ".#{{ configuration }}"

# Activate a standalone Home Manager configuration
switch-home configuration:
    home-manager switch --flake ".#{{ configuration }}"

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
