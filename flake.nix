{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fonts.url = "git+ssh://git@github.com/supermarin/fonts";
    fonts.flake = false;
    # jupyter.url = "git+ssh://git@github.com/squale-capital/jupyter"; # why?
    jupyter.url = "path:/home/marin/code/squale-capital/jupyter";
    jupyter.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    pcscd-keep-alive.url = "github:supermarin/pcscd-keep-alive";
    pcscd-keep-alive.inputs.nixpkgs.follows = "nixpkgs";
    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    squale-machine.url = "path:///home/marin/code/squale-capital/machine";
    squale-machine.inputs.nixpkgs.follows = "nixpkgs";
    gateway.url = "path:/home/marin/code/squale-capital/gateway";
    # sharadar.url = "git+ssh://git@github.com/squale-capital/sharadar";
    sharadar.url = "path:/home/marin/code/squale-capital/sharadar"; # why?
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs: {
      nixosConfigurations = {
        mx-001 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.gateway.nixosModules.ibkr
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.squale-machine.nixosModules.machine
            inputs.sharadar.nixosModules.download-service
            ./nixos/configuration-pn50.nix
            ./nixos/hardware-pn50.nix
            ./nixos/modules/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "mx-001";
              system.stateVersion = "23.11";
              squale.machine.enable = true;
              gateway.ibkr.enable = true;
              services.sharadar-download.enable = true;
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
            inputs.lix.nixosModules.default
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
            ({pkgs, config, ...}: {
              services = rec {
                openvscode-server = {
                  enable = true;
                  host = "127.0.0.1";
                  port = 2345;
                  telemetryLevel = "off";
                  user = "marin";
                  # serverDataDir = "/opt/openvscode-server";
                };
                jupyterlab = {
                  enable = true;
                  port = 3333;
                  subpath = "/jupyter";
                  user = "marin";
                  ip = "0.0.0.0"; # doesn't get through the firewall so should be ok
                  pythonPackages = (p: with p; [
                    altair
                    pandas
                  ]);
                  RLibs = with pkgs.rPackages; [
                    trackeR
                    DT
                    (pkgs.rPackages.buildRPackage {
                      name = "fitfiler";
                      buildInputs = [ pkgs.R tidyverse ];
                      propagatedBuildInputs = [ pkgs.rPackages.leaflet ];
                      src = pkgs.fetchFromGitHub {
                        owner = "grimbough";
                        repo = "FITfileR";
                        rev = "a71bb9eaf4b74343e3613ff079a1ff9c5e793e75";
                        sha256 = "sha256-+Q6K8VKL0syUZLAuTQ7bapK2uuq91joszyH1b0LANq8=";
                      };
                    })
                  ];
                };
                nginx = {
                  enable = true;
                  virtualHosts."${config.networking.hostName}" = {
                    locations."/jupyter/" = {
                      proxyPass = "http://127.0.0.1:${toString jupyterlab.port}${jupyterlab.subpath}/";
                      proxyWebsockets = true;
                      recommendedProxySettings = true;
                    };
                    locations."/" = {
                      proxyPass = "http://127.0.0.1:${toString openvscode-server.port}/";
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
