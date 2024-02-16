{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      blueberry # Bluetooth devices management gui
      brightnessctl # Brightness control
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      gedit # basic text file opener
      gnome.adwaita-icon-theme
      gnome.gnome-calculator
      gnome.nautilus # gui file browser
      gnome.sushi # quick preview for nautilus
      playerctl # media keys (play/pause, prev, next)
      pavucontrol # select sound output device
      rofi-wayland
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      swaylock # idle lock
      swayidle # idle lock
      udiskie # auto mount usb media
      xdg-utils
      w3m # for HTML emails
      wdisplays
      wl-clipboard # wl-copy, wl-paste
      wob # indicator bar
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };
}
