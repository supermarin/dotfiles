{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    # initExtra = ''
    #   # Keep bash as login shell, but if running interactively, launch fish.
    #   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #   then
    #     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #   fi
    # '';
    initExtra = ''
      wo() {
        local dir=$(find -L ~/code -maxdepth 2 | fzf)
        test $dir || return 1

        if [[ -n "$TMUX" ]]; then
          # TODO: open new tab in tmux?
          tmux rename-window "$(basename "$dir")"
        fi

        cd "$dir" || return
        clear
        ls -la
      }

      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init bash)"
    '';
  };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     source ${./fish/functions/fish_prompt.fish}
  #     source ${./fish/functions/fish_right_prompt.fish}
  #     source ${./fish/functions/wo.fish}
  #   '';
  # };
}
