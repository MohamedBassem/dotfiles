{
  config,
  dotfilesRoot,
  pkgs,
  ...
}:
let
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.file = {
    ".gitconfig".source = ../../git/config;
    ".gitignore".source = ../../git/ignore;
    ".gitconfig.local".text =
      if pkgs.stdenv.hostPlatform.isDarwin then
        ''
          [credential]
            helper = osxkeychain
        ''
      else
        ''
          [credential]
            helper = cache
        '';

    ".tmux.conf".source = ../../tmux/tmux.conf;
    ".vimrc".source = ../../vim/vimrc;
    ".bash_aliases".source = ../../bash/aliases;
    ".wezterm.lua".source = ../../wezterm/config.lua;

    ".config/ghostty/config".source = ../../ghostty/config;
    ".config/hunk/config.toml".source = ../../hunk/config.toml;
    ".config/herdr/config.toml".source = ../../herdr/config.toml;
    ".config/sapling/sapling.conf".source = ../../sapling/config;

    # Lazy.nvim and Claude can update these paths during normal use.
    ".config/nvim".source = outOfStore "${dotfilesRoot}/nvim";
    ".claude/settings.json".source = outOfStore "${dotfilesRoot}/claude/settings.json";
    ".claude/statusline-command.sh" = {
      source = ../../claude/statusline-command.sh;
      executable = true;
    };
  };
}
