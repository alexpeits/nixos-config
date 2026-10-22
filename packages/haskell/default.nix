{ pkgs, ... }:

let
  ghc = pkgs.callPackage ./ghc.nix { };
in

[
  pkgs.cabal2nix
  pkgs.cabal-install
  pkgs.stack

  # pkgs.haskellPackages.brittany
  # pkgs.haskellPackages.cabal-edit
  pkgs.haskellPackages.fast-tags
  pkgs.haskellPackages.hlint
  pkgs.haskellPackages.ghcid.bin
  pkgs.haskellPackages.ormolu.bin

  # ghc.ghc910
  # ghc.ghc910Symlinks
]
