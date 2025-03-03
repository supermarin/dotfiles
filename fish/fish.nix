{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      source ${./functions/fish_prompt.fish}
      source ${./functions/fish_right_prompt.fish}
      source ${./functions/wo.fish}
    '';
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
