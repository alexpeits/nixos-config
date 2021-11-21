{ pkgs, lib, ... }:

let

  trayer-wrap = pkgs.callPackage ../packages/tools/trayer-wrap.nix {};

in

{
  # services.gnome3.gnome-terminal-server.enable = true;
  programs.gnome-terminal.enable = true;

  services.xserver = {
    enable = true;

    displayManager = {
      gdm = {
        enable = true;
        wayland = false;
      };
      sessionCommands = ''
        ${pkgs.dropbox}/bin/dropbox &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${pkgs.blueman}/bin/blueman-applet &
        ${trayer-wrap}/bin/trayer-wrap &

        ${pkgs.feh}/bin/feh --bg-scale ${../assets/wallpaper_blue_red.jpg}
        ${pkgs.redshift}/bin/redshift -P -O 4800

        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.xorg.xset}/bin/xset dpms 0 0 600
      '';
    };
    windowManager.xmonad.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
}
