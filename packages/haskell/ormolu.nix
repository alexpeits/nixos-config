{ pkgs ? import <nixpkgs> {}, overrides ? {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "ormolu";
    rev = "913a927f398a4bfa478922d851c080281e83bc8c";
    sha256 = "0az6svwj7brcq42y238wf4d43mw5v8ykcf3kh52d009azxf8xn6f";
  };

in
pkgs.haskellPackages.callCabal2nix "ormolu" src overrides
