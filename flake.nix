{
  description = "nixos configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/da6dc0e7b26060f2f71ce3ef7088fb56ee44fa36";
    home-manager = {
      url = "github:nix-community/home-manager/24f8f8e786f87d6a818e1746cb2389bf922afdab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.seabeast = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "home-manager-backup";
              users.alex = import ./home/nixos.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      # home-manager on a non-NixOS linux machine (debian)
      homeConfigurations.debian = home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./debian/home.nix
          {
            home = {
              username = "alex";
              homeDirectory = "/home/alex";
            };
          }
        ];
      };

      debian = self.homeConfigurations.debian.activationPackage;

      devShells.x86_64-linux.default = linuxPkgs.mkShell {
        name = "home-manager-shell";
        packages = [ home-manager.packages.x86_64-linux.home-manager ];
      };
    };
}
