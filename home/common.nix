{ pkgs, lib, ... }:

let

  profile = pkgs.callPackage ../dotfiles/profile.nix {};
  colors = import ../assets/colors.nix;

  fishrc = pkgs.callPackage ../dotfiles/fishrc.nix {};

  scripts = pkgs.callPackage ../dotfiles/scripts.nix {};

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
      root = "rev-parse --show-toplevel";
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
      ".my"
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = fishrc.shellInit;
    promptInit = fishrc.promptInit;
    shellAliases = profile.aliases;
    plugins = [
      {
        name = "plugin-foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
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
