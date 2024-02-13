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
    ghostty.url = git+ssh://git@github.com/mitchellh/ghostty;
  };

  outputs =
    inputs: {
      nixosConfigurations = {
        parallels = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            inputs.home-manager.nixosModules.home-manager
            ./nixos/configuration-pn50.nix
            ./nixos/hardware-parallels.nix
            ./nixos/home-manager-config.nix
            ./nixos/nixpkgs-config.nix
            {
              system.stateVersion = "23.11";
              home-manager.users.marin.imports = [ ./home.nix ];
            }
          ];
          specialArgs = { inputs = inputs; };
        };


        mx-001 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
            ./nixos/configuration-pn50.nix
            ./nixos/hardware-pn50.nix
            ./nixos/home-manager-config.nix
            {
              system.stateVersion = "23.11";
              home-manager.users.marin.imports = [ ./home.nix ./home-services.nix ];
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
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            ./nixos/home-manager-config.nix
            ./nixos/nixpkgs-config.nix
            {
              system.stateVersion = "22.05";
              home-manager.users.supermarin.imports = [
                ./home.nix
                ./home-services.nix
                ./secrets/mail.nix
              ];
            }
          ];
        };

        tokio-vm = inputs.nixpkgs.lib.nixosSystem {
          # deployed on vmware mbp
          system = "x86_64-linux";
          specialArgs = { nixpkgs = inputs.nixpkgs; };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./nixos/configuration-vmware.nix
            ./nixos/hardware-vmware.nix
            ./nixos/home-manager-config.nix
            {
              system.stateVersion = "23.11";
              home-manager.users.marin.imports = [ ./home.nix ];
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
