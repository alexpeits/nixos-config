let

  config = { allowUnfree = true; };

  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs-unstable-mac { config=config; };
  home-manager = import sources.home-manager { inherit pkgs; };

in

pkgs.mkShell {
  name = "home-manager-shell";
  buildInputs = [
    home-manager.home-manager
  ];
  NIX_PATH =
    "nixpkgs=${sources.nixpkgs-unstable-mac}:home-manager=${sources.home-manager}";
}
