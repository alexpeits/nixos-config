{ pkgs }:

let
  version = "0.4.2";
in

pkgs.logseq.overrideAttrs (
  old: {
    version = version;
    src = pkgs.fetchurl {
      url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
      sha256 = "0yf9d83gwlipswjrj07wj3s51lr2pji48xvcw1xllzj61dqx4h04";
      name = "logseq-${version}.AppImage";
    };
  }
)
