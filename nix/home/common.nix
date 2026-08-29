{ ... }:
{
  imports = [
    ./files.nix
    ./packages.nix
    ./scripts.nix
    ./shells.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
