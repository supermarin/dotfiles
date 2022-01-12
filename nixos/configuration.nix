{ hostname, config, pkgs, ... }:
let
  hm = builtins.fetchTarball {
    url = https://github.com/nix-community/home-manager/archive/6c6f934f0ba77dbcaefa84c106cab505f1e5bc58.tar.gz;
    sha256 = "1cqlnb5fmpbdcskp9jjw2hwh5r45jiqcx83qiss5bs46gd0lpcx7";
  };
in

{
  imports = [
    (import "${hm}/nixos")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true; # enables bluez
  sound.enable = true;
  time.timeZone = "EST";

  networking = {
    firewall.allowedTCPPorts = [ 22 3333 ];
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

  xdg.portal.enable = true; # needed for flatpak
  services.flatpak.enable = true;
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
    firefox
    killall # killall(1)
    libreoffice
    unzip
    virt-manager
  ];

  # only for sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      alacritty       # Terminal
      gnome.gnome-bluetooth # bluetooth-sendto for sending files
      blueberry       # Bluetooth devices management gui
      brightnessctl   # Brightness control
      grim            # wayland screenshot tool
      i3status-rust   # Menu bar
      libnotify       # notify-send
      mako            # notification daemon
      rofi
      rofi-calc
      slurp           # screenshot: select a region in wayland
      swaylock        # idle lock
      swayidle        # idle lock
      wl-clipboard    # wl-copy, wl-paste
      wob             # indicator bar
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export QT_SCALE_FACTOR=1.25
    '';
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      inter # UI Sans
      source-serif-pro # Serif
      hack-font # mono
      noto-fonts-emoji # emoji
      font-awesome # i3status-rust
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif Pro" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto" ];
      };
    };
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.docker.enable = true;

  home-manager.users.supermarin = (import ../home.nix);
  system.stateVersion = "21.05";
  nix = {
    trustedUsers = [ "supermarin" ]; # enable nix-copy-closure
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

