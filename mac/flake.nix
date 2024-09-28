{
  description = "home-manager configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/a9a9e085f155b55e4a6dc49a16572b2c799ba66f";
    home-manager = {
      url = "github:nix-community/home-manager/2f23fa308a7c067e52dfcc30a0758f47043ec176";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      linuxSystem = { nixpkgs.overlays = [ (_: _: { is-mac = false; }) ]; };
      macSystem = { nixpkgs.overlays = [ (_: _: { is-mac = true; }) ]; };
    in
    {
      homeConfigurations = {

        macbook-home = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            macSystem
            ../home/mac.nix
            ../home/home-extra.nix
            # ../home/mac-extra.nix
            {
              home = {
                username = "alexpeits";
                homeDirectory = "/Users/alexpeits";
                sessionVariables.HOME_MANAGER_NAME = "macbook-home";
              };
            }
          ];
        };

        macbook-work = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            macSystem
            ../home/mac.nix
            ../home/work-extra.nix
            {
              home = {
                username = "apeitsinis";
                homeDirectory = "/Users/apeitsinis";
                sessionVariables.HOME_MANAGER_NAME = "macbook-work";
              };
            }
          ];
        };
      };

      macbook-home = self.homeConfigurations.macbook-home.activationPackage;
      macbook-work = self.homeConfigurations.macbook-work.activationPackage;
    };
}
