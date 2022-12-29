{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators }:
    let
      vm = system: nixos-generators.nixosGenerate {
        system = system;
        modules = [
          ./hardware-vm.nix
          ./configuration-vm.nix
        ];
        format = "qcow";
      };
      vpn = nixos-generators.nixosGenerate {
        modules = [
          ./vpn-configuration.nix
          { virtualisation.digitalOceanImage.compressionMethod = "bzip2"; }
        ];
        format = "do";
      };
      personal = nixos-generators.nixosGenerate {
        modules = [
          ./configuration-personal.nix
          { virtualisation.digitalOceanImage.compressionMethod = "bzip2"; }
        ];
        format = "do";
      };
    in
    {
      packages.aarch64-linux = { tokio-vm = vm "aarch64-linux"; };
      packages.aarch64-darwin = { tokio-vm = vm "aarch64-linux"; };
      packages.x86_64-linux = {
        personal = personal "x86_64-linux";
        vpn = vpn "x86_64-linux";
        tokio-vm = vm "x86_64-linux";
      };

      nixosConfigurations = {
        tokio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgs = nixpkgs; };
          modules = [
            ./configuration.nix
            ./hardware-x1.nix
            {
              # services.tlp.enable = true; # disabled since GNOME has it's own
              services.fwupd.enable = true;
              boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin = import ../home.nix;
            }
          ];
          specialArgs = { hostname = "pumba"; };
        };

        pairing-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-pairing.nix ];
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-personal.nix ];
          specialArgs = { hostname = "personal"; };
        };
        vpn = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./vpn-configuration.nix ];
          specialArgs = { hostname = "vpn"; };
        };
      };

      darwinConfigurations = {
        simba = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { nixpkgs = nixpkgs; };
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin = import ../home.nix;
            }
          ];
        };
      };
    };
}
