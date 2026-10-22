# /etc/nixos/configuration.nix for rebuilding without flakes (`nixos-rebuild switch`).
# Prefer `nixos-rebuild switch --flake ~/nixos-config#seabeast` (see README).
#
# The repo's configuration.nix already imports its own hardware-configuration.nix,
# so don't also import the one generated in /etc/nixos.

{ ... }:

{
  imports = [
    /home/alex/nixos-config/configuration.nix
    /home/alex/nixos-config/nix/home-manager.nix
  ];
}
