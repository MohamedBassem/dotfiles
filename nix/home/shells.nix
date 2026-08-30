{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  homebrewPrefix = if isDarwin then "/opt/homebrew" else "/home/linuxbrew/.linuxbrew";
  homebrewRepository = if isDarwin then homebrewPrefix else "${homebrewPrefix}/Homebrew";
  pnpmHome =
    if isDarwin then "${config.home.homeDirectory}/Library/pnpm" else "${config.xdg.dataHome}/pnpm";
  sessionPath =
    lib.optionals isDarwin [
      "${config.home.homeDirectory}/Library/Android/sdk/platform-tools"
      "${config.home.homeDirectory}/Library/Android/sdk/emulator"
      "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"
    ]
    ++ [
      "${config.home.homeDirectory}/.volta/bin"
      "${config.home.homeDirectory}/.bun/bin"
      pnpmHome
      "${config.home.homeDirectory}/bin"
      "${config.home.homeDirectory}/usr/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.pulumi/bin"
      "${config.home.homeDirectory}/repos/go/bin"
      "${config.home.homeDirectory}/repos/google-cloud-sdk/bin"
      "${config.home.homeDirectory}/.nix-profile/bin"
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/run/current-system/sw/bin"
    ]
    ++ lib.optionals isDarwin [
      "/opt/homebrew/opt/sqlite/bin"
      "${homebrewPrefix}/bin"
      "${homebrewPrefix}/sbin"
      "/usr/local/bin"
      "/usr/local/sbin"
      "/opt/local/bin"
      "/opt/local/sbin"
      "/Applications/Obsidian.app/Contents/MacOS"
      "${config.home.homeDirectory}/.orbstack/bin"
    ]
    ++ lib.optionals (!isDarwin) [
      "${homebrewPrefix}/bin"
      "${homebrewPrefix}/sbin"
    ];
in
{
  home = {
    # This is the canonical executable order for every managed shell.
    sessionPath = sessionPath;

    sessionVariables = {
      BUN_INSTALL = "${config.home.homeDirectory}/.bun";
      GOPATH = "${config.home.homeDirectory}/repos/go";
      HGEDITOR = "nvim";
      HOMEBREW_CASK_OPTS = "--require-sha";
      HOMEBREW_CELLAR = "${homebrewPrefix}/Cellar";
      HOMEBREW_NO_ANALYTICS = "1";
      HOMEBREW_NO_AUTO_UPDATE = "1";
      HOMEBREW_NO_ENV_HINTS = "1";
      HOMEBREW_NO_INSECURE_REDIRECT = "1";
      HOMEBREW_PREFIX = homebrewPrefix;
      HOMEBREW_REPOSITORY = homebrewRepository;
      PNPM_HOME = pnpmHome;
      VOLTA_HOME = "${config.home.homeDirectory}/.volta";
    };

    shellAliases = {
      l = "eza -F";
      la = "eza -a";
      ll = "eza -la --git";
      ls = "eza";
      hg = "sl";
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
      # An empty command leaves Ctrl-R unbound so Atuin can own it.
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
        (lib.mkOrder 800 ''
          # Prezto's stock zprofile prepends Homebrew. Reapply the canonical
          # Home Manager order after Prezto has loaded it.
          path=(
            ${lib.concatMapStringsSep "\n  " lib.escapeShellArg sessionPath}
            $path
          )

          ${builtins.readFile ../../zsh/init-before.zsh}
        '')
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
