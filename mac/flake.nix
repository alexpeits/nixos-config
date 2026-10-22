{
  description = "home-manager configuration using flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/da6dc0e7b26060f2f71ce3ef7088fb56ee44fa36";
    home-manager = {
      url = "github:nix-community/home-manager/24f8f8e786f87d6a818e1746cb2389bf922afdab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {

        macbook-home = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
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
          inherit pkgs;
          modules = [
            ../home/mac.nix
            ../home/work-extra.nix
            {
              home = {
                username = "alexpeits";
                homeDirectory = "/Users/alexpeits";
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
