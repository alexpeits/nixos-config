{ lib, ... }:

{
  imports = [ ./mac.nix ];

  home = {
    username = lib.mkForce "alexandros.peitsinis";
    homeDirectory = lib.mkForce "/Users/alexandros.peitsinis";
  };
}
