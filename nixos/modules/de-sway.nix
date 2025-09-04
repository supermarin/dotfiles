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

  programs.asdcontrol.enable = true;
  programs.ssh.startAgent = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      autotiling-rs # for sway
      blueberry # Bluetooth devices management gui
      brightnessctl # Brightness control
      (cliphist.overrideAttrs { doCheck = false; }) # clipboard history
      ddcutil # another brightness control. for ext displays via i2c
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      adwaita-icon-theme
      gnome-calculator
      kanshi
      nautilus # gui file browser
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
      waybar
      w3m # for HTML emails
      wdisplays
      wl-clipboard # wl-copy, wl-paste. wl-clipboard-rs doesn't support --watch
      wob # indicator bar
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  # For trash in nautilus
  services.gvfs.enable = true;

  # login
  services.displayManager.ly =
    lib.mkIf (!config.services.displayManager.sddm.enable && !config.services.displayManager.gdm.enable)
      {
        enable = true;
        settings = {
          animation = "matrix";
        };
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

  xdg.portal = lib.mkIf (config.services.desktopManager.gnome.enable == false) {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
