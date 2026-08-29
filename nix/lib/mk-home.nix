{ inputs }:
{
  system,
  username,
  homeDirectory ? "/home/${username}",
  dotfilesRoot ? "${homeDirectory}/repos/dotfiles",
  modules ? [ ],
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfreePredicate = pkg: inputs.nixpkgs.lib.getName pkg == "obsidian-headless";
  };

  extraSpecialArgs = {
    inherit inputs dotfilesRoot;
  };

  modules = [
    ../home/common.nix
    {
      home = {
        inherit username homeDirectory;
      };
    }
  ]
  ++ modules;
}
