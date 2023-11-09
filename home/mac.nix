{ pkgs, lib, ... }:
let
  scripts = pkgs.callPackage ../dotfiles/scripts.nix { };
  markdownlint-cli-pkgs = pkgs.callPackage ../packages/tools/markdownlint-cli { };
  markdownlint-cli = markdownlint-cli-pkgs."markdownlint-cli-0.27.1";

in
{
  imports = [ ./common.nix ];

  # manual.manpages.enable = lib.mkForce false;
  # manual.html.enable = lib.mkForce false;

  home = {
    stateVersion = "22.05";
    file = {
      # ~/bin
      "bin/hm" = { text = scripts.hm; executable = true; };
      ".config/nix/nix.conf".source = ../dotfiles/nix.conf;
    };
    sessionVariables = {
      NIXOS_CONFIG = "$HOME/code/nixos-config";
      NIX_PATH = "nixpkgs=${pkgs.path}";
    };
    packages = with pkgs; [
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
      scc

      pandoc
      shellcheck
      # vale
      # proselint
      # yamllint
      mdl
      # asciidoctor
      # markdownlint-cli

      tmux
      vim

      niv
      # lorri
      # cachix
      nix-prefetch-git
      nixpkgs-fmt

      # dhall
      # dhall-json

      terraform

      # git-crypt

      ghc
      # cabal2nix
      cabal-install
      haskellPackages.stack
      # haskellPackages.fast-tags
      haskellPackages.hlint
      haskellPackages.ghcid
      haskellPackages.ormolu

      # coq
      # ocaml
      # opam

      # python310Packages.black
      # python310Packages.flake8
      # python310Packages.isort
      # python310Packages.mypy
    ];
  };

  programs.zsh = {
    initExtraBeforeCompInit = ''
      export ZSH_DISABLE_COMPFIX="true"
    '';
  };
}
