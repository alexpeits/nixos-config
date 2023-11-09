# Stuff here takes long to install
{ pkgs, lib, ... }:
let
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      collection-fontsextra
      collection-latexextra
      ;
  };

in
{
  home = {
    packages = with pkgs; [
      latex
    ];
  };
}
