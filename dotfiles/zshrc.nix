{ pkgs, ... }:

let

  is-mac = (pkgs.callPackage ../nix/lib.nix {}).is-mac;

  git-prompt-src = pkgs.fetchFromGitHub {
    owner = "woefe";
    repo = "git-prompt.zsh";
    rev = "ea72d8ba6ebca05522e48e6a0f347e219e8ed51f";
    sha256 = "01pkvmlbcrd77xihwmsv7yb1cplc23d5c6g5pymczp2ix5cv6r61";
  };

  vterm-extra = ''
    if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
      alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
    fi

    vterm_printf(){
      if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
      elif [ "''${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
      else
        printf "\e]%s\e\\" "$1"
      fi
    }

    vterm_cmd() {
      local vterm_elisp
      vterm_elisp=""
      while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
      done
      vterm_printf "51;E$vterm_elisp"
    }

    if [ "$INSIDE_EMACS" = "vterm" ]; then
      find_file() {
        vterm_cmd find-file "$(realpath "''${@:-.}")"
      }
      alias ff=find_file

      magit_commit() {
        vterm_cmd magit-commit-create
      }
      alias gitc=magit_commit
    fi
  '';

  mac-extra = ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi

    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi
  '';

in

''
  # eval "$(stack --bash-completion-script stack)"
  # export WORKON_HOME=$HOME/.virtualenvs
  # source ${pkgs.python37Packages.virtualenvwrapper}/bin/virtualenvwrapper_lazy.sh

  if [ -f $HOME/.local-zshrc ]; then
    source $HOME/.local-zshrc
  fi

  hs() {
    eval "nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $@ ])'"
  }

  py() {
    eval "nix-shell -p 'python37.withPackages (pkgs: with pkgs; [ ipython $@ ])'"
  }

  ##########
  # prompt #
  ##########

  source ${git-prompt-src}/git-prompt.zsh

  ZSH_THEME_GIT_PROMPT_PREFIX="("
  ZSH_THEME_GIT_PROMPT_SUFFIX=") "
  ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
  ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg[cyan]%}:"
  ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
  ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
  ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
  ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
  ZSH_THEME_GIT_PROMPT_BEHIND="↓"
  ZSH_THEME_GIT_PROMPT_AHEAD="↑"
  ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
  ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}•"
  ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[yellow]%}•"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="•"
  ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
  ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"


  build_prompt() {
    local symbols
    symbols=()
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{white}%}⚙"
    [[ -n "$symbols" ]] && echo -n "$symbols "
  }

  symb="$"

  local ret_status="%(?:%{$fg_bold[green]%}$symb:%{$fg_bold[red]%}$symb)"
  local root_ret_status="%(?:%{$fg_bold[green]%}#:%{$fg_bold[red]%}#)"
  PROMPT='$(build_prompt)%{$fg[green]%}%~%{$reset_color%} $(gitprompt)%(!.''${root_ret_status}.''${ret_status})%{$reset_color%} '
  PROMPT2='%{$fg[green]%}┌─╼ %{$reset_color%}$(build_prompt)%{$fg[green]%}%~%{$reset_color%} $(gitprompt)
  %{$fg[green]%}└╼ %(!.''${root_ret_status}.''${ret_status})%{$reset_color%} '

  switch_prompts() {
      local tmp=$PROMPT
      PROMPT=$PROMPT2
      PROMPT2=$tmp
  }

  alias sp=switch_prompts

  # disable C-s and C-q if interactive
  if [[ -o interactive ]]; then
    stty -ixon -ixoff
  fi

  ${if is-mac then mac-extra else ""}
  ${vterm-extra}
  ${import ./nvm-lazy-load.nix}
''
