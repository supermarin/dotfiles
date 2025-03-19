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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    squale-machine = {
      url = "git+ssh://git@github.com/squale-capital/machine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jupyter = {
      url = "git+ssh://git@github.com/squale-capital/jupyter";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steven-black-hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      tokio = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
        };
        modules = [
          {
            services.fprintd.enable = true;
          }
          ./nixos/configuration.nix
          ./nixos/hardware-x1.nix
          ./nixos/home-manager-config.nix
          ./nixos/modules/de-sway.nix
          ./nixos/modules/syncthing.nix
          ./nixos/nixpkgs-config.nix
          {
            networking.hostName = "tokio";
            system.stateVersion = "22.05";
          }
        ];
      };

      mufasa = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
        };
        modules = [
          inputs.jupyter.nixosModules.x86_64-linux.jupyterlab
          ./nixos/configuration.nix
          ./nixos/hardware-computer-1.nix
          ./nixos/home-manager-config.nix
          ./nixos/modules/de-sway.nix
          ./nixos/modules/syncthing.nix
          ./nixos/nixpkgs-config.nix
          ./nixos/modules/move-me-mufasa-services.nix
          {
            networking.hostName = "mufasa";
            system.stateVersion = "23.11";
          }
        ];
      };

      personal = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/configuration-personal.nix ];
        specialArgs = {
          inputs = inputs;
        };
      };
    };
  };
}
