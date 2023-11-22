{ pkgs, lib, ... }:

let

  kbconfig = pkgs.callPackage ../packages/tools/kbconfig.nix { };
  scripts = pkgs.callPackage ../dotfiles/scripts.nix { };

in

{
  imports = [ ./common.nix ];

  home = {
    stateVersion = "21.05";
    file = {
      # ~/bin
      "bin/em" = { text = scripts.em; executable = true; };
      "bin/magit" = { text = scripts.magit; executable = true; };

      # others
      ".latexmkrc".text = ''$pdf_previewer = "start evince";'';
    };
    sessionVariables = {
      NIXOS_CONFIG = "$HOME/nixos-config";
    };
    packages = with pkgs; [
      entr
      htop
      wget

      exa
      fd
      jq
      ripgrep
      scc

      pandoc
      shellcheck
      mdl

      tmux
      vim
      emacs

      nix-prefetch-git
      nixpkgs-fmt
    ];
  };

  systemd.user.services = {
    keyboard = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        Description = "Keyboard";
        After = "graphical-session-pre.target";
      };
      Service = {
        Type = "simple";
        ExecStart = "${kbconfig}/bin/kbconfig --ctrl-esc-fg";
        RemainAfterExit = "no";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/org-protocol" = "org-protocol.desktop";
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "audio/mpeg" = "vlc.desktop";
    };
  };

  programs.rofi = {
    enable = true;
    theme = "lb";
    font = "Iosevka Term 13";
    terminal = "gnome-terminal";
    extraConfig = {
      matching = "fuzzy";
      show-icons = true;
      kb-mode-next = "Alt+m";
      sort = true;
      sorting-method = "fzf";
    };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    themeVariant = "dark";
    profile =
      let
        mkFont = { name, size }: "${name} ${builtins.toString size}";
        smallFont = mkFont {
          name = "Source Code Pro Medium";
          size = 10.5;
        };
        largeFont = mkFont {
          name = "Source Code Pro Medium";
          size = 13;
        };
        dark = {
          default = false;
          visibleName = "Dark";
          showScrollbar = false;
          font = smallFont;
          colors = {
            foregroundColor = "#d2e9eb";
            backgroundColor = "#0a0a0a";
            boldColor = null;
            highlight = {
              background = "#88c0d0";
              foreground = "#0a0a0a";
            };
            palette = [
              "#404040"
              "#ff8059"
              "#44bc44"
              "#eecc00"
              "#33beff"
              "#f78fe7"
              "#00d3d0"
              "#d0d0d0"
              "#707070"
              "#ff8059"
              "#44bc44"
              "#eecc00"
              "#33beff"
              "#f78fe7"
              "#00d3d0"
              "#e0e0e0"
            ];
          };
        };
      in
      {
        "a5914944-7bfe-4e88-8699-695bf6ce9f2c" = dark // { default = true; };
        "cd0124dc-173f-430a-a5f0-4eb1847845f4" = dark // {
          visibleName = dark.visibleName + " large";
          font = largeFont;
        };
      };
  };
}
