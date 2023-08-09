{ inputs, config, nixpkgs, pkgs, secrets, ... }:
{
  virtualisation.vmware.guest.enable = true;
  time.timeZone = "America/New_York";

  networking = {
    firewall = secrets.firewall.tokio;
    hostName = "tokio-vm";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };

  programs.fish.enable = true;
  services.openssh.enable = true;
  services.getty.autologinUser = "marin";
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.yubikey-agent.enable = true;
  services.syncthing = secrets.syncthing "tokio-vm" // {
    user = "marin";
  };
  services.tailscale.enable = true;

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    dig
    file # file(1)
    gnome.adwaita-icon-theme
    killall # killall(1)
    unzip
    virt-manager
    zip
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 220;

    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        clipmenu
        xsel
      ];
    };
  };

  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      (import ../fonts/sfpro.nix { pkgs = pkgs; }) # sans
      (import ../fonts/sfmono.nix { pkgs = pkgs; }) # mono for browser
      source-serif # serif
      jetbrains-mono # mono for terminal and vim

      noto-fonts-emoji # emoji
      font-awesome # i3status-rust

      ibm-plex # more mono ftw
      hack-font # more mono ftw
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif 4" ];
        sansSerif = [ "SF Pro Display" ];
        monospace = [ "SF Mono" ];
        emoji = [ "Noto" ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    buildMachines = import ./build-machines.nix;
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
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
    nixPath = [
      "nixpkgs=/etc/nix/channels/nixpkgs"
    ];
  };
  environment.etc."nix/channels/nixpkgs".source = inputs.nixpkgs.outPath;

  # don't touch
  system.stateVersion = "23.05";
}

