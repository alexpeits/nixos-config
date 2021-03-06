{ pkgs, ... }:

let

  packages = pkgs.callPackage ./packages {};

in

{
  imports = [
    ./nix
    ./nix/home-manager.nix

    ./system
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/input.nix
    ./system/power.nix
    # ./system/virtualisation.nix
  ];

  environment.systemPackages = packages;
}
