build:
	nix build --experimental-features "nix-command flakes" ".#${HOME_MANAGER_NAME}"

switch: build
	result/activate
