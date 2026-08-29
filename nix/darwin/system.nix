{ pkgs, ... }:
{
  nix = {
    enable = true;
    package = pkgs.nixVersions.latest;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  programs.zsh.enable = true;

  # This is nix-darwin's compatibility version, not the macOS release.
  system.stateVersion = 6;
}
