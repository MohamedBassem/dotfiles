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
    ".bashrc".source = ../../bash/bashrc;
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

    ".local/bin/sl-share-worktree" = {
      source = ../../scripts/sl-share-worktree;
      executable = true;
    };
    ".local/bin/sl-submit-stack" = {
      source = ../../scripts/sl-submit-stack;
      executable = true;
    };
    ".local/bin/tmux-cpu" = {
      source = ../../scripts/tmux-cpu;
      executable = true;
    };
    ".local/bin/tmux-paste" = {
      source = ../../scripts/tmux-paste;
      executable = true;
    };
    ".local/bin/tmux-sessionizer" = {
      source = ../../scripts/tmux-sessionizer;
      executable = true;
    };
  };
}
