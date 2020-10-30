let

  sources = import ../nix/sources.nix;

  nixpkgs-src = sources.nixpkgs-unstable-mac;
  hm-src = sources.home-manager-mac;

  pkgs = import nixpkgs-src { config.allowUnfree = true; };
  home-manager = import hm-src { inherit pkgs; };

in

pkgs.mkShell {
  name = "home-manager-shell";
  buildInputs = [
    home-manager.home-manager
  ];
  NIX_PATH =
    "nixpkgs=${nixpkgs-src}:home-manager=${hm-src}";
}
