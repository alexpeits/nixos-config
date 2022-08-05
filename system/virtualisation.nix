{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    # virtualbox = {
    #   host = {
    #     enable = true;
    #     addNetworkInterface = true;
    #   };
    #   guest = {
    #     enable = true;
    #     x11 = true;
    #   };
    # };
  };
}
