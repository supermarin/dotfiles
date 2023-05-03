{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    lgufbrightness.url = "github:supermarin/lguf-brightness/b3d76e9ba733d704f58c55e01c00fff95dfa5977";
    lgufbrightness.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators, lgufbrightness }@inputs:
    let
      secrets = import ../secrets/secrets.nix;
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
          specialArgs = { inputs = inputs; nixpkgs = nixpkgs; secrets = secrets; lgufbrightness = lgufbrightness.defaultPackage."x86_64-linux"; };
          modules = [
            ./configuration.nix
            ./hardware-x1.nix
            {
              services.tlp.enable = true;
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
        pumba = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration-pn50.nix
            ./hardware-pn50.nix
          ];
          specialArgs = { nixpkgs = nixpkgs; secrets = secrets; };
        };
        pairing-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-pairing.nix ];
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-personal.nix ];
          specialArgs = { nixpkgs = nixpkgs; secrets = secrets; };
        };
        vpn = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration-vpn.nix ./hardware-linode.nix ];
          specialArgs = { secrets = secrets; };
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
