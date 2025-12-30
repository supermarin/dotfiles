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
  services.gnome.gcr-ssh-agent.enable = false;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      (import ../../misc/zpoweralertd.nix { inherit pkgs; })
      adwaita-icon-theme
      albert # launcher
      autotiling-rs # for sway
      bluetui # tui for bluetooth connections
      brightnessctl # Brightness control
      (cliphist.overrideAttrs { doCheck = false; }) # clipboard history
      ddcutil # another brightness control. for ext displays via i2c
      gnome-calculator
      grim # wayland screenshot tool
      helvum # sound patchbay
      imagemagick # for resizing images
      kanshi
      libnotify # notify-send
      mupdf
      nautilus # gui file browser
      playerctl # media keys (play/pause, prev, next)
      rofi
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      sushi # quick preview for nautilus
      swayidle # idle lock
      swaylock # idle lock
      swaynotificationcenter # notification daemon
      udiskie # auto mount usb media
      w3m # for HTML emails
      waybar
      wdisplays
      wiremix # sound output selector
      wl-clipboard # wl-copy, wl-paste. wl-clipboard-rs doesn't support --watch
      wob # indicator bar
      xdg-utils
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
      latitude = "39.74";
      longitude = "-104.99";
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
