{ hostname, pkgs, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true; # enables bluez
  sound.enable = true;
  time.timeZone = "America/Guadeloupe";

  networking = {
    firewall.allowedTCPPorts = [ 
      22 # ssh
      3333 # sailefx
      8080 # calibre
    ];
    hostName = hostname;
    nameservers = [ "1.1.1.1" ];
    networkmanager.enable = true;
  };
 
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
    nssmdns = true;
  };

  # xdg.portal.enable = true; # needed for flatpak
  # services.flatpak.enable = true;
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
    ];
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    QT_QPA_PLATFORM = "wayland";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps,altwin:swap_lalt_lwin";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    file # file(1)
    killall # killall(1)
    libreoffice
    mupdf
    qutebrowser
    unzip
    virt-manager
    xdg-utils
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
      grim            # wayland screenshot tool
      i3status-rust   # Menu bar
      libnotify       # notify-send
      mako            # notification daemon
      rofi
      rofimoji
      slurp           # screenshot: select a region in wayland
      kitty           # terminal
      swaylock        # idle lock
      swayidle        # idle lock
      w3m             # for ranger, email, ...
      wl-clipboard    # wl-copy, wl-paste
      wob             # indicator bar
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };
  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

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

  # system.stateVersion = "21.05";
  nixpkgs.config.allowUnfree = true; 
  nix = {
    settings = {
      trusted-users = [ "supermarin" ]; # enable nix-copy-closure
    };
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
  };
}

