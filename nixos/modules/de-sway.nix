{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./de-common.nix
    inputs.asdcontrol.modules.asdcontrol
    ./fonts.nix
  ];

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.asdcontrol.enable = true;
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false; # TODO: document what was this
  programs.sway =
    let
      sway-head = pkgs.sway.overrideAttrs (oldAttrs: {
        version = "master";
        src = pkgs.fetchFromGitHub {
          owner = "swaywm";
          repo = "sway";
          rev = "e51f9d7183c89706558015ce61e0460631ba3577"; # or specific commit hash
          sha256 = "sha256-5vHfxrerNGvlM8BMLO0Ak4g+E/dwQ11gAZQnyJMywlo="; # fill after
        };
      });
    in
    {
      package = sway-head;
      enable = true;
      xwayland.enable = false;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      extraPackages = with pkgs; [
        # (import ../../misc/zpoweralertd.nix { inherit pkgs; }) # TODO: only for laptops. also TODO: build is broken
        adwaita-icon-theme
        albert # launcher
        autotiling-rs # for sway
        bluetui # tui for bluetooth connections
        brightnessctl # Brightness control
        (cliphist.overrideAttrs { doCheck = false; }) # clipboard history
        crosspipe # sound patchbay
        ddcutil # another brightness control. for ext displays via i2c
        gnome-calculator
        grim # wayland screenshot tool
        imagemagick # for resizing images
        kanshi
        libnotify # notify-send
        mupdf
        nemo # gui file browser
        playerctl # media keys (play/pause, prev, next)
        rofi
        rofimoji # emoji picker, fuzzel doesn't support emoji
        slurp # screenshot: select a region in wayland
        swayidle # idle lock
        swaylock # idle lock
        swaynotificationcenter # notification daemon
        swayosd
        udiskie # auto mount usb media
        w3m # for HTML emails
        waybar
        wdisplays
        wtype
        wiremix # sound output selector
        wob # indicator bar
        xdg-utils
      ];
      extraSessionCommands = ''
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
    };

  programs.noctalia = {
    enable = true;

    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    # recommendedServices.enable = true;
  };

  # For trash
  services.gvfs.enable = true;

  # login
  services.displayManager.ly =
    lib.mkIf
      (
        !config.services.displayManager.sddm.enable
        && !config.services.displayManager.gdm.enable
        && !config.services.desktopManager.cosmic.enable
      )
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

  # xdg.portal = lib.mkIf (config.services.desktopManager.gnome.enable == false) {
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
