{ pkgs, lib, ... }:

let

  scripts = pkgs.callPackage ../dotfiles/scripts.nix {};

in

{
  imports = [./common.nix];

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

      # niv
      # cachix
      # nix-prefetch-git
      nixpkgs-fmt
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
