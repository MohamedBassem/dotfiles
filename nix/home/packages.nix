{
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      atuin
      curl
      delta
      direnv
      eza
      fd
      fzf
      gh
      jq
      just
      lazygit
      monolith
      neovim
      pipx
      ripgrep
      rsync
      shellcheck
      tmux
      tree-sitter
      wrk
      zoxide
    ]
    # Apple's ssh supports UseKeychain and the keychain-backed agent; the
    # Nixpkgs build does not, so it must not shadow /usr/bin/ssh on macOS.
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssh ];
}
