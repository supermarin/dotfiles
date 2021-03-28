{ hostname, config, pkgs, ... }:

{
  imports = [
      (import "${builtins.fetchTarball 
        https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
  ];

  home-manager.users.supermarin = (import ../home.nix);
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_11;
  time.timeZone = "America/New_York";
  hardware.pulseaudio.enable = true;
  sound.enable = true;

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    # TODO: firewall.allowedTCPPorts = [ 22 5800 ];
    hostName = hostname;
    nameservers = [ "1.1.1.1" ];
    networkmanager.enable = true;
  };
 
  services.avahi = { # TODO: still not properly working
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
  };

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  users.users.supermarin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in"
    ];
  };


  environment.sessionVariables = {
    EDITOR = "vim";
  };


  nixpkgs.config.allowUnfree = true; # only for slack, might nix it out
  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    alacritty
    albert
    firefox
    wget
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      brightnessctl
      playerctl
      flameshot       # Screenshot tool https://flameshot.org
      mako            # notification daemon
      swaylock        # idle lock
      swayidle        # idle lock
      # wayvnc        # TODO
      waybar
      wl-clipboard    # wl-copy, wl-paste
    ];
    extraSessionCommands = ''
      export XKB_DEFAULT_OPTIONS=ctrl:nocaps
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=sway 
    '';
  };

  services.xserver = {
    autorun = false;
    enable = true;
    xkbOptions = "ctrl:nocaps";
    displayManager.gdm.enable = true;
    desktopManager.gnome3.enable = true;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      inter # UI Sans
      source-serif-pro # Serif
      hack-font # mono
      (nerdfonts.override { fonts = [ "Hack" "DroidSansMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif Pro" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Hack" ];
      };
    };
  };

  system.stateVersion = "21.05";
}

