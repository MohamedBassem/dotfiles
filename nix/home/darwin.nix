{
  config,
  dotfilesRoot,
  lib,
  ...
}:
{
  home.file = {
    ".aerospace.toml".source = ../../aerospace/.aerospace.toml;
    "Library/Preferences/sapling/sapling.conf".source =
      ../../sapling/Library/Preferences/sapling/sapling.conf;
  };

  home.activation.linkHerdrPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    herdr_bin=""
    if [ -x /opt/homebrew/bin/herdr ]; then
      herdr_bin=/opt/homebrew/bin/herdr
    elif command -v herdr >/dev/null 2>&1; then
      herdr_bin="$(command -v herdr)"
    fi

    if [ -n "$herdr_bin" ]; then
      $DRY_RUN_CMD "$herdr_bin" plugin link "${dotfilesRoot}/herdr-plugins/nvim-navigation" --enabled
      $DRY_RUN_CMD "$herdr_bin" plugin link "${dotfilesRoot}/herdr-plugins/thumbs" --enabled
    fi
  '';
}
