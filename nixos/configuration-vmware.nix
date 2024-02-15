{ inputs, config, pkgs, secrets, ... }:
{
  imports = [ ./fonts.nix ];

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

  environment.systemPackages = with pkgs; [
    dig
    file # file(1)
    killall # killall(1)
    unzip
    zip
  ];

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
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
    nixPath = [
      "nixpkgs=/etc/nix/channels/nixpkgs"
    ];
  };
}

