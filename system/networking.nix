{ ... }:

{
  networking = {
    hostName = "seabeast";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    networkmanager.enable = true;
    # networking.firewall.allowedTCPPorts = [ 80 ];
    # networking.extraHosts = ''1.2.3.4 whatever'';
  };
}
