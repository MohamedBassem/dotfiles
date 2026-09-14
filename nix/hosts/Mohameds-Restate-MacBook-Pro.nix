_: {
  imports = [ ../darwin/settings.nix ];

  # Preserve pre-existing files when adopting them into Home Manager.
  home-manager.backupFileExtension = "before-home-manager";
}
