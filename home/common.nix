{ pkgs, lib, ... }:
let
  profile = pkgs.callPackage ../dotfiles/profile.nix { };
  fishrc = pkgs.callPackage ../dotfiles/fishrc.nix { };
  scripts = pkgs.callPackage ../dotfiles/scripts.nix { };
  vim = pkgs.callPackage ../dotfiles/vim.nix { };
in
{
  # home-manager manual
  manual.manpages.enable = true;
  manual.html.enable = true;

  home = {
    file = {
      # vim
      ".vimrc".text = vim.vimrc;
      ".vim/after/syntax/markdown.vim".text = vim.markdown-frontmatter;

      # tmux & tmate
      ".tmux.conf".text = pkgs.callPackage ../dotfiles/tmux-conf.nix { tmate = false; };
      ".tmate.conf".text = pkgs.callPackage ../dotfiles/tmux-conf.nix { tmate = true; };

      # ~/bin
      "bin/cookie" = { text = scripts.cookie; executable = true; };
      "bin/gen-gitignore" = { text = scripts.gen-gitignore; executable = true; };

      # others
      ".ghci".source = ../dotfiles/ghci;
      ".config/ripgrep/ripgreprc".source = ../dotfiles/ripgreprc;
      ".config/yamllint/config".source = ../dotfiles/yamllint-conf.yml;
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
      EDITOR = "vim";
      LESS = "-r";
      EXA_COLORS = "uu=0;36:gu=0;36:da=0;37";
      RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/ripgreprc";
      WORKON_HOME = "$HOME/.virtualenvs";
    };
    shellAliases = profile.aliases;
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
      core.editor = "vim";
      credential.helper = "store";
      push.autoSetupRemote = true;
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
    let linuxOnlyOpts = [ "globstar" "checkjobs" ];
    in
    {
      enable = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      shellOptions = [
        "histappend"
        "extglob"
      ] ++ (if pkgs.is-mac then [ ] else linuxOnlyOpts);
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
    plugins = [
      {
        name = "evalcache";
        src = pkgs.fetchFromGitHub {
          owner = "mroth";
          repo = "evalcache";
          rev = "4c7fb8d5b319ae177fead3ec666e316ff2e13b90";
          sha256 = "0vvgq8125n7g59vx618prw1i4lg9h0sb5rd26mkax7nb78cnffmb";
        };
      }
    ];
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
