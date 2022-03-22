{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = github:lnl7/nix-darwin/master;
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }: {

    nixosConfigurations = {
      tokio = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix 
          ./hardware-x1.nix
          ({ config, pkgs, ... }: {
            services.fwupd.enable = true;
            services.tlp.enable = true;
          })
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

      popvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            services.xserver = {
              enable = true;
              # videoDrivers = [ "iommu" ];
              videoDrivers = [ "virtio" ];
              displayManager.gdm.enable = true;
              desktopManager.gnome.enable = true;
            };

            services.qemuGuest.enable = true;
            services.spice-vdagentd.enable = true;

            environment.gnome.excludePackages = with pkgs.gnome; [
              cheese pkgs.gnome-photos gnome-music gedit
              pkgs.epiphany pkgs.evince gnome-characters totem tali hitori
              atomix
            ];

            environment.systemPackages = [
              pkgs.gnomeExtensions.pop-shell
            ];

            users.users.supermarin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialHashedPassword = "$6$WWYEnfo5cQm5paCr$Uhr4EebRNFp9h22QG1lK5j9SHkzGxykQErDMF9sphu3UVusqTUskBM564/RjuTQXZjIBCuFy0Qo56Auth6xC6/";
            };
          })
        ];
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
