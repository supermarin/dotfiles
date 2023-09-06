{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:lnl7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = github:nix-community/nixos-generators;
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lgufbrightness.url = github:supermarin/lguf-brightness/b3d76e9ba733d704f58c55e01c00fff95dfa5977;
    lgufbrightness.inputs.nixpkgs.follows = "nixpkgs";
    jupyter.url = github:squale-capital/jupyter;
    jupyter.inputs.nixpkgs.follows = "nixpkgs";
    sharadar.url = github:squale-capital/sharadar;
    sharadar.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = github:ryantm/agenix;
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators, lgufbrightness, jupyter, sharadar, agenix }:
    {
      nixosConfigurations = {
        tokio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgs = nixpkgs; lgufbrightness = lgufbrightness.defaultPackage."x86_64-linux"; };
          modules = [
            agenix.nixosModules.default
            ./nixos/configuration.nix
            ./nixos/hardware-x1.nix
            home-manager.nixosModules.home-manager
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
        tokio-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgs = nixpkgs; };
          modules = [
            ./nixos/configuration-vmware.nix
            ./nixos/hardware-vmware.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marin.imports = [
                ./home.nix
              ];
            }
          ];
        };
        pumba = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            jupyter.nixosModules."x86_64-linux".jupyterlab
            sharadar.nixosModules."x86_64-linux".download-service
            # fin.nixosModules."x86_64-linux".fin-deploy
            ./nixos/hardware-pn50.nix
            ./nixos/configuration-pn50.nix
          ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration-personal.nix ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        vpn = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/configuration-vpn.nix ./nixos/hardware-linode.nix ];
        };
      };
      darwinConfigurations = {
        simba = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { nixpkgs = nixpkgs; };
          modules = [
            ./nixos/darwin.nix
            home-manager.darwinModules.home-manager
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
