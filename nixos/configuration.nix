{ hostname, pkgs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  hardware.pulseaudio.enable = true;
  sound.enable = true;
  hardware.bluetooth.enable = true; # enables bluez
  time.timeZone = "America/Guadeloupe";

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
    nameservers = [ "104.248.7.113"  ];
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.100.0.4/24" ];
        privateKeyFile = "/wg/private";
        listenPort = 51820;
        peers = [
          {
            publicKey = "qpt3/3sZrR9Jlw98l8FoPUjcgo1TvDk8eSFZjLyoNlc=";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "104.248.7.113:51820";
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

  xdg.portal.enable = true; # needed for flatpak
  services.flatpak.enable = true; # for opencpn

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  programs.fish.enable = true;
  users.users.supermarin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in" # simba
    ];
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
    brave
    killall # killall(1)
    libreoffice
    qutebrowser
    unzip
    virt-manager
  ];

  # only for sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      gnome.gnome-bluetooth # bluetooth-sendto for sending files
      blueberry       # Bluetooth devices management gui
      brightnessctl   # Brightness control
      gnome.nautilus  # file manager
      grim            # wayland screenshot tool
      i3status-rust   # Menu bar
      libnotify       # notify-send
      mako            # notification daemon
      mupdf
      rofi
      rofimoji
      slurp           # screenshot: select a region in wayland
      kitty           # terminal
      swaylock        # idle lock
      swayidle        # idle lock
      xdg-utils
      w3m             # for ranger, email, ...
      wl-clipboard    # wl-copy, wl-paste
      wdisplays       # TODO: fix no gl implementation available
      wob             # indicator bar
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      inter # UI Sans
      source-serif-pro # Serif
      jetbrains-mono # mono
      noto-fonts-emoji # emoji
      font-awesome # i3status-rust
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif Pro" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono" ];
        emoji = [ "Noto" ];
      };
    };
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.docker.enable = true;

  # Mail
  systemd.user.services.mbsync = {
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
    ${pkgs.isync}/bin/mbsync -a
    ${pkgs.notmuch}/bin/notmuch new 
    '';
  };

  systemd.user.timers.mbsync = {
    wantedBy = [ "timers.target" ];
    partOf = [ "mbsync.service" ];
    timerConfig.OnUnitInactiveSec = "5m";
    timerConfig.OnBootSec = "10s";
  };

  nixpkgs.config.allowUnfree = true; 
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
    optimise = {
      automatic = true;
      dates = [ "monthly" ];
    };
    settings = {
      trusted-users = [ "supermarin" ]; # enable nix-copy-closure
    };
  };

  # don't touch
  system.stateVersion = "22.05";
}

