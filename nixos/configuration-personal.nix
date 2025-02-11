{
  config,
  nixpkgs,
  pkgs,
  modulesPath,
  secrets,
  ...
}:
{

  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];
  boot.cleanTmpDir = true;
  networking.hostName = "personal";
  networking.firewall.allowedTCPPorts = [
    80
    443
    22
  ];

  security = (import ../secrets/personal.nix).security;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.mutableUsers = false;
  users.users = {
    git = {
      createHome = true;
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
    };
  };

  services.nginx = with config.services; {
    enable = true;
    virtualHosts = (import ../secrets/personal.nix).virtualHosts;
  };

  environment.systemPackages = with pkgs; [
    (neovim.override { vimAlias = true; })
    git
  ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      trusted-users = [ "git" ];
    };
  };

  # don't touch
  system.stateVersion = "22.05";
}
