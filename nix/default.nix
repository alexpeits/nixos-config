{ pkgs, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
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
      "nixpkgs=${pkgs.path}"
      "nixpkgs-unstable=${pkgs.unstable.path}"
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
