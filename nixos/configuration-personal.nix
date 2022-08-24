{ config, pkgs, modulesPath, ... }:
{

  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  # imports = [
    # ./hardware-configuration.nix
    # ./networking.nix # generated at runtime by nixos-infect    
  # ];

  swapDevices = [{device = "/swapfile"; size = 2048;}];
  boot.cleanTmpDir = true;
  networking.hostName = "nix";
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  security.sudo.wheelNeedsPassword = false;
  security.acme = {
    acceptTerms = true;
    email = "admin+acme@supermar.in"; # TODO: switch to mar.in
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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio"
      ];
    };
  };

  services.nginx = with config.services; {
    enable = true;
    virtualHosts."supermar.in" = {
      forceSSL = true;
      enableACME = true;
      root = "/repos/supermar.in/result/public";
    };
    virtualHosts."mar.in" = {
      forceSSL = true;
      enableACME = true;
      root = "/repos/supermar.in/result/public";
    };
    virtualHosts."butte.rs" = {
      forceSSL = true;
      enableACME = true;
      root = "/repos/butte.rs.git/result/public";
    };
  };

  environment.systemPackages = with pkgs; [
    (neovim.override { vimAlias = true; })
    git
    wallabag
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
}
