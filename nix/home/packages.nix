{
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      act
      age
      atuin
      btop
      cloudflared
      cmake
      curl
      delta
      direnv
      eza
      fd
      fzf
      gh
      git
      git-filter-repo
      go
      grpcurl
      httpie
      iperf3
      jq
      just
      lazygit
      monolith
      mosh
      neovim
      pipx
      rclone
      ripgrep
      rsync
      shellcheck
      sops
      tmux
      tree
      tree-sitter
      watch
      wget
      wrk
      yq
      zoxide
    ]
    # Apple's ssh supports UseKeychain and the keychain-backed agent; the
    # Nixpkgs build does not, so it must not shadow /usr/bin/ssh on macOS.
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssh ];
}
