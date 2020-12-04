pkgs:
{
  enable = true;
  windowManager.i3 = rec {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      #bars = [ ]; # use polybar instead
      gaps = {
        inner = 12;
        outer = 5;
        smartGaps = true;
        smartBorders = "off";
      };
      #startup = [
        #{ command = "exec firefox"; }
      #];
      assigns = {
        "2: web" = [{ class = "^Firefox$"; }];
        "4" = [{ class = "^Slack$"; }];
      };
      keybindings = import ./i3-keybindings.nix config.modifier;
    };
    extraConfig = ''
      for_window [class="^.*"] border pixel 2
      #exec systemctl --user import-environment
      #exec systemctl --user restart graphical-session.target
      exec xrandr --dpi 227
      exec xset r rate 300 50
    '';
  };
}
