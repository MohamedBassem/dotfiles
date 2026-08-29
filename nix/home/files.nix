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
    ".gitconfig".source = ../../git/.gitconfig;
    ".gitignore".source = ../../git/.gitignore;
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

    ".tmux.conf".source = ../../tmux/.tmux.conf;
    ".vimrc".source = ../../vim/.vimrc;
    ".bashrc".source = ../../bash/.bashrc;
    ".bash_aliases".source = ../../bash/.bash_aliases;
    ".wezterm.lua".source = ../../wezterm/.wezterm.lua;

    ".config/ghostty/config".source = ../../ghostty/.config/ghostty/config;
    ".config/hunk/config.toml".source = ../../hunk/.config/hunk/config.toml;
    ".config/herdr/config.toml".source = ../../herdr/.config/herdr/config.toml;
    ".config/sapling/sapling.conf".source = ../../sapling/.config/sapling/sapling.conf;

    # Lazy.nvim and Claude can update these paths during normal use.
    ".config/nvim".source = outOfStore "${dotfilesRoot}/nvim/.config/nvim";
    ".claude/settings.json".source = outOfStore "${dotfilesRoot}/claude/.claude/settings.json";
    ".claude/statusline-command.sh" = {
      source = ../../claude/.claude/statusline-command.sh;
      executable = true;
    };

    ".local/bin/sl-share-worktree" = {
      source = ../../scripts/.local/bin/sl-share-worktree;
      executable = true;
    };
    ".local/bin/sl-submit-stack" = {
      source = ../../scripts/.local/bin/sl-submit-stack;
      executable = true;
    };
    ".local/bin/tmux-cpu" = {
      source = ../../scripts/.local/bin/tmux-cpu;
      executable = true;
    };
    ".local/bin/tmux-paste" = {
      source = ../../scripts/.local/bin/tmux-paste;
      executable = true;
    };
    ".local/bin/tmux-sessionizer" = {
      source = ../../scripts/.local/bin/tmux-sessionizer;
      executable = true;
    };
  };
}
