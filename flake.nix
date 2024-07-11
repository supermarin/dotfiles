{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fonts.url = "git+ssh://git@github.com/supermarin/fonts";
    fonts.flake = false;
    jupyter.url = "git+ssh://git@github.com/squale-capital/jupyter";
    jupyter.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    pcscd-keep-alive.url = "github:supermarin/pcscd-keep-alive";
    pcscd-keep-alive.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
    squale-machine.url = "path:///home/marin/code/squale-capital/machine";
    squale-machine.inputs.nixpkgs.follows = "nixpkgs";
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs: {
      nixosConfigurations = {
        mx-001 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.squale-machine.nixosModules.machine
            ./nixos/configuration-pn50.nix
            ./nixos/hardware-pn50.nix
            ./nixos/modules/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "mx-001";
              system.stateVersion = "23.11";
              squale.machine.enable = true;
            }
          ];
          specialArgs = { inputs = inputs; };
        };

        tokio = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inputs = inputs; };
          modules = [
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
            inputs.home-manager.nixosModules.home-manager
            inputs.lix.nixosModules.default
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            ./nixos/home-manager-config.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/de-gnome.nix
            ./nixos/modules/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              home-manager.users.marin.imports = [
                ./home.nix
                ./home-services.nix
                ./secrets/mail.nix
              ];
              networking.hostName = "tokio";
              system.stateVersion = "22.05";
            }
          ];
        };

        mufasa = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inputs = inputs; };
          modules = [
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.home-manager.nixosModules.home-manager
            inputs.jupyter.nixosModules.x86_64-linux.jupyterlab
            ./nixos/configuration.nix
            ./nixos/hardware-computer-1.nix
            ./nixos/home-manager-config.nix
            ./nixos/modules/de-gnome.nix
            ./nixos/modules/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              home-manager.users.marin.imports = [
                ./home.nix
                ./home-services.nix
              ];
              networking.hostName = "mufasa";
              system.stateVersion = "23.11";
            }
            ({config,...}: {
              services = rec {
                jupyterlab = {
                  enable = true;
                  port = 3333;
                  subpath = "/jupyter";
                  user = "marin";
                  ip = "0.0.0.0"; # doesn't get through the firewall so should be ok
                };
                nginx = {
                  enable = true;
                  virtualHosts.${config.networking.hostName} = {
                    locations."/jupyter/" = {
                      proxyPass = "http://127.0.0.1:${toString jupyterlab.port}${jupyterlab.subpath}/";
                      proxyWebsockets = true;
                      recommendedProxySettings = true;
                    };
                  };
                };
              };
            })
          ];
        };

        tokio-vm = inputs.nixpkgs.lib.nixosSystem {
          # deployed on vmware mbp
          system = "x86_64-linux";
          specialArgs = { inputs = inputs; };
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
          specialArgs = { inputs = inputs; };
        };

        vpn = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration-vpn.nix ./nixos/hardware-linode.nix ];
        };
      };
    };
}
