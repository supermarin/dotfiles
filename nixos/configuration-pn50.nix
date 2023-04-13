{ config, nixpkgs, pkgs, secrets, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  services.fwupd.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-

  time.timeZone = "America/New_York";

  networking = {
    firewall.allowedTCPPorts = [ 22 ];
    hostName = "pumba";
    networkmanager.enable = true;
    # nameservers = [ "1.1.1.1" ];
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

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    alacritty
    file # file(1)
    git
    htop
    jq
    killall # killall(1)
    (neovim.override { viAlias = true; vimAlias = true; })
    sqlite-interactive
    tmux
    unzip
    zip
  ];

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
      trusted-users = [ "marin" "supermarin" ]; # enable nix-copy-closure
    };
  };

  system.stateVersion = "21.05";
}

