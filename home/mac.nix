{ pkgs, lib, ... }:
let
  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable-mac { };

  scripts = pkgs.callPackage ../dotfiles/scripts.nix { };

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      collection-fontsextra
      collection-latexextra
      ;
  };

  markdownlint-cli-pkgs = pkgs.callPackage ../packages/tools/markdownlint-cli {};
  markdownlint-cli = markdownlint-cli-pkgs."markdownlint-cli-0.27.1";

in
{
  imports = [ ./common.nix ];

  # manual.manpages.enable = lib.mkForce false;
  # manual.html.enable = lib.mkForce false;

  home = {
    file = {
      # ~/bin
      "bin/hm" = { text = scripts.hm; executable = true; };
    };
    sessionVariables = {
      NIXOS_CONFIG = "$HOME/code/nixos-config";
      NIX_PATH = "nixpkgs=${sources.nixpkgs-unstable}";
    };
    packages = with nixpkgs-unstable; [
      bash

      entr
      graphviz
      htop
      tree
      wget

      exa
      fd
      jq
      ripgrep

      latex
      pandoc
      shellcheck
      vale
      proselint
      yamllint
      mdl
      asciidoctor
      markdownlint-cli

      tmux
      vim

      niv
      lorri
      cachix
      nix-prefetch-git
      nixpkgs-fmt

      dhall
      dhall-json

      terraform

      git-crypt

      ghc
      cabal2nix
      cabal-install
      stack
      haskellPackages.fast-tags
      haskellPackages.hlint
      haskellPackages.ghcid
      haskellPackages.ormolu

      coq
      ocaml
      opam
    ];
  };

  programs.zsh = {
    initExtraBeforeCompInit = ''
      export ZSH_DISABLE_COMPFIX="true"
    '';
  };
}
