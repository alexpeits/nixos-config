{ pkgs, lib, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {};

  scripts = pkgs.callPackage ../dotfiles/scripts.nix {};

in

{
  imports = [./common.nix];

  manual.manpages.enable = lib.mkForce false;
  manual.html.enable = lib.mkForce false;

  home = {
    file = {
      # ~/bin
      "bin/hm" = { text = scripts.hm; executable = true; };
    };
    packages =  with pkgs; [
      htop
      tree
      wget

      exa
      fd
      jq
      ripgrep

      tmux
      vim

      nixpkgs-unstable.niv
      nixpkgs-unstable.lorri
      nixpkgs-unstable.cachix
      nixpkgs-unstable.nix-prefetch-git
      nixpkgs-unstable.nixpkgs-fmt

      nixpkgs-unstable.ghc
      nixpkgs-unstable.cabal2nix
      nixpkgs-unstable.cabal-install
      nixpkgs-unstable.stack
      nixpkgs-unstable.haskellPackages.fast-tags
      nixpkgs-unstable.haskellPackages.hlint
      nixpkgs-unstable.haskellPackages.ghcid
      nixpkgs-unstable.haskellPackages.ormolu
    ];
  };

  programs.git = {
    userEmail = lib.mkForce "alexandros.peitsinis@fundingcircle.com";
  };

  programs.zsh = {
    initExtraBeforeCompInit = ''
      export ZSH_DISABLE_COMPFIX="true"
    '';
  };
}
