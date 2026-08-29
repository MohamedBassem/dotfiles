{ config, lib, ... }:
{
  home.sessionPath = [ "$HOME/.local/bin" ];

  # The Prezto module appends its own zlogin/zlogout runcoms to these files;
  # they print a fortune and a farewell banner, so replace them outright.
  # The key comes from HM's own zsh library so it matches whatever path the
  # zsh module writes for the configured dotDir.
  home.file = {
    "${config.lib.zsh.dotDirRel}/.zlogin".text = lib.mkForce (builtins.readFile ../../zsh/login.zsh);
    "${config.lib.zsh.dotDirRel}/.zlogout".text = lib.mkForce (builtins.readFile ../../zsh/logout.zsh);
  };

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;

    envExtra = builtins.readFile ../../zsh/env.zsh;
    profileExtra = ''
      if [[ -z "$EDITOR" ]]; then
        export EDITOR=vim
      fi
      if [[ -z "$VISUAL" ]]; then
        export VISUAL=nvim
      fi

    ''
    + builtins.readFile ../../zsh/profile.zsh;
    initContent = lib.mkMerge [
      (lib.mkOrder 800 (builtins.readFile ../../zsh/init-before.zsh))
      (lib.mkOrder 1000 (builtins.readFile ../../zsh/init-after.zsh))
    ];

    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "completion"
        "history-substring-search"
        "prompt"
        "syntax-highlighting"
        "tmux"
        "git"
        "autosuggestions"
        "ssh"
      ];

      prompt = {
        theme = "sorin";
        pwdLength = "long";
      };

      tmux = {
        autoStartLocal = false;
        autoStartRemote = false;
        itermIntegration = false;
        defaultSessionName = "Default";
      };

      utility.safeOps = false;
      extraConfig = ''
        zstyle ':prezto:module:git:alias' skip 'yes'
      '';
    };
  };
}
