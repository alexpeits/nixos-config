let

  config = { allowUnfree = true; };

  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs-unstable { config=config; };
  home-manager = import sources.home-manager { inherit pkgs; };

in

pkgs.mkShell {
  name = "home-manager-shell";
  buildInputs = [
    home-manager.home-manager
  ];
  NIX_PATH =
    let s = sources; in
    "nixpkgs=${s.nixpkgs-unstable}:nixpkgs-unstable=${s.nixpkgs-unstable}:home-manager=${s.home-manager}";
}
