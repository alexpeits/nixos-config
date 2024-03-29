{ pkgs, ... }:

let
  edit-cmd = ''
    function edit_cmd --description 'Edit cmdline in editor'
      set -l f (mktemp --tmpdir=.)
      set -l p (commandline -C)
      commandline -b > $f
      vim -c set\ ft=fish $f
      commandline -r (more $f)
      commandline -C $p
      rm $f
    end

    bind \cx\ce edit_cmd
  '';

  variables = ''
    set -g fish_key_bindings fish_default_key_bindings
    set fish_greeting  # disable greeting
  '';

  # disable default C-s and C-q behavior if interactive
  disable-keys = ''
    if status --is-interactive
      stty -ixon -ixoff
    end
  '';

  prompt-variables = ''
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showuntrackedfiles 1

    set -g __fish_git_prompt_color_branch magenta

    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_upstream_ahead "↑"
    set -g __fish_git_prompt_char_upstream_behind "↓"
    set -g __fish_git_prompt_char_upstream_prefix ""
    set -g __fish_git_prompt_color_upstream blue

    set -g __fish_git_prompt_char_stagedstate "•"
    set -g __fish_git_prompt_color_stagedstate green

    set -g __fish_git_prompt_char_dirtystate "•"
    set -g __fish_git_prompt_color_dirtystate yellow

    set -g __fish_git_prompt_char_untrackedfiles "•"
    set -g __fish_git_prompt_color_untrackedfiles red

    set -g __fish_git_prompt_char_invalidstate "✖"
    set -g __fish_git_prompt_color_invalidstate red

    set -g __fish_git_prompt_char_cleanstate "✔"
    set -g __fish_git_prompt_color_cleanstate green --bold

    set -g __fish_prompt_normal (set_color normal)
  '';

  theme = ''
    set -g fish_color_autosuggestion 586e75
    set -g fish_color_cancel -r
    set -g fish_color_command
    set -g fish_color_comment 586e75
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end 268bd2
    set -g fish_color_error dc322f
    set -g fish_color_escape 00a6b2
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=blue
    set -g fish_color_normal normal
    set -g fish_color_operator 00a6b2
    set -g fish_color_param 839496
    set -g fish_color_quote 657b83
    set -g fish_color_redirection 6c71c4
    set -g fish_color_search_match bryellow --background=405555
    set -g fish_color_selection white --bold --background=black
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline
    set -g fish_pager_color_completion B3A06D
    set -g fish_pager_color_description B3A06D
    set -g fish_pager_color_prefix cyan --underline
    set -g fish_pager_color_progress brwhite --background=cyan
  '';

  mac-extra = ''
    if test -e "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fenv source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    end

    if test -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
      fenv source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    end

    if test -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fenv source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    end
  '';

  vterm-extra = ''
    if [ "$INSIDE_EMACS" = 'vterm' ]
      function clear
        vterm_printf "51;Evterm-clear-scrollback";
        tput clear;
      end
    end

    function vterm_printf;
      if [ -n "$TMUX" ]
        # tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
      else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
      else
        printf "\e]%s\e\\" "$argv"
      end
    end

    function vterm_cmd --description 'Run an emacs command from vterm-eval-cmds.'
      set -l vterm_elisp ()
      for arg in $argv
        set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
      end
      vterm_printf '51;E'(string join "" $vterm_elisp)
    end

    if [ "$INSIDE_EMACS" = 'vterm' ]
      function find_file
        set -q argv[1]; or set argv[1] "."
        vterm_cmd find-file (realpath "$argv")
      end
      alias ff=find_file

      function magit_commit
        vterm_cmd magit-commit-create
      end
      alias gitc=magit_commit
    end
  '';

in

{
  shellInit = ''
    eval (${pkgs.direnv}/bin/direnv hook fish)

    function nvminit
      unset -f npm
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    end

    function hs
      eval "nix-shell -p 'haskellPackages.ghcWithPackages (pkgs: with pkgs; [ $argv ])'"
    end

    function py
      eval "nix-shell -p 'python37.withPackages (pkgs: with pkgs; [ ipython $argv ])'"
    end

    function nsu
      nix-shell -I nixpkgs=(nix-instantiate --eval -E '<nixpkgs-unstable>') $argv
    end

    # messes with emacs
    function fish_title
    end

    ${edit-cmd}
    ${variables}
    ${theme}
    ${disable-keys}

    # promptInit
    ${prompt-variables}

    set -g __my_prompt_multiline 0

    function sp
      if test $__my_prompt_multiline = 0
        set -g __my_prompt_multiline 1
      else
        set -g __my_prompt_multiline 0
      end
    end

    # function fish_right_prompt
    #   date '+[%H:%M]'
    # end

    function fish_prompt
      set -l last_status $status

      function _when_multiline -a str nl
        if test $__my_prompt_multiline = 1
          if test $nl = 1
            echo $str
          else
            echo -n $str
          end
        end
      end

      set_color green --bold
      _when_multiline "┌─╼ " 0
      set_color normal

      if jobs -q
        echo -n '⚙ '
      end

      if test -n "$IN_NIX_SHELL"
        echo -n "(nix) "
      end

      set -l color_cwd
      set -l prefix
      set -l suffix
      switch "$USER"
        case root toor
          if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
          else
            set color_cwd $fish_color_cwd
          end
          set suffix '#'
        case '*'
          set color_cwd $fish_color_cwd
          set suffix '$'
      end

      # PWD
      set_color $color_cwd
      echo -n (prompt_pwd)
      set_color normal

      printf '%s ' (__fish_vcs_prompt)

      _when_multiline "" 1
      set_color green --bold
      _when_multiline "└╼ " 0
      set_color normal

      if not test $last_status -eq 0
        set_color $fish_color_error --bold
      else
        set_color green --bold
      end

      echo -n "$suffix "

      set_color normal
    end

    ${if pkgs.is-mac then mac-extra else ""}
    ${vterm-extra}

    if test -e $HOME/.local-fishrc
      source $HOME/.local-fishrc
    end
  '';
}
