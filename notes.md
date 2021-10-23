# myEnvFun

```nix
myGhcEnvFun = pkgs.myEnvFun {
  name = "my-ghc";
  buildInputs = with pkgs.haskellPackages; [
    (ghcWithPackages (p: with p; [ lens aeson ]))
    djinn
  ];
};
```

then

`load-env-my-ghc`

# boot menu doesn't appear

```
sudo -i
cat /sys/firmware/efi/efivars/LoaderConfigTimeout-....  # is it 0?
chattr -i /sys/firmware/efi/efivars/LoaderConfigTimeout-....
nix-shell -p efibootmgr
efibootmgr -t 5
```

# non-nixos config (debian)

- fish shell
- docker (possibly use debian package to install systemd stuff)
- blueman
- network manager (possibly installed by default)
- make sessionCommands work for xmonad session
- fonts (manually probably)
- other things written to /etc (can be symlinked to here)

check out  https://gitlab.com/NobbZ/nix-home-manager-dotfiles/

# Upgrade

[Upgrade instructions](https://nixos.org/manual/nixos/stable/index.html#sec-upgrading)

## to 20.03

- The option `services.xserver.desktopManager.xfce.extraSessionCommands'
  defined in `/home/alex/nixos-config/system/desktop.nix' has been renamed to
  `services.xserver.displayManager.sessionCommands'

## to 20.09

https://nixos.org/manual/nixos/stable/release-notes.html#sec-release-20.09-incompatibilities

- Deluge 2.x was added and is used as default for new NixOS installations where
  stateVersion is >= 20.09. If you are upgrading from a previous NixOS version,
  you can set service.deluge.package = pkgs.deluge-2_x to upgrade to Deluge 2.x
  and migrate the state to the new format. Be aware that backwards state
  migrations are not supported by Deluge.

## to 21.05

https://nixos.org/manual/nixos/stable/release-notes.html#sec-release-21.05-incompatibilities

- stdenv.lib has been deprecated and will break eval in 21.11. Please use
  pkgs.lib instead. See #108938 for details

- [X] trace: warning: The option `services.xserver.libinput.additionalOptions'
  defined in `/home/alex/nixos-config/system/input.nix' has been renamed to
  `services.xserver.libinput.touchpad.additionalOptions'.
- [X] trace: warning: The option `services.xserver.libinput.disableWhileTyping'
  defined in `/home/alex/nixos-config/system/input.nix' has been renamed to
  `services.xserver.libinput.touchpad.disableWhileTyping'.
- [X] trace: warning: The option `services.xserver.libinput.tapping' defined in
  `/home/alex/nixos-config/system/input.nix' has been renamed to
  `services.xserver.libinput.touchpad.tapping'.
- [X] trace: warning: The option `services.xserver.libinput.naturalScrolling'
  defined in `/home/alex/nixos-config/system/input.nix' has been renamed to
  `services.xserver.libinput.touchpad.naturalScrolling'.
- [X] trace: warning: The option `services.xserver.libinput.accelProfile'
  defined in `/home/alex/nixos-config/system/input.nix' has been renamed to
  `services.xserver.libinput.touchpad.accelProfile'.
- [X] trace: warning: The option `services.gnome3.gnome-keyring.enable' defined
  in `/home/alex/nixos-config/system/desktop.nix' has been renamed to
  `services.gnome.gnome-keyring.enable'.
- [X] trace: warning: Using config.services.tlp.extraConfig is deprecated and
  will become unsupported in a future release. Use config.services.tlp.settings
  instead.
- [X] fish-foreign-env has been replaced with fishPlugins.foreign-env


