build:
	nix build --experimental-features "nix-command flakes" "$(abspath $(CURDIR)/..)#debian" -o "$(CURDIR)/result"

switch: build
	"$(CURDIR)/result/activate"
