{ inputs }:
{
  username,
  homeDirectory ? "/Users/${username}",
  dotfilesRoot ? "${homeDirectory}/repos/dotfiles",
  modules ? [ ],
  homeModules ? [ ],
}:
inputs.nix-darwin.lib.darwinSystem {
  specialArgs = {
    inherit inputs dotfilesRoot;
  };

  modules = [
    inputs.home-manager.darwinModules.home-manager
    ../darwin/fonts.nix
    ../darwin/homebrew.nix
    ../darwin/system.nix
    {
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
          ]
          ++ homeModules;

          home = {
            inherit username homeDirectory;
          };
        };
      };
    }
  ]
  ++ modules;
}
