{
  config,
  dotfilesRoot,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    ".aerospace.toml".source = ../../aerospace/config.toml;
    "Library/Preferences/sapling/sapling.conf".source = ../../sapling/macos.conf;
  };

  home.activation.linkHerdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${lib.getExe pkgs.herdr} plugin link "${dotfilesRoot}/herdr-plugins/nvim-navigation" --enabled
    $DRY_RUN_CMD ${lib.getExe pkgs.herdr} plugin link "${dotfilesRoot}/herdr-plugins/thumbs" --enabled
  '';
}
