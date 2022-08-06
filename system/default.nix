{ pkgs, ... }:

{
  environment = {
    etc."ipsec.secrets".text = ''
      include ipsec.d/ipsec.nm-l2tp.secrets
    '';
    etc."opt/chrome/policies/managed/external_protocol_dialog.json".text = ''
      {"ExternalProtocolDialogShowAlwaysOpenCheckbox": true}
    '';
    etc."default/google-chrome".text = ''
      repo_add_once=false
    '';
    etc.hosts.mode = "0644";
  };

  boot = {
    supportedFilesystems = [ "ntfs" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices = {
      root = {
        device = "/dev/sda6";
        preLVM = true;
      };
    };
  };

  programs.fish.enable = true; # to add entry in /etc/shells

  time.timeZone = "Europe/London";

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.devmon.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.hplip
  ];

  # limit the amount of logs stored in /var/log/journal
  # writes to: /etc/systemd/journald.conf
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  # to prevent nix-shell complaining about no space left
  # default value is 10% of total RAM
  # writes to: /etc/systemd/logind.conf
  services.logind.extraConfig = ''
    RuntimeDirectorySize=4G
  '';

}
