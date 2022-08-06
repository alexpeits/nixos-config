{ pkgs, modulesPath, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 4;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/03228fc5-2ef8-462b-9186-d3f788d0a0bf";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/DEC1-A6BD";
      fsType = "vfat";
    };

  fileSystems."/run/media/shared" = {
    device = "/dev/disk/by-uuid/94088BC2088BA1BA";
    fsType = "ntfs-3g";
    options = [
      "auto"
      "users"
      "uid=1000"
      "gid=100"
      "dmask=027"
      "fmask=137"
      "utf8"
      "windows_names"
    ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f82da014-9e70-43ad-9c00-e6ba450214db"; }];

  environment.systemPackages = [ pkgs.ntfs3g ];
}
