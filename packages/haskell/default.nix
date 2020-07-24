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
  # not used
  ghc-lib-parser-8-10 = hsLib.fetchFromHackage {
    name = "ghc-lib-parser";
    version = "8.10.1.20200523";
    sha256 = "1fnhqb9l0cg58lalrrn4ms48rnnzlyb7dqa9h2g21m9287q5y6gs";
  };
  ghc-lib-parser-ex = hsLib.fetchFromHackage {
    name = "ghc-lib-parser-ex";
    version = "8.8.2";
    sha256 = "0ff1rb53wmbkbdral725brs0wg2bg4x2bb2klfwa2cqix1qi68lv";
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
  fast-tags
  hlint
  ghcid
  ormolu
  cabal-edit

  ghc.ghc865
  ghc.ghc881
  ghc.ghc865Symlinks
]
