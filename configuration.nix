{ pkgs, ... }:

let

  packages = pkgs.callPackage ./packages {};

in

{
  imports = [
    ./nix

    ./system
    ./system/user.nix
    ./system/desktop.nix
    ./system/fonts.nix
    ./system/input.nix
    ./system/power.nix
    ./system/networking.nix
    ./system/virtualisation.nix

    ./hardware-configuration.nix
  ];

  environment.systemPackages = packages;
}
