{ pkgs, ... }:

let

  sources = import ../../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};

  hsLib = import ./lib.nix;

  ghc-lib-parser-ex-8-10-0-15 = hsLib.fetchFromHackage {
    pkgs = nixpkgs-unstable;
    name = "ghc-lib-parser-ex";
    version = "8.10.0.15";
    sha256 = "0ll8zcby70zz1x0i7cskfxkl48mfaw303a3rsz7j62i4h3kq7xzj";
  };

  brittany = pkgs.callPackage ./brittany.nix {};
  fast-tags = pkgs.callPackage ./fast-tags.nix {};
  hlint = pkgs.callPackage ./hlint.nix {
    pkgs = nixpkgs-unstable;
    overrides = {
      ghc-lib-parser-ex = ghc-lib-parser-ex-8-10-0-15;
    };
  };
  ghcid = pkgs.callPackage ./ghcid.nix {
    pkgs = nixpkgs-unstable;
  };
  ormolu = pkgs.callPackage ./ormolu.nix {
    pkgs = nixpkgs-unstable;
  };
  cabal-edit = pkgs.callPackage ./cabal-edit.nix {
    pkgs = nixpkgs-unstable;
  };

  ghc = pkgs.callPackage ./ghc.nix {};

in

[
  pkgs.cabal2nix
  pkgs.cabal-install
  pkgs.stack

  # brittany
  # fast-tags
  # hlint
  # ghcid
  # ormolu
  # cabal-edit
  nixpkgs-unstable.haskellPackages.fast-tags
  nixpkgs-unstable.haskellPackages.hlint
  nixpkgs-unstable.haskellPackages.ghcid
  nixpkgs-unstable.haskellPackages.ormolu
  # nixpkgs-unstable.haskellPackages.cabal-edit

  # ghc.ghc865
  # ghc.ghc865Symlinks
  # ghc.ghc881
  ghc.ghc8104
  ghc.ghc8104Symlinks
]
