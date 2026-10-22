{ pkgs, ... }:

let
  emacs = pkgs.emacs.pkgs.withPackages (
    epkgs: with epkgs;
    [ vterm agda2-mode ]
  );

  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      collection-fontsextra
      collection-latexextra
      ;
  };

  agda = pkgs.agda.withPackages {
    pkgs = [ pkgs.agdaPackages.standard-library ];
    ghc = pkgs.ghc.withPackages (ps: [ ps.ieee754 ]);
  };

  i3lock-wrap = pkgs.callPackage ./tools/i3lock-wrap.nix { };
  kbconfig = pkgs.callPackage ./tools/kbconfig.nix { };
  nixfmt = pkgs.nixfmt;
  trayer-wrap = pkgs.callPackage ./tools/trayer-wrap.nix { };
  xmonad-build = pkgs.callPackage ./tools/xmonad-build.nix { };
  tpacpi-bat = pkgs.callPackage ./tools/tpacpi-bat.nix { };

  obsidian = pkgs.obsidian;

  haskellPackages = pkgs.callPackage ./haskell { };

  yarn = pkgs.yarn.override { nodejs = pkgs.nodejs; };

  # dunst = pkgs.dunst.override { dunstify = true; };
  dunst = pkgs.dunst;

  packages =
    [
      emacs
      pkgs.firefox
      pkgs.cheese
      pkgs.deluge
      pkgs.dropbox
      pkgs.evince
      pkgs.eog
      pkgs.gedit
      pkgs.nautilus
      pkgs.google-chrome
      pkgs.pavucontrol
      pkgs.postman
      pkgs.spotify
      pkgs.vlc
      # pkgs.zoom-us
      pkgs.styluslabs-write-bin
      pkgs.kdePackages.wacomtablet
      pkgs.kid3
      pkgs.picard
      pkgs.musescore
      pkgs.arandr

      pkgs.qutebrowser

      pkgs.bind
      pkgs.binutils-unwrapped
      pkgs.dconf
      pkgs.docker-compose
      pkgs.entr
      pkgs.gcc
      pkgs.git
      pkgs.gnumake
      pkgs.gnupg
      pkgs.graphviz
      pkgs.htop
      pkgs.openvpn
      pkgs.pandoc
      pkgs.powertop
      pkgs.sqlite
      pkgs.tree
      pkgs.unzip
      pkgs.wget
      pkgs.xclip

      pkgs.eza
      pkgs.fd
      pkgs.jq
      pkgs.ripgrep

      pkgs.vale

      pkgs.tmux
      pkgs.vim

      dunst
      i3lock-wrap
      pkgs.acpilight
      pkgs.brightnessctl
      pkgs.feh
      pkgs.gcolor3
      pkgs.zenity
      pkgs.gsimplecal
      pkgs.libnotify
      pkgs.playerctl
      pkgs.redshift
      pkgs.rofi
      pkgs.scrot
      pkgs.trayer
      pkgs.wmctrl
      pkgs.xdotool
      pkgs.xmessage
      trayer-wrap
      tpacpi-bat
      pkgs.paper-icon-theme

      pkgs.xmobar
      xmonad-build

      pkgs.lastpass-cli
      pkgs.bitwarden-desktop
      pkgs.bitwarden-cli

      pkgs.audacity
      pkgs.lilypond

      # pkgs.scummvm

      # pkgs.python38
      # pkgs.python38Packages.black
      # pkgs.python38Packages.flake8
      # pkgs.python38Packages.ipython
      # pkgs.python38Packages.isort
      # pkgs.python38Packages.mypy

      pkgs.nodejs
      yarn

      pkgs.ocaml
      pkgs.opam

      pkgs.coq_8_12

      agda

      pkgs.tlaplusToolbox

      # pkgs.rustc
      # pkgs.cargo
      # pkgs.rustfmt
      # pkgs.clippy
      # pkgs.rustracer

      pkgs.niv
      pkgs.cachix
      pkgs.nix-prefetch-git
      pkgs.nixpkgs-fmt

      kbconfig

      # latex
      # obsidian

      # pkgs.dwarf-fortress-packages.dwarf-fortress
      # pkgs.crawlTiles
      # pkgs.brogue

      # pkgs.godot

      pkgs.steam-run
      # pkgs.steam
    ];

in

packages ++ haskellPackages
