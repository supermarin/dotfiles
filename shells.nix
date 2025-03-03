{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      # Keep bash as login shell, but if running interactively, launch fish.
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ${./fish/functions/fish_prompt.fish}
      source ${./fish/functions/fish_right_prompt.fish}
      source ${./fish/functions/wo.fish}
    '';
  };
}
