# Stuff here takes long to install
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    terraform

    ghc
    # cabal2nix
    cabal-install
    haskellPackages.stack
    # haskellPackages.fast-tags
    haskellPackages.hlint
    haskellPackages.ghcid
    haskellPackages.ormolu

    # dhall
    # dhall-json

    # coq
    # ocaml
    # opam

    # python310Packages.black
    # python310Packages.flake8
    # python310Packages.isort
    # python310Packages.mypy
  ];
}
