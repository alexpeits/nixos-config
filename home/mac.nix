{ pkgs, lib, ... }:

{
  imports = [./common.nix];

  home = {
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
