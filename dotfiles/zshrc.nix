{ pkgs, ... }:

let

  git-prompt-src = pkgs.fetchFromGitHub {
    owner = "woefe";
    repo = "git-prompt.zsh";
    rev = "ea72d8ba6ebca05522e48e6a0f347e219e8ed51f";
    sha256 = "01pkvmlbcrd77xihwmsv7yb1cplc23d5c6g5pymczp2ix5cv6r61";
  };

  mac-extra = ''
    case $(uname) in
      Darwin)
        if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
          source "$HOME/.nix-profile/etc/profile.d/nix.sh"
        fi

        if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fi
        ;;
    esac
  '';

in

''
  # eval "$(stack --bash-completion-script stack)"
  # export WORKON_HOME=$HOME/.virtualenvs
  # source ${pkgs.python37Packages.virtualenvwrapper}/bin/virtualenvwrapper_lazy.sh

  if [ -f $HOME/.local-zshrc ]; then
    source $HOME/.local-zshrc
  fi

  npm() {
    if [ -x npm ]; then
        command npm $*
    else
        nvminit && command npm $*
    fi
  }

  nvminit() {
    unfunction npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  }

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

  ${mac-extra}
''
