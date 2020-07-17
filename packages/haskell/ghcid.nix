{ pkgs ? import <nixpkgs> {} }:

let

  src = pkgs.fetchFromGitHub {
    owner = "ndmitchell";
    repo = "ghcid";
    rev = "e54c1ebcec8bf4313ef04a1c5f47ecdbb6d11db3";
    sha256 = "1bs07jjj3pgwdr81w8piph6wz73n0gwj3imbnd2za0jqxbshyzry";
  };

in
pkgs.haskellPackages.callCabal2nix "ghcid" src {}
