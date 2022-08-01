HERE=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
NIX_HOME_CONFIG?=mac.nix

build:
	nix-shell --run "home-manager -f ${HERE}../home/$(NIX_HOME_CONFIG) build"

switch:
	nix-shell --run 'home-manager -f ${HERE}../home/$(NIX_HOME_CONFIG) switch'

