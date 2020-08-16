{ ... }:

{
  # writes to /etc/X11/xorg.conf.d
  services.xserver = {
    # keyboard
    layout = "us,gr";
    xkbOptions = "caps:escape, ctrl:ralt_rctrl, grp:alt_space_toggle";
    # xfce overrides these settings
    autoRepeatDelay = 500;
    autoRepeatInterval = 45;

    # mouse
    libinput = {
      enable = true;
      tapping = false;
      disableWhileTyping = true;

      # https://github.com/NixOS/nixpkgs/issues/75007
      naturalScrolling = true;
      # natural scrolling for touchpad only, not mouse
      additionalOptions = ''
        MatchIsTouchpad "on"
      '';
    };
  };
}
