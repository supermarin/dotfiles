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
    let
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
    in
    {
      nixosConfigurations = {
        tokio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            ./configuration.nix
            ./hardware-x1.nix
            {
              nixpkgs.overlays = [ khal-overlay ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.supermarin.imports = [
                ../home.nix
                ../home-services.nix
                ../secrets/mail.nix
              ];
            }
          ];
        };
        tokio-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration-vmware.nix
            ./hardware-vmware.nix
            {
              nixpkgs.overlays = [ khal-overlay ];
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
        pumba = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.default
            sharadar.nixosModules.default
            ./configuration-pn50.nix
            ./hardware-pn50.nix
          ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-personal.nix ];
          specialArgs = { nixpkgs = nixpkgs; };
        };
        vpn = nixpkgs.lib.nixosSystem {
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
