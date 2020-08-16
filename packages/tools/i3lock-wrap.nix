{ pkgs }:

let

  os =
    builtins.elemAt
      (builtins.match "NAME=\"([a-zA-Z]*)\".*" (builtins.readFile /etc/os-release))
      0;

  nixos = pkgs.lib.toLower os == "nixos";

  i3lock =
    if nixos
    then "${pkgs.i3lock}/bin/i3lock"
    else "i3lock";

in

pkgs.writeScriptBin "i3lock-wrap" ''
  #!${pkgs.bash}/bin/bash

  if ${pkgs.procps}/bin/pidof i3lock; then
      echo "Already locked"
      exit 0
  else
      ${i3lock} -n -e -f -i ${../../assets/lock.png} "$@"
  fi
''
