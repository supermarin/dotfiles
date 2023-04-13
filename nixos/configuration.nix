{ config, nixpkgs, pkgs, secrets, lgultrafine, ... }:
let
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.fwupd.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.useGlobalPkgs = true;
  hardware.pulseaudio.enable = true;
  sound.enable = true;
  hardware.bluetooth.enable = true; # enables bluez
  time.timeZone = "America/New_York";

  networking = {
    firewall = {
      allowedTCPPorts = [
        22 # ssh
        3333 # sailefx
        8080 # calibre
      ];
      allowedUDPPorts = [
        51820 # vpn
      ];
    };
    hostName = hostname;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.100.0.4/24" ];
        privateKeyFile = "/wg/private";
        dns = [ "10.100.0.1" ];
        listenPort = 51820;
        peers = [
          {
            publicKey = "qpt3/3sZrR9Jlw98l8FoPUjcgo1TvDk8eSFZjLyoNlc=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "${vpn-ip}:51820";
          }
        ];
      };
    };
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
    nssmdns = true;
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.openssh.enable = true;

  programs.fish.enable = true;
  services.yubikey-agent.enable = true;

  users.users.supermarin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    QT_QPA_PLATFORM = "wayland";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    file # file(1)
    gnome.adwaita-icon-theme
    killall # killall(1)
    libreoffice
    lgultrafine
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
      fuzzel # rofi/dmenu for wayland
      galculator
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      ranger # file browser
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      swaylock # idle lock
      swayidle # idle lock
      udiskie # auto mount usb media
      xdg-utils
      w3m # for ranger, email, ...
      wdisplays
      wl-clipboard # wl-copy, wl-paste
      wob # indicator bar
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      # inter-head # UI Sans
      (import ../fonts/sfpro.nix { pkgs = pkgs; })
      source-serif-pro # Serif
      jetbrains-mono # mono
      fira-code
      noto-fonts-emoji # emoji
      font-awesome # i3status-rust
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif Pro" ];
        sansSerif = [ "SF Pro Display" ];
        monospace = [ "JetBrainsMono" ];
        emoji = [ "Noto" ];
      };
    };
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    buildMachines = [
      {
        hostName = "pumba.local";
        sshUser = "marin";
        sshKey = "/home/supermarin/.ssh/nix_remote";
        system = "x86_64-linux";
        speedFactor = 10;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
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
  };

  # don't touch
  system.stateVersion = "22.05";
}

