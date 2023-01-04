{ pkgs, nixpkgs, ... }:
let
  vpn-ip = "45.79.169.48";
in
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  services.getty.autologinUser = "marin";



  time.timeZone = "America/NewYork";

  networking = {
    firewall = {
      allowedTCPPorts = [
        22 # ssh
      ];
    };
    hostName = "tokio-vm";
    nameservers = [ vpn-ip ];
    # networkmanager.enable = true;
    # wg-quick.interfaces = {
    #   wg0 = {
    #     address = [ "10.100.0.4/24" ];
    #     privateKeyFile = "/wg/private";
    #     dns = [ "10.100.0.1" ];
    #     listenPort = 51820;
    #     peers = [
    #       {
    #         publicKey = "qpt3/3sZrR9Jlw98l8FoPUjcgo1TvDk8eSFZjLyoNlc=";
    #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
    #         endpoint = "${vpn-ip}:51820";
    #       }
    #     ];
    #   };
    # };
  };

  hardware.video.hidpi.enable = true;
  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        rofi
        redshift
        xdg-utils
        i3status-rust
      ];
    };
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
    pinentryFlavor = "tty";
  };

  programs.fish.enable = true;
  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix pkgs;
  };
  security.sudo.wheelNeedsPassword = false;

  environment.pathsToLink = [ "/libexec" ];
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";
  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps,altwin:swap_lalt_lwin";
  };

  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    file # file(1)
    gnome.adwaita-icon-theme
    killall # killall(1)
    libreoffice
    unzip
    virt-manager
    zip
  ];

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      inter # UI Sans
      source-serif-pro # Serif
      jetbrains-mono # mono
      fira-code
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
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

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
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
  };

  # don't touch
  system.stateVersion = "22.11";
}

