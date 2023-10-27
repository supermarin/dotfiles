{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    fonts.url = github:supermarin/fonts;
    fonts.flake = false;
    darwin.url = github:lnl7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = github:nix-community/nixos-generators;
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lgufbrightness.url = github:supermarin/lguf-brightness;
    lgufbrightness.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    nix-doom-emacs.url = github:librephoenix/nix-doom-emacs?ref=pgtk-patch;
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs: {
      nixosConfigurations = {
        tokio = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            nixpkgs = inputs.nixpkgs;
            lgufbrightness = inputs.lgufbrightness.defaultPackage."x86_64-linux";
            berkeley = (import inputs.fonts { pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; });
          };
          modules = [
            inputs.agenix.nixosModules.default
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin = {
                # inherit agenix;
                home.stateVersion = "22.05";
                imports = [
                  ./home.nix
                  ./home-services.nix
                  ./secrets/mail.nix
                  inputs.nix-doom-emacs.hmModule
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
      darwinConfigurations = {
        simba = inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { nixpkgs = inputs.nixpkgs; };
          modules = [
            ./nixos/darwin.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin = import ./home.nix;
            }
          ];
        };
      };
    };
}
