# non-flake alternative to the home-manager module in flake.nix (see assets/root-configuration.nix)
{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  home-manager = import sources.home-manager { inherit pkgs; };

in

{
  imports = [ home-manager.nixos ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.alex = import ../home/nixos.nix;
    backupFileExtension = "home-manager-backup";
  };
}
