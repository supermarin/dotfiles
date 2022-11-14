{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/104e7ab416917721b27b8815c3d68969b4dacd29";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    # deploy-rs.url = "github:serokell/deploy-rs";
    # deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators }:
    let
      vm = system: nixos-generators.nixosGenerate {
        system = system;
        modules = [ 
          ./hardware-vm.nix ./configuration-vm.nix 
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
    in {
      packages.aarch64-linux = { tokio-vm = vm "aarch64-linux"; };
      packages.aarch64-darwin = { tokio-vm = vm "aarch64-linux"; };
      packages.x86_64-linux = {
        personal = personal;
        vpn = vpn;
        tokio-vm = vm;
      };

      # deploy.nodes.personal.profiles.system = {
      #   user = "root";
      #   path = deploy-rs.lib.x86_64-linux.activate.nixos
      #     self.nixosConfigurations.personal;
      # };

      # # This is highly advised, and will prevent many possible mistakes
      # checks = builtins.mapAttrs
      #   (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

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
