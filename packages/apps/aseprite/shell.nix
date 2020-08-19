{ pkgs ? import <nixpkgs> {} }:

let

  aseprite = import ./default.nix {pkgs = pkgs;};

in

pkgs.mkShell {
  name = "aseprite-shell";
  buildInputs = [ aseprite ];
}
