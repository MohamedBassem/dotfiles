{ config, pkgs, ... }:
let
  username = config.system.primaryUser;
  homeDirectory = config.users.users.${username}.home;
  secretiveSocket = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  # Newer macOS releases protect /etc/pam.d behind Full Disk Access. Since
  # Touch ID and Apple Watch sudo authentication are not enabled, avoid
  # installing nix-darwin's otherwise empty sudo_local file.
  security.pam.services.sudo_local.enable = false;

  homebrew.casks = [
    "bruno"
    "claude-code"
    "codex"
    "neovide"
    "stats"
    "thaw"
  ];

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 25;
      KeyRepeat = 6;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.scaling" = 1.5;
    };

    WindowManager.HideDesktop = true;
    finder.AppleShowAllExtensions = true;
    menuExtraClock = {
      ShowDate = 0;
      ShowDayOfWeek = true;
      ShowSeconds = true;
    };
    screencapture.location = "${homeDirectory}/Screenshots/";
    trackpad.Clicking = true;
  };

  home-manager.users.${username} = {
    home.packages = [ pkgs.secretive ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*".IdentityAgent = secretiveSocket;
    };

    programs.zsh.envExtra = ''
      export SSH_AUTH_SOCK="${secretiveSocket}"
    '';
  };
}
