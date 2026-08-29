{ pkgs, ... }:
let
  dotfilesFonts = pkgs.runCommand "dotfiles-fonts" { } ''
    mkdir -p "$out/share/fonts/truetype"
    cp ${../../fonts}/*.ttf "$out/share/fonts/truetype/"
  '';
in
{
  fonts.packages = [ dotfilesFonts ];
}
