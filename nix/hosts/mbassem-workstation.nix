{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    lnav
    lsof
    sysbench
    watchman
  ];
}
