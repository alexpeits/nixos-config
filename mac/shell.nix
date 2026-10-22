# for `nix-shell`; same as `nix develop ./mac`
(builtins.getFlake (toString ./.)).devShells.${builtins.currentSystem}.default
