{ pkgs ? import <nixpkgs> {} }:

let

  aseprite-raw = pkgs.stdenv.mkDerivation {
    name = "aseprite-raw";
    builder = ./builder.sh;
    dpkg = pkgs.dpkg;
    # replace the path to the deb file here
    src = ./aseprite.deb;
  };

in

pkgs.buildFHSUserEnv {
  name = "aseprite-fhs";
  targetPkgs = _: [ aseprite-raw ];
  multiPkgs = ps: [
    ps.dpkg
    ps.xorg.libxcb
    ps.libGL
    ps.fontconfig
    ps.xorg.libX11
    ps.xorg.libXext
    ps.xorg.libXcursor
    ps.expat.dev
  ];
  runScript = "aseprite";
}
