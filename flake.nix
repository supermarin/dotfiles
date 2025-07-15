{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    asdcontrol = {
      url = "github:supermarin/asdcontrol";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    fonts = {
      url = "git+ssh://git@github.com/supermarin/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    jupyter = {
      url = "git+ssh://git@github.com/squale-capital/jupyter";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steven-black-hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    {
      packages.x86_64-linux.carbon-iso = self.nixosConfigurations.carbon.config.system.build.isoImage;

      nixosConfigurations = {
        carbon = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.disko.nixosModules.disko
            ./nixos/hardware-x1-carbon.nix
            ./nixos/disko/x1-carbon.nix
            ./nixos/configuration.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/modules/home-gui.nix
            ./nixos/modules/fingerprint.nix
            ./nixos/modules/services/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "carbon";
              system.stateVersion = "25.05";
            }
          ];
        };

        tokio = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/modules/home-gui.nix
            ./nixos/modules/fingerprint.nix
            ./nixos/modules/services/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "tokio";
              system.stateVersion = "22.05";
            }
          ];
        };

        mufasa = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            inputs.jupyter.nixosModules.x86_64-linux.jupyterlab
            ./nixos/configuration.nix
            ./nixos/hardware-computer-1.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/modules/home-gui.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/move-me-mufasa-services.nix
            ./nixos/modules/services/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "mufasa";
              system.stateVersion = "23.11";
            }
          ];
        };

        # TODO: revise and make playbook for spinning up dev environments
        #   1. create a VM with SSH access
        #   1. ssh-keyscan VM and encrypt dev secrets for the VM
        #   1. TODO: how are we nixos-rebuild or nix build with nixos-generators
        #   1. figure out what to do with syncthing?
        #     1.1 - probably inject it in at the same time as the secrets after ssh-keyscan?
        #     1.1 - option 2 is just add it manually after the machine is up.
        #   1. figure out disko
        dx001 = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/configuration.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/nixpkgs-config.nix
            # ./nixos/modules/services/syncthing.nix
            {
              networking.hostName = "dx001";
              system.stateVersion = "24.11";
              nixpkgs.hostPlatform = "aarch64-linux";
            }
          ];
        };
      };
    };
}
