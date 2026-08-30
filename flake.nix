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
    inputs@{ self, nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      repoChecks =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          formatting = pkgs.runCommand "dotfiles-formatting" { nativeBuildInputs = [ pkgs.nixfmt-tree ]; } ''
            cp -R ${self} source
            chmod -R u+w source
            cd source
            ${nixpkgs.lib.getExe pkgs.nixfmt-tree} . --ci --tree-root "$PWD" --walk filesystem
            touch "$out"
          '';

          shellcheck = pkgs.runCommand "dotfiles-shellcheck" { nativeBuildInputs = [ pkgs.shellcheck ]; } ''
            shellcheck \
              ${./claude/statusline-command.sh} \
              ${./herdr-plugins/nvim-navigation/navigate.sh} \
              ${./herdr-plugins/thumbs/pick.sh} \
              ${./herdr-plugins/thumbs/picker.sh} \
              ${./scripts/sl-share-worktree} \
              ${./scripts/sl-submit-stack} \
              ${./scripts/tmux-cpu} \
              ${./scripts/tmux-paste} \
              ${./scripts/tmux-sessionizer}
            touch "$out"
          '';

          zsh-syntax = pkgs.runCommand "dotfiles-zsh-syntax" { nativeBuildInputs = [ pkgs.zsh ]; } ''
            for file in ${./zsh}/*.zsh; do
              zsh -n "$file"
            done
            touch "$out"
          '';
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              deadnix
              just
              nixfmt-tree
              shellcheck
              statix
              zsh
            ];
          };
        }
      );

      # darwin.nix and files.nix expect a `dotfilesRoot` special arg.
      homeModules = {
        common = import ./nix/home/common.nix;
        darwin = import ./nix/home/darwin.nix;
        linux = import ./nix/home/linux.nix;
      };

      lib.mkHome = import ./nix/lib/mk-home.nix { inherit inputs; };
      lib.mkDarwin = import ./nix/lib/mk-darwin.nix { inherit inputs; };

      homeConfigurations."mbassem@mbassem-workstation" = self.lib.mkHome {
        system = "x86_64-linux";
        username = "mbassem";
        modules = [
          ./nix/home/linux.nix
          ./nix/hosts/mbassem-workstation.nix
        ];
      };

      darwinConfigurations.Mohameds-Mac-mini = self.lib.mkDarwin {
        username = "mbassem";
        modules = [ ./nix/hosts/Mohameds-Mac-mini.nix ];
      };

      darwinConfigurations.Mohameds-MacBook-Pro = self.lib.mkDarwin {
        username = "mohamedbassem";
        modules = [ ./nix/hosts/Mohameds-MacBook-Pro.nix ];
      };

      # Stable, platform-local aliases consumed by `just build <device>`.
      packages.aarch64-darwin = {
        mac-mini = self.darwinConfigurations.Mohameds-Mac-mini.system;
        macbook-pro = self.darwinConfigurations.Mohameds-MacBook-Pro.system;
      };
      packages.x86_64-linux.workstation =
        self.homeConfigurations."mbassem@mbassem-workstation".activationPackage;

      checks = {
        aarch64-darwin = repoChecks "aarch64-darwin" // {
          darwin-mac-mini = self.darwinConfigurations.Mohameds-Mac-mini.system;
          darwin-macbook-pro = self.darwinConfigurations.Mohameds-MacBook-Pro.system;
        };

        aarch64-linux = repoChecks "aarch64-linux" // {
          home =
            (self.lib.mkHome {
              system = "aarch64-linux";
              username = "ci";
              dotfilesRoot = "/home/ci/repos/dotfiles";
              modules = [ ./nix/home/linux.nix ];
            }).activationPackage;
        };

        x86_64-linux = repoChecks "x86_64-linux" // {
          home = self.homeConfigurations."mbassem@mbassem-workstation".activationPackage;
        };
      };
    };
}
