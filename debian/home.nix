{ pkgs, lib, inputs, ... }:

let

  packages = pkgs.callPackage ../packages { };
  debian-manage = pkgs.callPackage ./debian-manage.nix { };

  kbconfig = pkgs.callPackage ../packages/tools/kbconfig.nix { };
  trayer-wrap = pkgs.callPackage ../packages/tools/trayer-wrap.nix { };

  nixPath = "nixpkgs=${inputs.nixpkgs}";

  xmonadInit = ''
    ${pkgs.haskellPackages.xmonad}/bin/xmonad
  '';

in

{
  imports = [ ../home/linux.nix ];

  # XDG_DATA_DIRS, terminfo, etc. for a non-NixOS distro
  targets.genericLinux.enable = true;

  home = {
    # packages = packages ++ [debian-manage];
    packages = packages;
    sessionVariables = {
      NIX_PATH = nixPath;
      MANPATH = "$HOME/.nix-profile/share/man:$MANPATH";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
    file = {
      "bin/xmonad-init".text = xmonadInit;
    };
  };

  systemd.user = {
    sessionVariables = {
      # genericLinux points this at channels; use the flake's pinned nixpkgs instead
      NIX_PATH = lib.mkForce nixPath;
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.dropbox}/bin/dropbox &
      nm-applet &
      blueman-applet &
      ${trayer-wrap}/bin/trayer-wrap &

      ${pkgs.feh}/bin/feh --bg-max ${../assets/wallpaper_blue_red.jpg}

      ${pkgs.xsetroot}/bin/xsetroot -cursor_name left_ptr
      ${pkgs.xset}/bin/xset s off
      ${pkgs.xset}/bin/xset dpms 0 0 600
    '';
    profileExtra = ''
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      elif [ -e /home/alex/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/alex/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
    windowManager.xmonad = {
      enable = true;
    };
  };
}
