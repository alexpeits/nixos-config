let

  config = { allowUnfree = true; };

  sources = import ../nix/sources.nix;
  pkgs = import sources.channels-nixos { config=config; };
  home-manager = import sources.home-manager { inherit pkgs; };

in

pkgs.mkShell {
  name = "home-manager-shell";
  buildInputs = [
    home-manager.home-manager
  ];
  NIX_PATH =
    let s = sources; in
    "nixpkgs=${s.channels-nixos}:nixpkgs-unstable=${s.nixpkgs-unstable}:home-manager=${s.home-manager}";
}
