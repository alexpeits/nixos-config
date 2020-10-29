{ pkgs, lib, ... }:

let

  profile = pkgs.callPackage ../dotfiles/profile.nix {};
  colors = import ../assets/colors.nix;

  kbconfig = pkgs.callPackage ../packages/tools/kbconfig.nix {};
  fishrc = pkgs.callPackage ../dotfiles/fishrc.nix {};

  scripts = pkgs.callPackage ../dotfiles/scripts.nix {};
  autostart = pkgs.callPackage ../dotfiles/autostart.nix {};

  i3lock-wrap = pkgs.callPackage ../packages/tools/i3lock-wrap.nix {};
  lock-cmd = "${i3lock-wrap}/bin/i3lock-wrap";

in

{
  # home-manager manual
  manual.manpages.enable = true;
  manual.html.enable = true;

  home = {
    file = {
      # vim
      ".vimrc".text = pkgs.callPackage ../dotfiles/vimrc.nix {};

      # tmux & tmate
      ".tmux.conf".text = pkgs.callPackage ../dotfiles/tmux-conf.nix { tmate = false; };
      ".tmate.conf".text = pkgs.callPackage ../dotfiles/tmux-conf.nix { tmate = true; };

      # ~/bin
      "bin/cookie" = { text = scripts.cookie; executable = true; };
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # others
      ".ghci".source = ../dotfiles/ghci;
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
      EDITOR = "vim";
      LESS = "-r";
    };
  };

  programs.git = {
    enable = true;
    userName = "Alexandros Peitsinis";
    userEmail = "alexpeitsinis@gmail.com";
    aliases = {
      ls = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'';
      lr = ''log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'';
      ll = "log --graph --decorate --pretty=oneline --abbrev-commit";
      ld = ''log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
      lla = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      c = "commit --verbose";
      a = "add -A";
      pr = ''!git pull --rebase "$(git rev-parse --abbrev-ref HEAD)"'';
      fl = "log -u";
      count = "shortlog -s -n --all";
      squash = "rebase -i HEAD^^";
      delremote = "push origin --delete";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      core = {
        editor = "vim";
      };
      credential.helper = "store";
    };
    ignores = [
      ".projectile"
      ".dir-locals.el"
      "*.swp"
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = fishrc.shellInit;
    promptInit = fishrc.promptInit;
    shellAliases = profile.aliases;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    shellOptions = [
      "histappend"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    shellAliases = profile.aliases;
    initExtra = pkgs.callPackage ../dotfiles/bashrc.nix {};
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = false;
    enableCompletion = true;
    history = {
      size = 50000;
      save = 500000;
      ignoreDups = true;
      share = true;
    };
    initExtra = pkgs.callPackage ../dotfiles/zshrc.nix {};
    shellAliases = profile.aliases;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "header,grid";
    };
  };
}
