nix := "nix --extra-experimental-features 'nix-command flakes'"

# List available recipes
default:
    @just --list

# Show every flake output, including Linux outputs when run on macOS
show:
    {{ nix }} flake show --all-systems

# Evaluate every declared host without building or activating it
check:
    {{ nix }} flake check --all-systems --no-build

# Format Nix files with the formatter pinned by the flake
fmt:
    {{ nix }} fmt

# Build a device configuration without activating it
build device:
    {{ nix }} build "path:$PWD#{{ replace(device, "device=", "") }}" --out-link 'result-{{ replace(device, "device=", "") }}'

# Activate a nix-darwin configuration
switch-darwin configuration:
    sudo darwin-rebuild switch --flake "path:$PWD#{{ configuration }}"

# Activate a standalone Home Manager configuration
switch-home configuration:
    home-manager switch --flake "path:$PWD#{{ configuration }}"

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
