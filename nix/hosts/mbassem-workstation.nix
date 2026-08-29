{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    btop
    dust
    hunk
    kubectl
    lnav
    lsof
    nixpacks
    serpl
    sysbench
    watchman
  ];
}
