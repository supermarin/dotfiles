#  Sources:
#    dconf2nix: https://github.com/gvolpe/dconf2nix
#    nixos module PR (without HM): https://github.com/NixOS/nixpkgs/pull/234615
#    pop-shell-gnome-45 (script that resets all the keybindings correctly): 
#    https://github.com/ronanru/pop-shell-gnome-45/blob/master_jammy/scripts/configure.sh
{ pkgs }:

with pkgs.lib.gvariant;
{
  "org/gnome/desktop/input-sources" = {
    xkb-options = [ "terminate:ctrl_alt_bksp" "caps:ctrl_modifier" ];
  };
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    cursor-size = 24;
    cursor-theme = "Adwaita";
    document-font-name="SF Pro Display 11";
    enable-animations=true;
    font-antialiasing="grayscale";
    font-hinting="slight";
    font-name="SF Pro Display,  10";
    gtk-theme = "Adwaita";
    icon-theme = "Adwaita";
    monospace-font-name="Berkeley Mono 10";
    toolbar-style="text";
  };
  "org/gnome/desktop/peripherals/touchpad" = {
    two-finger-scrolling-enabled = true;
  };
  "org/gnome/desktop/peripherals/mouse" = {
    natural-scroll = true;
  };
  "org/gnome/desktop/peripherals/keyboard" = {
    delay = mkUint32 150;
    repeat-interval = mkUint32 15;
    repeat = true;
  };
  "org/gnome/desktop/wm/preferences" = {
    resize-with-right-button = true;
  };
  "org/gnome/desktop/wm/keybindings" = {
    close = [ "<Super>q" "<Alt>F4" ];
    minimize = [ ];
    maximize = [ ];
    move-to-monitor-down = [ ];
    move-to-monitor-left = [ ];
    move-to-monitor-right = [ ];
    move-to-monitor-up = [ ];
    move-to-workspace-down = [ ];
    move-to-workspace-up = [ ];
    move-to-workspace-1 = [ "<Super><Shift>1" ];
    move-to-workspace-2 = [ "<Super><Shift>2" ];
    move-to-workspace-3 = [ "<Super><Shift>3" ];
    move-to-workspace-4 = [ "<Super><Shift>4" ];
    move-to-workspace-left = [ "<Shift><Super>h" ];
    switch-to-workspace-1 = [ "<Super>1" ];
    switch-to-workspace-2 = [ "<Super>2" ];
    switch-to-workspace-3 = [ "<Super>3" ];
    switch-to-workspace-4 = [ "<Super>4" ];
    switch-to-workspace-down = [ "<Primary><Super>j" ];
    switch-to-workspace-left = [ "<Primary><Super>h" ];
    switch-to-workspace-right = [ "<Primary><Super>l" ];
    switch-to-workspace-up = [ "<Primary><Super>k" ];
    toggle-maximized = [ "<Super>m" ];
    unmaximize = [ ];
  };
  "org/gnome/mutter" = {
    experimental-features = [ "scale-monitor-framebuffer" ];
  };
  "org/gnome/mutter/keybindings" = {
    toggle-tiled-left = [ ];
    toggle-tiled-right = [ ];
  };
  "org/gnome/mutter/wayland/keybindings/restore-shortcuts" = { };
  "org/gnome/settings-daemon/plugins/media-keys" = {
    control-center = [ "<Super>comma" ];
    email = [ "<Super>e" ];
    home = [ "<Super>f" ];
    rotate-video-lock-static = [ ];
    screensaver = [ "<Super>Escape" ];
    terminal = [ "<Super>t" ];
    www = [ "<Super>b" ];
  };
  "org/gnome/shell/extensions/pop-shell" = {
    active-hint = true;
    gap-inner = mkUint32 4;
    gap-outer = mkUint32 4;
    tile-by-default = true;
    smart-gaps = true;
  };
  "org/gnome/shell/keybindings" = {
    open-application-menu = [ ];
    toggle-message-tray = [ "<Super>v" ];
    toggle-overview = [ ];
    switch-to-application-1 = [ ]; # remove favorite applications
    switch-to-application-2 = [ ]; # remove favorite applications
    switch-to-application-3 = [ ]; # remove favorite applications
    switch-to-application-4 = [ ]; # remove favorite applications
  };
}
