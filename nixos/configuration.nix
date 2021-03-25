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

  boot.kernelPackages = pkgs.linuxPackages_5_10;
  time.timeZone = "America/New_York";

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "pumba";
    nameservers = [ "1.1.1.1" ];
    networkmanager.enable = true;
  };

  programs.ssh.startAgent = true;
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
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; 
  };

  environment.systemPackages = with pkgs; [
    alacritty
    wget
    vim
    firefox-wayland
    rofi
    rofi-pass
  ];

  fonts = {
    fonts = with pkgs; [
      inter
      liberation_ttf
      fira-code
      fira-code-symbols
    ];
    fontconfig.defaultFonts = {
      serif = [ "Inter" ];
      sansSerif = [ "Inter" ];
      monospace = [ "Fira Code" ];
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      wl-clipboard     # wl-copy, wl-paste
      mako             # notification daemon
      wofi
      kanshi
    ];
    extraSessionCommands = ''
      export XKB_DEFAULT_OPTIONS=ctrl:nocaps
    '';
  };

  services.xserver = {
    autorun = false;
    enable = true;
    displayManager.defaultSession = "none+i3";
    xkbOptions = "ctrl:nocaps";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3status
        i3lock
        xsel
      ];
    };
  };

  system.stateVersion = "21.05";
}

