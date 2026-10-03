default:
    @just --list

# Choose the host explicitly while preparing a machine.
plan host:
    MISE_CONFIG_DIR="$PWD/mise" mise -E "{{host}}" bootstrap --dry-run --force-dotfiles

install host:
    MISE_CONFIG_DIR="$PWD/mise" mise -E "{{host}}" bootstrap --only packages,repos,tools
    MISE_CONFIG_DIR="$PWD/mise" mise -E "{{host}}" run prezto

# Uses the globally selected host after the one-time adoption in README.md.
switch:
    mise bootstrap

check:
    python3 scripts/check-migration

verify:
    mise bootstrap status --missing
    mise doctor

# Temporary fallback for machines still using Nix.
nix-check:
    just --justfile nix/justfile --working-directory . check

nix-switch:
    just --justfile nix/justfile --working-directory . switch
