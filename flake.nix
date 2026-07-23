{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    asdcontrol = {
      url = "github:supermarin/asdcontrol";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fonts = {
      url = "git+ssh://git@github.com/supermarin/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    jupyter = {
      url = "git+ssh://git@github.com/squale-capital/jupyter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steven-black-hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    monstar = {
      url = "github:rockorager/monstar";
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
            ./nixos/hardware-x1-nano.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/modules/home-gui.nix
            ./nixos/modules/tpm.nix
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
            inputs.jupyter.nixosModules.jupyterlab
            # inputs.jupyter.nixosModules.marimo
            ./nixos/configuration.nix
            ./nixos/hardware-computer-1.nix
            ./nixos/modules/home-manager-config.nix
            ./nixos/modules/home-gui.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/move-me-mufasa-services.nix
            ./nixos/modules/services/syncthing.nix
            ./nixos/modules/tpm.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "mufasa";
              system.stateVersion = "23.11";
            }
          ];
        };
      };
    };
}
