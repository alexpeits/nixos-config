{
  description = "home-manager configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=67f49b2a3854e8b5e3f9df4422225daa0985f451";
    home-manager = {
      url = "github:nix-community/home-manager?rev=d1c677ac257affed8d026f418b81ed5de2c8d963";
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
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          modules = [
            macSystem
            ../home/mac.nix
            {
              home = {
                username = "alexandros.peitsinis";
                homeDirectory = "/Users/alexandros.peitsinis";
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
