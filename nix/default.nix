{ pkgs, ... }:

let

  sources = import ./sources.nix;

in
{

  nix = {
    # trusted users for pulling from caches
    trustedUsers = [ "root" "alex" "@wheel" "@sudo" ];
    # required for building with bazel
    nrBuildUsers = 128;

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://alexpeits.cachix.org"
      "https://alexpeits-travis.cachix.org"
    ];

    binaryCachePublicKeys = [
      "alexpeits.cachix.org-1:O5CoFuKPb8twVOp1OrfSOPfgaEo5X5xlIqGg6dMEgB4="
      "alexpeits-gh-actions.cachix.org-1:arRchgbGZe343wXGnh5AGun/3i/JwB3GuuCj8+XJ8Tg="
      "alexpeits-travis.cachix.org-1:V3Rz9GshL7QTfajKGoUpW8PwqQZSdWmjTK2f/VB1/do="
      "ghcide-nix.cachix.org-1:ibAY5FD+XWLzbLr8fxK6n8fL9zZe7jS+gYeyxyWYK5c="
    ];

    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
    ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
