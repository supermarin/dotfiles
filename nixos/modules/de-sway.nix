{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.asdcontrol.modules.asdcontrol
    ./fonts.nix
  ];
  programs.yubikey-touch-detector.enable = true;

  programs.asdcontrol.enable = true;

  ######################## experimental sway alternates ######################
  programs.river.enable = true;
  programs.river.extraPackages = with pkgs; [
    kanshi
    waybar
  ];
  ######################## experimental sway alternates ######################

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      autotiling # for sway & i3
      blueberry # Bluetooth devices management gui
      brightnessctl # Brightness control
      (cliphist.overrideAttrs { doCheck = false; }) # clipboard history
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      gedit # basic text file opener
      adwaita-icon-theme
      gnome-calculator
      kanshi
      nautilus # gui file browser
      nwg-panel
      sushi # quick preview for nautilus
      imagemagick # for resizing images
      playerctl # media keys (play/pause, prev, next)
      pwvucontrol # select sound output device
      pamixer # volume up/down
      rofi-wayland
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      swaylock # idle lock
      swayidle # idle lock
      udiskie # auto mount usb media
      xdg-utils
      w3m # for HTML emails
      wdisplays
      wl-clipboard # wl-copy, wl-paste. wl-clipboard-rs doesn't support --watch
      wob # indicator bar
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  # Bind a target to graphical-session.target in order for systemd to start it
  systemd.user.targets.sway-session = {
    after = [ "graphical-session-pre.target" ];
    description = "sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.wlsunset =
    let
      latitude = "40.7";
      longitude = "-73.9";
    in
    {
      enable = true;
      description = "Automatic montior temperature adjustment";
      after = [ "sway-session.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkgs.wlsunset}/bin/wlsunset -l ${latitude} -L ${longitude}
      '';
    };

  xdg.portal = lib.mkIf (config.services.xserver.desktopManager.gnome.enable == false) {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
