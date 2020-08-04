{ pkgs, lib, ... }:

let

  trayer-wrap = pkgs.callPackage ../packages/tools/trayer-wrap.nix {};

in

{
  # services.gnome3.gnome-terminal-server.enable = true;
  programs.gnome-terminal.enable = true;

  services.xserver = {
    enable = true;

    # writes to /etc/X11/xorg.conf.d
    libinput = {
      enable = true;
      tapping = false;
      disableWhileTyping = true;

      # https://github.com/NixOS/nixpkgs/issues/75007
      naturalScrolling = true;
      # natural scrolling for touchpad only, not mouse
      additionalOptions = ''
        MatchIsTouchpad "on"
      '';
    };

    displayManager = {
      gdm = {
        enable = true;
        wayland = false;
      };
      sddm.enable = lib.mkForce false;
      # defaultSession = "none+xmonad";
      sessionCommands = ''
        ${pkgs.dropbox}/bin/dropbox &
        ${pkgs.networkmanagerapplet}/bin/nm-applet &
        ${pkgs.blueman}/bin/blueman-applet &
        ${trayer-wrap}/bin/trayer-wrap &

        ${pkgs.feh}/bin/feh --bg-max ${../assets/wallpaper.png}

        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xorg.xset}/bin/xset s off
        ${pkgs.xorg.xset}/bin/xset dpms 0 0 600
      '';
    };

    desktopManager = {
      plasma5.enable = lib.mkForce false;
      # xfce = {
      # enable = true;
      # noDesktop = false;
      # enableXfwm = false;
      # };
    };

    windowManager = {
      xmonad = {
        enable = true;
      };
    };
  };

  services.gnome3.gnome-keyring.enable = true;

  environment.systemPackages =
    [
      pkgs.xfce.dconf
      pkgs.xfce.xfconf
      pkgs.xfce.xfce4-battery-plugin
      pkgs.xfce.xfce4-xkb-plugin
      pkgs.xfce.xfce4-systemload-plugin
      pkgs.xfce.xfce4-cpugraph-plugin
    ];

}
