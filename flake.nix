{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fonts = {
      url = "git+ssh://git@github.com/supermarin/fonts";
      flake = false;
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pcscd-keep-alive = {
      url = "github:supermarin/pcscd-keep-alive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "git+ssh://git@github.com/mitchellh/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    # zed = {
    #   url = "github:zed-industries/zed";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    squale-machine = {
      url = "git+ssh://git@github.com/squale-capital/machine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # gateway.url = "";
    jupyter = {
      url = "git+ssh://git@github.com/squale-capital/jupyter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
    };
    sharadar = {
      url = "git+ssh://git@github.com/squale-capital/sharadar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
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

  outputs =
    inputs: {
      nixosConfigurations = {
        mx-001 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.gateway.nixosModules.ibkr
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
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            ./nixos/home-manager-config.nix
            ./nixos/modules/de-cosmic.nix
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
          specialArgs = { inputs = inputs; };
          modules = [
            inputs.jupyter.nixosModules.x86_64-linux.jupyterlab
            ./nixos/configuration.nix
            ./nixos/hardware-computer-1.nix
            ./nixos/home-manager-config.nix
            ./nixos/modules/de-sway.nix
            ./nixos/modules/de-cosmic.nix
            ./nixos/modules/syncthing.nix
            ./nixos/nixpkgs-config.nix
            {
              networking.hostName = "mufasa";
              system.stateVersion = "23.11";
            }
            ({pkgs, config, ...}: {
              services = {
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
                caddy = {
                  enable = true;
      	            #  virtualHosts."${config.networking.hostName}.TODO.ts.net".extraConfig = ''
      	            #    reverse_proxy /jupyter* http://127.0.0.1:${toString config.services.jupyterlab.port}
      	            #    rewrite /code* /
      	            #    reverse_proxy http://127.0.0.1:${toString config.services.openvscode-server.port}
      	            #  '';
# virtualHosts.":80".extraConfig = ''
                    virtualHosts."http://${config.networking.hostName}".extraConfig = ''
                      reverse_proxy /jupyter* http://127.0.0.1:${toString config.services.jupyterlab.port}
                      rewrite /code* /
                      reverse_proxy http://127.0.0.1:${toString config.services.openvscode-server.port}
                    '';
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
      };
    };
}
