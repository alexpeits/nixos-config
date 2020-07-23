{ pkgs, ... }:

{
  virtualisation.virtualbox = {
    host = {
      enable = true;
      addNetworkInterface = true;
    };
    guest = {
      enable = true;
      x11 = true;
    };
  };
}
