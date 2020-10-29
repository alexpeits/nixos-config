HERE=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	nix-shell --run "home-manager -f ${HERE}../home/mac.nix build"

switch:
	nix-shell --run 'home-manager -f ${HERE}../home/mac.nix switch'

