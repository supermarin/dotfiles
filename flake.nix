{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    asdcontrol = {
      # url = "github:supermarin/asdcontrol";
      url = "path:/home/marin/code/oss/asdcontrol";
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
    pcscd-keep-alive = {
      url = "github:supermarin/pcscd-keep-alive";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    squale-machine = {
      url = "git+ssh://git@github.com/squale-capital/machine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # gateway.url = "";
    jupyter = {
      # url = "git+ssh://git@github.com/squale-capital/jupyter";
      url = "path:/home/marin/code/squale-capital/jupyter";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sharadar = {
      url = "git+ssh://git@github.com/squale-capital/sharadar";
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
    yubikey-agent = {
      url = "github:supermarin/yubikey-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      mx-001 = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # inputs.gateway.nixosModules.ibkr
          inputs.squale-machine.nixosModules.machine
          inputs.sharadar.nixosModules.x86_64-linux.download-service
          ./nixos/configuration-pn50.nix
          ./nixos/hardware-pn50.nix
          ./nixos/modules/syncthing.nix
          ./nixos/nixpkgs-config.nix
          {
            networking.hostName = "mx-001";
            system.stateVersion = "23.11";
            squale.machine.enable = true;
            # gateway.ibkr.enable = true;
            services.sharadar-download.enable = true;
          }
        ];
        specialArgs = {
          inputs = inputs;
        };
      };

      tokio = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
        };
        modules = [
          inputs.asdcontrol.modules.asdcontrol
          {
            programs.asdcontrol.enable = true;
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

      tokio-vm = inputs.nixpkgs.lib.nixosSystem {
        # deployed on vmware mbp
        system = "x86_64-linux";
        specialArgs = {
          inputs = inputs;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nixos/configuration-vmware.nix
          ./nixos/hardware-vmware.nix
          ./nixos/home-manager-config.nix
          ./nixos/nixpkgs-config.nix
          {
            system.stateVersion = "23.05";
            home-manager.users.marin.imports = [ ./home.nix ];
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
