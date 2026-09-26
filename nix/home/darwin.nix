{
  config,
  dotfilesRoot,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    ".aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/aerospace/config.toml";
    "Library/Preferences/sapling/sapling.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/sapling/macos.conf";
  };

  home.activation.linkHerdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${lib.getExe pkgs.herdr} plugin link "${dotfilesRoot}/herdr-plugins/nvim-navigation" --enabled
    $DRY_RUN_CMD ${lib.getExe pkgs.herdr} plugin link "${dotfilesRoot}/herdr-plugins/thumbs" --enabled
  '';
}
