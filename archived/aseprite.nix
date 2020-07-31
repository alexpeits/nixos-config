{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  name = "aseprite";
  version = "custom";
  src = ./aseprite;
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.binutils
    pkgs.dpkg
  ];
  buildInputs = [
    pkgs.xorg.libxcb
    pkgs.libGL
    pkgs.fontconfig
    pkgs.xorg.libX11
    pkgs.xorg.libXext
    pkgs.xorg.libXcursor
    pkgs.expat
  ];
  phases = ["installPhase"];
  installPhase = ''
    mkdir -p $out/tmp
    dpkg -x $src/aseprite.deb $out/tmp
    cp -R $out/tmp/usr/* $out
    rm -rf $out/usr $out/tmp
  '';
}

