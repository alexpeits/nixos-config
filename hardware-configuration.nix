{ pkgs, lib, ... }:

{
  imports = [ <nixos-hardware/common/pc/laptop/acpi_call.nix> ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

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

  environment.systemPackages = [ pkgs.ntfs3g ];

  # hardware = {
  #   opengl = {
  #     driSupport32Bit = true;
  #     extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  #   };
  #   pulseaudio.support32Bit = true;
  # };
}
