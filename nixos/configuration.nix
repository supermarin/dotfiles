{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_11;
  time.timeZone = "America/New_York";

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "pumba";
    nameservers = [ "1.1.1.1" ];
    networkmanager.enable = true;
  };

  programs.ssh.startAgent = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  services.openssh.enable = true;
  hardware.pulseaudio.enable = true;
  sound.enable = true;

  users.users.supermarin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in"
    ];
  };


  environment.sessionVariables = {
    EDITOR = "vim";
  };

  environment.systemPackages = with pkgs; [
    alacritty
    albert
    firefox
    vim
    wget
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      flameshot       # Screenshot tool https://flameshot.org
      mako            # notification daemon
      swaylock
      swayidle
      wayvnc
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

  system.stateVersion = "21.05";
}

