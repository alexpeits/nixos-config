{ pkgs ? import <nixpkgs> {}, overrides ? {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "hlint";
    rev = "d853362beedb3b260da932dbdbf576dd76452cc2";
    sha256 = "061w001kzhzbvnjnqjr9y9vv2nfnwsjaaby941zlb3vdzwzlj7m5";
  };

in
pkgs.haskellPackages.callCabal2nix "hlint" src overrides
