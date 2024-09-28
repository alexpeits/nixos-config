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
    stateVersion = "24.05";
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
      # bash

      entr
      graphviz
      htop
      tree
      wget

      eza
      fd
      jq
      ripgrep
      scc

      blueutil

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

      # git-crypt
    ];
  };

  programs.zsh = {
    initExtraBeforeCompInit = ''
      export ZSH_DISABLE_COMPFIX="true"
    '';
  };
}
