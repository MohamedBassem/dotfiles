{ inputs, ... }:
let
  username = "mbassem";
  homeDirectory = "/Users/${username}";
  dotfilesRoot = "${homeDirectory}/repos/dotfiles";
in
{
  imports = [
    ../darwin/fonts.nix
    ../darwin/homebrew.nix
    ../darwin/system.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = username;
  users.users.${username}.home = homeDirectory;
  homebrew.user = username;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs dotfilesRoot; };

    users.${username} = {
      imports = [
        ../home/common.nix
        ../home/darwin.nix
      ];

      home = {
        inherit username homeDirectory;
      };
    };
  };
}
