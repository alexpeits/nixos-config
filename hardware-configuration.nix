{ pkgs, lib, ... }:

{
  imports = [ <nixos-hardware/common/pc/laptop/acpi_call.nix> ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    opengl = {
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    pulseaudio.support32Bit = true;
  };
}
