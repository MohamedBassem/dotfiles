{
  config,
  lib,
  pkgs,
  ...
}:
let
  pnpmHome =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/pnpm"
    else
      "${config.xdg.dataHome}/pnpm";
in
{
  home = {
    sessionPath = [
      pnpmHome
      "$HOME/bin"
      "$HOME/usr/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.bun/bin"
      "$HOME/.volta/bin"
      "$HOME/.pulumi/bin"
      "/usr/local/go/bin"
      "$HOME/repos/go/bin"
    ];

    sessionVariables = {
      BUN_INSTALL = "${config.home.homeDirectory}/.bun";
      GOPATH = "${config.home.homeDirectory}/repos/go";
      HGEDITOR = "nvim";
      HOMEBREW_CASK_OPTS = "--require-sha";
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_AUTO_UPDATE = "1";
      HOMEBREW_NO_ENV_HINTS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      NVM_DIR = "${config.home.homeDirectory}/.nvm";
      PNPM_HOME = pnpmHome;
      VOLTA_HOME = "${config.home.homeDirectory}/.volta";
    };

    shellAliases = {
      l = "eza -F";
      la = "eza -a";
      ll = "eza -la --git";
      ls = "eza";
    };
  };

  # The Prezto module appends its own zlogin/zlogout runcoms to these files;
  # they print a fortune and a farewell banner, so replace them outright.
  home.file = {
    "${config.lib.zsh.dotDirRel}/.zlogin".text = lib.mkForce (builtins.readFile ../../zsh/login.zsh);
    "${config.lib.zsh.dotDirRel}/.zlogout".text = lib.mkForce (builtins.readFile ../../zsh/logout.zsh);
  };

  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      # Atuin recreates config.toml during normal shell use, including between
      # Home Manager's collision check and activation.
      forceOverwriteSettings = true;
      settings = {
        sync_address = "https://atuin.lab.mbassem.dev";
        enter_accept = true;
        sync.records = true;
      };
    };

    bash = {
      enable = true;
      historyControl = [ "ignoreboth" ];
      historyFileSize = 2000;
      historySize = 100000;
      shellOptions = [
        "histappend"
        "checkwinsize"
      ];
      initExtra = builtins.readFile ../../bash/bashrc;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
    };

    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --exclude .git";
      fileWidget.command = "fd --type f --hidden --exclude .git";
      historyWidget.command = "";
      colors = {
        "bg+" = "#313244";
        bg = "#1E1E2E";
        border = "#6C7086";
        fg = "#CDD6F4";
        "fg+" = "#CDD6F4";
        header = "#F38BA8";
        hl = "#F38BA8";
        "hl+" = "#F38BA8";
        info = "#CBA6F7";
        label = "#CDD6F4";
        marker = "#B4BEFE";
        pointer = "#F5E0DC";
        prompt = "#CBA6F7";
        "selected-bg" = "#45475A";
        spinner = "#F5E0DC";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      sideloadInitLua = true;
      viAlias = true;
      vimAlias = true;
    };

    zoxide.enable = true;

    zsh = {
      enable = true;
      dotDir = config.home.homeDirectory;

      profileExtra = builtins.readFile ../../zsh/profile.zsh;
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
  };
}
