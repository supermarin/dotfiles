{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/c869aa9ac9553c49ee7dff9ac7f8f510b1e8d5f7;
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
      tokio-vm = nixos-generators.nixosGenerate {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        modules = [
          # ./configuration.nix
        ];
        format = "qcow";
        # specialArgs = { hostname = "tokio"; };
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
            boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
          }
          home-manager.nixosModules.home-manager {
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
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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

      butters = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          {
            boot.loader.efi.canTouchEfiVariables = true;
            boot.loader.grub = {
              enable = true;
              device = "nodev";
              efiSupport = true;
            };
            # environment.systemPackages = with pkgs; [
            #   file # file(1)
            #   firefox
            #   killall # killall(1)
            #   unzip
            # ];
            hardware.pulseaudio.enable = true;
            hardware.bluetooth.enable = true; # enables bluez
            programs.ssh.startAgent = true;
            sound.enable = true;
            services.openssh.enable = true;
            nix = {
              settings = {
                trusted-users = [ "supermarin" ]; # enable nix-copy-closure
              };
              extraOptions = ''
              experimental-features = nix-command flakes
              '';
              gc = {
                automatic = true;
                dates = "monthly";
              };
              optimise = {
                automatic = true;
                dates = [ "monthly" ];
              };
            };
            time.timeZone = "America/NewYork";
            users.users.supermarin = {
              # shell = pkgs.fish;
              isNormalUser = true;
              extraGroups = [ "wheel" ]; 
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio"
              ];
            };
          }
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
            home-manager.useUserPackages = true;
            home-manager.users.supermarin = import ../home.nix;
          }
        ];
      };
    };

  };
}
