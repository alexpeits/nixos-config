{ pkgs, lib, ... }:

let

  config = { allowUnfree = true; };

  sources = import ../nix/sources.nix;
  nixpkgs = sources.channels-nixos;
  nixpkgs-unstable = sources.nixpkgs-unstable;
  home-manager = sources.home-manager;

  packages = pkgs.callPackage ../packages {};
  debian-manage = pkgs.callPackage ./debian-manage.nix {};

  kbconfig = pkgs.callPackage ../packages/tools/kbconfig.nix {};
  trayer-wrap = pkgs.callPackage ../packages/tools/trayer-wrap.nix {};

  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${nixpkgs}"
    "nixpkgs-unstable=${nixpkgs-unstable}"
    "home-manager=${home-manager}"
  ];

  xmonadInit = ''
    ${pkgs.haskellPackages.xmonad}/bin/xmonad
  '';

in

{
  imports = [ ../home.nix ];

  nixpkgs.config = { allowUnfree = true; };

  home = {
    # packages = packages ++ [debian-manage];
    packages = packages;
    sessionVariables = {
      NIX_PATH = nixPath;
      PATH = "$HOME/bin:$PATH";
      XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS";
      MANPATH="$HOME/.nix-profile/etc/share/man:$MANPATH";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
    file = {
      "bin/xmonad-init".text = xmonadInit;
    };
  };

  systemd.user = {
    sessionVariables = {
      NIX_PATH = nixPath;
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.dropbox}/bin/dropbox &
      nm-applet &
      blueman-applet &
      ${trayer-wrap}/bin/trayer-wrap &

      ${pkgs.feh}/bin/feh --bg-max ${../assets/wallpaper.png}

      ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
      ${pkgs.xorg.xset}/bin/xset s off
      ${pkgs.xorg.xset}/bin/xset dpms 0 0 600
    '';
    profileExtra = ''
      if [ -e /home/alex/.nix-profile/etc/profile.d/nix.sh ]; then
        . /home/alex/.nix-profile/etc/profile.d/nix.sh
      fi
    '';
    windowManager.xmonad = {
      enable = true;
    };
  };
}
