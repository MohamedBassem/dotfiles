{ inputs, dotfilesRoot, ... }:
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./files.nix
    ./packages.nix
    ./scripts.nix
    ./shells.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nh = {
    enable = true;
    flake = dotfilesRoot;
  };
}
