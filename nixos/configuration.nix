{ pkgs, config, nixpkgs, lgufbrightness, berkeley, ... }:
{
  # Fix NetworkManager.wait-online.service bug
  # TODO: remove when dis resolves https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = pkgs.lib.mkForce false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.bluetooth.enable = true; # enables bluez
  hardware.pulseaudio.enable = true;
  sound.enable = true;
  time.timeZone = "America/New_York";

  networking = {
    firewall = (import ../secrets/firewall.nix).tokio;
    hostName = "tokio";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };

  # For screen sharing per https://nixos.wiki/wiki/Slack
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  programs.fish.enable = true;

  # needed for printer discovery on the network
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
    nssmdns = true;
  };
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true; # TODO: test if we need this anymore?
  services.syncthing = (import ../secrets/syncthing.nix "tokio") // {
    user = "supermarin";
  };
  services.tailscale.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="043e", ATTRS{idProduct}=="9a40", MODE="0666"
  '';
  services.yubikey-agent.enable = true;
  # services.clight.enable = true;
  # location.latitude = 40.7; # required by clight
  # location.longitude = -73.9; # required by clight

  users.users.supermarin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "nixbld" ];
    openssh.authorizedKeys.keyFiles = [ ../ssh/pubkeys.nix ];
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    QT_QPA_PLATFORM = "wayland";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    appimage-run # not really running appimages, this guy says it's totally ok https://www.youtube.com/watch?v=FDY-x_hvj1o @ 5:40
    dig
    file # file(1)
    gnome.adwaita-icon-theme
    killall # killall(1)
    libreoffice
    lgufbrightness
    unzip
    virt-manager
    zip
  ];

  # only for sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      blueberry # Bluetooth devices management gui
      brightnessctl # Brightness control
      galculator
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      gnome.gedit # basic text file opener
      gnome.nautilus # gui file browser
      gnome.sushi # quick preview for nautilus
      playerctl # media keys (play/pause, prev, next)
      pavucontrol # select sound output device
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      swaylock # idle lock
      swayidle # idle lock
      udiskie # auto mount usb media
      ulauncher # alfred style fuzzy launcher
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

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (import ../fonts/sfpro.nix { pkgs = pkgs; }) # sans
      (import ../fonts/sfmono.nix { pkgs = pkgs; }) # mono for browser
      berkeley
      source-serif # serif
      jetbrains-mono # mono for terminal and vim

      noto-fonts-emoji # emoji
      font-awesome # i3status-rust

      ibm-plex # more mono ftw
      hack-font # more mono ftw
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif 4" ];
        sansSerif = [ "SF Pro Display" ];
        monospace = [ "SF Mono" ];
        emoji = [ "Noto" ];
      };
    };
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.podman = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    buildMachines = import ./build-machines.nix;
    distributedBuilds = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
    optimise = {
      automatic = true;
      dates = [ "monthly" ];
    };
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      trusted-users = [ "supermarin" ]; # enable nix-copy-closure
    };
    nixPath = [
      "nixpkgs=/etc/nix/channels/nixpkgs"
    ];
  };
  environment.etc."nix/channels/nixpkgs".source = nixpkgs.outPath;

  # don't touch
  system.stateVersion = "22.05";
}

