{ hostname, pkgs, ... }:
{
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  time.timeZone = "America/Guadeloupe";

  networking = {
    firewall = { 
      allowedTCPPorts = [ 
        22 # ssh
      ];
    };
    hostName = hostname;
  };
 
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
    nssmdns = true;
  };

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
    initialHashedPassword = "$6$Hb6ndAxg4esaVOjz$TouriSv6Ea0KaUbftzM76X2fMenAcrpJcImrpYPOJEiVBPyvEgJYVTHnIZvukDc3bZlT/Ed46ckDpsxi1n2.R1";
  };
  security.sudo.wheelNeedsPassword = false;

  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";
  environment.sessionVariables = {
    EDITOR = "vim";
    QT_QPA_PLATFORM = "wayland";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps,altwin:swap_lalt_lwin";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    brave
    file # file(1)
    helix
    git
    killall # killall(1)
    libreoffice
    unzip
    vim
  ];

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
  services.spice-vdagentd.enable = true;
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true; 
  nixpkgs.config.allowUnsupportedSystem = true;

  #nix = {
  #  extraOptions = ''
  #    experimental-features = nix-command flakes
  #  '';
  #  gc = {
  #    automatic = true;
  #    dates = "monthly";
  #  };
  #  package = pkgs.nixFlakes;
  #  optimise = {
  #    automatic = true;
  #    dates = [ "monthly" ];
  #  };
  #  settings = {
  #    trusted-users = [ "supermarin" ]; # enable nix-copy-closure
  #  };
  #};

  # don't touch
  system.stateVersion = "22.05";
}

