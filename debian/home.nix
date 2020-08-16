{ pkgs, lib, ... }:

let

  config = { allowUnfree = true; };

  sources = import ../nix/sources.nix;
  nixpkgs = import sources.channels-nixos config;
  nixpkgs-unstable = import sources.nixpkgs-unstable config;
  home-manager = import sources.home-manager config;

  packages = pkgs.callPackage ../packages {};
  debian-manage = pkgs.callPackage ./debian-manage.nix {};

  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${nixpkgs}"
    "nixpkgs-unstable=${nixpkgs-unstable}"
    "home-manager=${home-manager}"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

in

{
  imports = [ ../home.nix ];

  home = {
    packages = packages ++ [debian-manage];
    sessionVariables = {
      NIX_PATH = nixPath;
    };
  };

  systemd.user = {
    sessionVariables = {
      NIX_PATH = nixPath;
    };
  };
}
