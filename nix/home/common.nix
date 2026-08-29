{ ... }:
{
  imports = [
    ./files.nix
    ./packages.nix
    ./shells.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
