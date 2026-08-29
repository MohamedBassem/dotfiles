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

# Build the Mac configuration without activating it
build-mac:
    {{ nix }} build '.#darwinConfigurations.Mohameds-Mac-mini.system' --out-link result-mac

# Build the Debian workstation configuration without activating it
build-linux:
    {{ nix }} build '.#homeConfigurations."mbassem@mbassem-workstation".activationPackage' --out-link result-linux

# Activate the Mac configuration
switch-mac:
    sudo darwin-rebuild switch --flake '.#Mohameds-Mac-mini'

# Activate the Debian workstation configuration after its first bootstrap
switch-linux:
    home-manager switch --flake '.#mbassem@mbassem-workstation'

# Update every pinned input; review flake.lock and build both hosts afterward
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
