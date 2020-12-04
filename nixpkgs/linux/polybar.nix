pkgs:
{
    enable = true;
    package = pkgs.polybarFull;
    #config = ./polybar-config;
    script = ''
      for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f 1); do
        MONITOR=$m polybar nord &
      done
    '';
}
