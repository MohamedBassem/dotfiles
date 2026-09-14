{ config, ... }:
let
  username = config.system.primaryUser;
  homeDirectory = config.users.users.${username}.home;
in
{
  # Newer macOS releases protect /etc/pam.d behind Full Disk Access. Since
  # Touch ID and Apple Watch sudo authentication are not enabled, avoid
  # installing nix-darwin's otherwise empty sudo_local file.
  security.pam.services.sudo_local.enable = false;

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
}
