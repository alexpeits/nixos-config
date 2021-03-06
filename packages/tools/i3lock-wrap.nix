{ pkgs }:

pkgs.writeScriptBin "i3lock-wrap" ''
  #!${pkgs.bash}/bin/bash

  if ${pkgs.procps}/bin/pidof i3lock; then
      echo "Already locked"
      exit 0
  else
      ${pkgs.i3lock}/bin/i3lock -n -e -f -i ${../../assets/lock.png} "$@"
  fi
''
