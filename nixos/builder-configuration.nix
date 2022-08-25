{ pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  # Enable cross-compiling for aarch64-linux
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  swapDevices = [{ device = "/swapfile"; size = 2048; }];
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio" # tokio
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in" # simba
    ];
  };
  networking = {
    firewall = {
      allowedTCPPorts = [ 
          22 # ssh
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    helix
    ripgrep
    fd
  ];

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
    settings = {
      trusted-users = [ "supermarin" ]; # enable nix-copy-closure
    };
  };

  # don't touch
  system.stateVersion = "22.05";
}
