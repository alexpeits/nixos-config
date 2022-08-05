{
  description = "nixos configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/2f0c3be57c348f4cfd8820f2d189e29a685d9c41";
    nixos-hardware.url = "github:nixos/nixos-hardware/3cffbd596197a99d10d8113860c9ddf5566c2ef3";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, ... }@inputs:
    let
      overlays = {
        unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        is-mac = false;
      };
    in
    {
      nixosConfigurations.seabeast = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ (_: _: overlays) ]; }
          ./configuration.nix
          nixpkgs.nixosModules.notDetected
          nixos-hardware.nixosModules.common-pc-laptop-acpi_call
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alex = import ./home/nixos.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
