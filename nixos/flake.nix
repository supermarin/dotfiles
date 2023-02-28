{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/a3f612564c15e8471dd17c15efaf7ede83c57763";
    nixpkgs-stable.url = "github:nixos/nixpkgs/22.11"; # for vpn. podman had issues on master
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, darwin, nixos-generators }:
    let
      vm = system: nixos-generators.nixosGenerate {
        system = system;
        modules = [
          ./hardware-vm.nix
          ./configuration-vm.nix
        ];
        format = "qcow";
      khal-overlay = final: prev: {
        khal-nightly = prev.khal.overrideAttrs (drv: rec {
          version = "nightly";
          src = prev.fetchFromGitHub {
            owner = "pimutils";
            repo = "khal";
            rev = "395a396d1396fa08cdb346d190a9a8a8a5ee9885";
            sha256 = "sha256-bBKPXu4pxGJqQ9Y1V4IwYBMKauxKWkaUJb/qcAAPlFA=";
          };
          patches = [ ];
          doCheck = false;
        });
      };
      age-yubi-overlay = final: prev: {
        age-plugin-yubikey-nightly = prev.age-plugin-yubikey.overrideAttrs (drv: rec {
          version = "nightly";
          src = prev.fetchFromGitHub {
            owner = "str4d";
            repo = "age-plugin-yubikey";
            rev = "bf437663af22ba6492fc738d3e1bdf6d6cc2a00a";
            sha256 = "sha256-iqEzwi34E6lPcaDyvzNbc6KH2uuQzouJ6K2MbhPdK1c=";
          };
          cargoDeps = drv.cargoDeps.overrideAttrs (_: {
            inherit src;
            outputHash = "sha256-tSZiHZdZKSfKtlerHoEXNrpYWIcWowWnhKG6DHXe5GA=";
          });
        });
      };
    in
    {
      #packages.aarch64-linux = { tokio-vm = vm "aarch64-linux"; };
      #packages.aarch64-darwin = { tokio-vm = vm "aarch64-linux"; };
      #packages.x86_64-linux = {
      #  tokio-vm = vm "x86_64-linux";
      #};
      nixosConfigurations = {
        tokio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { hostname = "tokio"; nixpkgs = nixpkgs; };
          modules = [
            ./configuration.nix
            ./hardware-x1.nix
            {
              # services.tlp.enable = true; # disabled since GNOME has it's own
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin.imports = [
                ../home.nix
                ../home-services.nix
                ../mail.nix
              ];
            }
          ];
        };
        pumba = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration-pn50.nix
            ./hardware-pn50.nix
          ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        pairing-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-pairing.nix ];
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-personal.nix ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        tokio-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { nixpkgs = nixpkgs; };
          modules = [
            ./configuration-vm.nix
            ./hardware-utm.nix
            {
              boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marin.imports = [
                ../home.nix
              ];
            }
          ];
        };
        vpn = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-vpn.nix ./hardware-linode.nix ];
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
