{
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  scriptText = path: lib.removePrefix "#!/usr/bin/env bash\n" (builtins.readFile path);
  writeScript =
    name: path: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = scriptText path;
    };

  saplingRuntime = lib.optionals (!isDarwin) [ pkgs.sapling ];
in
{
  home.packages = [
    (writeScript "sl-share-worktree" ../../scripts/sl-share-worktree (
      [ pkgs.coreutils ] ++ saplingRuntime
    ))
    (writeScript "sl-submit-stack" ../../scripts/sl-submit-stack ([ pkgs.gh ] ++ saplingRuntime))
    (writeScript "tmux-cpu" ../../scripts/tmux-cpu [
      pkgs.coreutils
      pkgs.gawk
    ])
    (writeScript "tmux-paste" ../../scripts/tmux-paste (
      lib.optionals (!isDarwin) [
        pkgs.wl-clipboard
        pkgs.xclip
        pkgs.xsel
      ]
    ))
    (writeScript "tmux-sessionizer" ../../scripts/tmux-sessionizer (
      [
        pkgs.coreutils
        pkgs.fzf
        pkgs.gnugrep
        pkgs.neovim
        pkgs.tmux
      ]
      ++ lib.optionals (!isDarwin) [ pkgs.procps ]
    ))
  ];
}
