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
    ".gitconfig".source = outOfStore "${dotfilesRoot}/git/config";
    ".gitignore".source = outOfStore "${dotfilesRoot}/git/ignore";
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

    ".tmux.conf".source = outOfStore "${dotfilesRoot}/tmux/tmux.conf";
    ".vimrc".source = outOfStore "${dotfilesRoot}/vim/vimrc";
    ".bash_aliases".source = outOfStore "${dotfilesRoot}/bash/aliases";
    ".wezterm.lua".source = outOfStore "${dotfilesRoot}/wezterm/config.lua";

    ".config/ghostty/config".source = outOfStore "${dotfilesRoot}/ghostty/config";
    ".config/hunk/config.toml".source = outOfStore "${dotfilesRoot}/hunk/config.toml";
    ".config/herdr/config.toml".source = outOfStore "${dotfilesRoot}/herdr/config.toml";
    ".config/sapling/sapling.conf".source = outOfStore "${dotfilesRoot}/sapling/config";

    # Lazy.nvim and Claude can update these paths during normal use.
    ".config/nvim".source = outOfStore "${dotfilesRoot}/nvim";
    ".claude/settings.json".source = outOfStore "${dotfilesRoot}/claude/settings.json";
    ".claude/statusline-command.sh".source = outOfStore "${dotfilesRoot}/claude/statusline-command.sh";
  };
}
