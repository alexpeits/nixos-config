{ pkgs, ... }:

let

  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable { config.allowUnfree = true; };

  # TODO: build emacs with a pinned nixpkgs
  emacs = nixpkgs-unstable.emacs27WithPackages (
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

  agda = nixpkgs-unstable.agda.withPackages {
    pkgs = [ nixpkgs-unstable.agdaPackages.standard-library ];
    ghc = nixpkgs-unstable.ghc.withPackages (ps: [ ps.ieee754 ]);
  };

  i3lock-wrap = pkgs.callPackage ./tools/i3lock-wrap.nix {};
  kbconfig = pkgs.callPackage ./tools/kbconfig.nix {};
  nixfmt = pkgs.callPackage ./tools/nixfmt.nix {};
  patat = pkgs.callPackage ./tools/patat.nix {};
  trayer-wrap = pkgs.callPackage ./tools/trayer-wrap.nix {};
  xmonad-build = pkgs.callPackage ./tools/xmonad-build.nix {};
  vale = pkgs.callPackage ./tools/vale.nix {};
  tpacpi-bat = pkgs.callPackages ./tools/tpacpi-bat.nix {};

  obsidian = pkgs.callPackage ./apps/obsidian.nix {};

  haskellPackages = pkgs.callPackage ./haskell {};

  yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; };

  dunst = pkgs.dunst.override { dunstify = true; };

  packages =
    [
      emacs
      pkgs.firefox
      pkgs.gnome3.cheese
      pkgs.deluge
      nixpkgs-unstable.dropbox
      pkgs.evince
      pkgs.gnome3.eog
      pkgs.gnome3.gedit
      pkgs.gnome3.nautilus
      pkgs.google-chrome
      pkgs.pavucontrol
      pkgs.postman
      pkgs.spotify
      pkgs.vlc
      # nixpkgs-unstable.zoom-us
      nixpkgs-unstable.write_stylus
      pkgs.wacomtablet
      pkgs.kid3
      pkgs.picard
      nixpkgs-unstable.musescore
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

      pkgs.bat
      pkgs.direnv
      pkgs.exa
      pkgs.fd
      pkgs.fzf
      pkgs.jq
      pkgs.ripgrep

      vale

      nixpkgs-unstable.tmate
      pkgs.tmux
      pkgs.vim

      dunst
      i3lock-wrap
      pkgs.acpilight
      pkgs.brightnessctl
      pkgs.feh
      pkgs.gcolor3
      pkgs.gnome3.zenity
      pkgs.gsimplecal
      pkgs.libnotify
      pkgs.playerctl
      pkgs.redshift
      pkgs.rofi
      pkgs.scrot
      pkgs.trayer
      pkgs.wmctrl
      pkgs.xdotool
      pkgs.xorg.xmessage
      trayer-wrap
      tpacpi-bat
      pkgs.paper-icon-theme

      nixpkgs-unstable.xmobar
      xmonad-build

      pkgs.lastpass-cli
      pkgs.bitwarden
      pkgs.bitwarden-cli

      pkgs.audacity
      nixpkgs-unstable.lilypond
      # nixpkgs-unstable.musescore

      # pkgs.scummvm

      pkgs.python37
      pkgs.python37Packages.black
      pkgs.python37Packages.flake8
      pkgs.python37Packages.ipython
      pkgs.python37Packages.isort
      pkgs.python37Packages.mypy

      pkgs.nodejs-12_x
      yarn

      pkgs.ocaml
      pkgs.opam

      pkgs.coq

      agda

      # pkgs.tlaplusToolbox

      # nixpkgs-unstable.rustc
      # nixpkgs-unstable.cargo
      # nixpkgs-unstable.rustfmt
      # nixpkgs-unstable.clippy
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

      # nixpkgs-unstable.godot

      pkgs.steam-run
      # pkgs.steam
    ];

in

packages ++ haskellPackages
