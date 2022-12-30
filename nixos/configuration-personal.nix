{ config, nixpkgs, pkgs, modulesPath, hostname, ... }:
{

  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  swapDevices = [{ device = "/swapfile"; size = 2048; }];
  boot.cleanTmpDir = true;
  networking.hostName = hostname;
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  security.sudo.wheelNeedsPassword = false;
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin+acme@mar.in"; # TODO: switch to mar.in
  };

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
      openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix pkgs;
    };
  };

  services.nginx = with config.services; rec {
    enable = true;
    virtualHosts."mar.in" = {
      forceSSL = true;
      enableACME = true;
      root = "/repos/mar.in/result/public";
    };
    virtualHosts."supermar.in" = virtualHosts."mar.in";
    virtualHosts."butte.rs" = {
      forceSSL = true;
      enableACME = true;
      root = "/repos/butte.rs.git/result/public";
    };
  };

  environment.systemPackages = with pkgs; [
    (neovim.override { vimAlias = true; })
    git
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # don't touch
  system.stateVersion = "22.05";
}
