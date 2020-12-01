{ pkgs, lib, ... }:
let
  is-mac = (pkgs.callPackage ../nix/lib.nix { }).is-mac;

  profile = pkgs.callPackage ../dotfiles/profile.nix { };
  colors = import ../assets/colors.nix;

  kbconfig = pkgs.callPackage ../packages/tools/kbconfig.nix { };
  fishrc = pkgs.callPackage ../dotfiles/fishrc.nix { };

  scripts = pkgs.callPackage ../dotfiles/scripts.nix { };
  autostart = pkgs.callPackage ../dotfiles/autostart.nix { };

  i3lock-wrap = pkgs.callPackage ../packages/tools/i3lock-wrap.nix { };
  lock-cmd = "${i3lock-wrap}/bin/i3lock-wrap";

in
{
  # home-manager manual
  manual.manpages.enable = true;
  manual.html.enable = true;

  home = {
    file = {
      # vim
      ".vimrc".text = pkgs.callPackage ../dotfiles/vimrc.nix { };

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
      EXA_COLORS = "uu=0;36:gu=0;36:da=0;37";
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
      ".my/"
      ".\\#*"
      "*~"
      "*.swp"
      "*.swo"
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
      {
        name = "nvm.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "nvm.fish";
          rev = "5c9bae23b0d71fb4f70bc0403ad42fa19bc506bf";
          sha256 = "19kqsf36znqn30jl9i244qchxkn04jgnqlscsr9gkpbwqw6ax002";
        };
      }
    ];
  };

  programs.bash =
    let linuxOnlyOpts = ["globstar" "checkjobs"];
    in
    {
      enable = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      shellOptions = [
        "histappend"
        "extglob"
      ] ++ (if is-mac then [] else linuxOnlyOpts);
      shellAliases = profile.aliases;
      initExtra = pkgs.callPackage ../dotfiles/bashrc.nix { };
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
    initExtra = pkgs.callPackage ../dotfiles/zshrc.nix { };
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
