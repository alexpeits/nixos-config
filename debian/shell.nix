# for `nix-shell`; same as `nix develop`
(builtins.getFlake (toString ../.)).devShells.${builtins.currentSystem}.default
