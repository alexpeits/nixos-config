{ pkgs ? import <nixpkgs> {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "sdiehl";
    repo = "cabal-edit";
    rev = "556bf33c46b367dafaba6072bd793a25f3b88c1e";
    sha256 = "13q396bd1xkq1v8qmcqk9wryqwbxzcrxyyahvwjfd5vk8w4zl1lm";
  };

in
pkgs.haskellPackages.callCabal2nix "cabal-edit" src {}
