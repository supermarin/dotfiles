{ hostname, config, pkgs, ... }:

{
  imports = [
      (import "${builtins.fetchTarball 
        https://github.com/nix-community/home-manager/archive/775cb20bd4af7781fbf336fb201df02ee3d544bb.tar.gz}/nixos")
  ];

  boot.kernelPackages = pkgs.linuxPackages_5_12;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  hardware.pulseaudio.enable = true;
  sound.enable = true;
  time.timeZone = "Europe/Malta";

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
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" "video" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in"
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
    alacritty
    albert
    file # file(1)
    firefox
    gnome.gnome-tweaks # TODO: remove this once we figure out how to configure GNOME declaratively.
    gnomeExtensions.vitals # TODO: document what's this
    killall # killall(1)
    libreoffice
    virt-manager
  ];

  # only for sway
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      brightnessctl   # Brightness control
      grim            # wayland screenshot tool
      i3status-rust   # Menu bar
      pamixer         # used for volume up/down
      mako            # notification daemon
      slurp           # screenshot: select a region in wayland
      swaylock        # idle lock
      swayidle        # idle lock
      wl-clipboard    # wl-copy, wl-paste

      # custom
      (import ../linux/sway/avizo.nix)
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=GNOME
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  programs.dconf.enable = true;

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      inter # UI Sans
      source-serif-pro # Serif
      hack-font # mono
      noto-fonts-emoji # emoji
      (nerdfonts.override { fonts = [ "Hack" ]; })
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
  virtualisation.docker.enable = true;

  home-manager.users.supermarin = (import ../home.nix);
  system.stateVersion = "21.05";
}

