{
  description = "Mohamed Bassem's cross-platform dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      # darwin.nix and files.nix expect a `dotfilesRoot` special arg.
      homeModules = {
        common = import ./nix/home/common.nix;
        darwin = import ./nix/home/darwin.nix;
        linux = import ./nix/home/linux.nix;
      };

      lib.mkHome = import ./nix/lib/mk-home.nix { inherit inputs; };

      homeConfigurations."mbassem@mbassem-workstation" = self.lib.mkHome {
        system = "x86_64-linux";
        username = "mbassem";
        modules = [
          ./nix/home/linux.nix
          ./nix/hosts/mbassem-workstation.nix
        ];
      };

      darwinConfigurations.Mohameds-Mac-mini = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.darwinModules.home-manager
          ./nix/hosts/Mohameds-Mac-mini.nix
        ];
      };

      checks.aarch64-darwin.darwin = self.darwinConfigurations.Mohameds-Mac-mini.system;
      checks.x86_64-linux.home = self.homeConfigurations."mbassem@mbassem-workstation".activationPackage;
    };
}
