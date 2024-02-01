{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    nixos-hardware.url = github:NixOS/nixos-hardware;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fonts.url = git+ssh://git@github.com/supermarin/fonts;
    fonts.flake = false;
    nixos-generators.url = github:nix-community/nixos-generators;
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    pcscd-keep-alive.url = github:supermarin/pcscd-keep-alive;
    pcscd-keep-alive.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs: {
      nixosConfigurations = {

        mx-001 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration-pn50.nix
            ./nixos/hardware-pn50.nix
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marin = {
                home.stateVersion = "22.05";
                imports = [
                  ./home.nix
                  ./home-services.nix
                  ./secrets/mail.nix
                ];
              };
            }
          ];
          specialArgs = {
            nixpkgs = inputs.nixpkgs;
            # pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          }
          // {
            # DE
            berkeley = (import inputs.fonts { pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; });
          };
        };


        tokio = inputs.nixpkgs.lib.nixosSystem {
          system = "x85_64-linux";
          specialArgs = {
            nixpkgs = inputs.nixpkgs;
            berkeley = (import inputs.fonts { pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; });
          };
          modules = [
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin = {
                home.stateVersion = "22.05";
                imports = [
                  ./home.nix
                  ./home-services.nix
                  ./secrets/mail.nix
                ];
              };
            }
          ];
        };
        tokio-vm = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgs = inputs.nixpkgs; };
          modules = [
            ./nixos/configuration-vmware.nix
            ./nixos/hardware-vmware.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marin.imports = [
                ./home.nix
              ];
            }
          ];
        };
        personal = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration-personal.nix ];
          specialArgs = { nixpkgs = inputs.nixpkgs; };
        };
        vpn = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration-vpn.nix ./nixos/hardware-linode.nix ];
        };
      };
    };
}
