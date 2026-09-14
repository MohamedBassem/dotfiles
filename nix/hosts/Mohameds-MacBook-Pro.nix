{
  config,
  ...
}:
let
  username = config.system.primaryUser;
  homeDirectory = config.users.users.${username}.home;
  secretiveSocket = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
in
{
  imports = [ ../darwin/settings.nix ];

  # Homebrew installs writable apps in /Applications, outside the Nix store.
  # Chrome and Tailscale are installed separately.
  homebrew.casks = [
    "affine"
    "android-studio"
    "bitwarden"
    "bruno"
    "discord"
    "element"
    "firefox"
    "ghostty"
    "neovide-app"
    "notion"
    "obsidian"
    "opencode-desktop"
    "orbstack"
    "raycast"
    "rectangle-pro"
    "secretive"
    "stats"
    "syncthing-app"
    "thaw"
    "visual-studio-code"
    "vlc"
    "whatsapp"
    "zed"
  ];

  home-manager.users.${username} = {
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
