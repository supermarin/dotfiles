{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
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
        ];
        specialArgs = inputs // { hostname = "tokio"; };
      };
      pumba = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-pn50.nix
        ];
        specialArgs = inputs // { hostname = "pumba"; };
      };
    };
  };
}
