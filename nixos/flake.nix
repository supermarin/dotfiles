{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:lnl7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = github:nix-community/nixos-generators;
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators }:
  {
    packages.x86_64-linux = {
      vpn = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./vpn-configuration.nix
          { virtualisation.digitalOceanImage.compressionMethod = "bzip2"; }
        ];
        format = "do";
      };
    };

    nixosConfigurations = {
      tokio = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix 
          ./hardware-x1.nix
          {
            # services.tlp.enable = true; # disabled since GNOME has it's own
            services.fwupd.enable = true;
          }
          { 
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.home-manager.flake = home-manager;
          }
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.users.supermarin = import ../home.nix;
          }
        ];
        specialArgs = { hostname = "tokio"; };
      };

      pumba = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-pn50.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.users.supermarin = import ../home.nix;
          }
        ];
        specialArgs = { hostname = "pumba"; };
      };

      vpn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./vpn-configuration.nix
        ];
        specialArgs = { hostname = "vpn"; };
      };
    };
    
    darwinConfigurations = {
      simba = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          ./darwin.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.users.supermarin = import ../home.nix;
          }
        ];
      };
    };

  };
}
